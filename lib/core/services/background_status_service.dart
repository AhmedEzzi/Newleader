import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leader_company/core/di/injection_container.dart';
import 'package:leader_company/core/api/api_provider.dart';

class BackgroundStatusService {
  static const String _taskName = 'status_check_task';
  static const String _channelId = 'com.services.fixman';
  static const String _channelName = 'Status Updates';
  static const String _lastStatusKey = 'last_checked_status';
  static const String _lastNotificationTimeKey = 'last_notification_time';

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the background service
  static Future<void> initialize() async {
    // Initialize WorkManager
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    // Initialize local notifications
    await _initializeNotifications();

    // Register the periodic task
    await _registerPeriodicTask();
  }

  /// Initialize local notifications for background tasks
  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(initSettings);

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for status updates',
      importance: Importance.high,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Register the periodic background task
  static Future<void> _registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  /// Cancel the background task
  static Future<void> cancelTask() async {
    await Workmanager().cancelByUniqueName(_taskName);
  }

  /// Check if background task is running
  static Future<bool> isTaskRunning() async {
    // This is a workaround since WorkManager doesn't provide direct status check
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('background_task_active') ?? false;
  }

  /// Set task status
  static Future<void> setTaskStatus(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('background_task_active', isActive);
  }
}

/// Background task callback - must be top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('🔄 Background task started: $task');

    try {
      await _checkStatusAndNotify();
      return Future.value(true);
    } catch (e) {
      debugPrint('❌ Background task error: $e');
      return Future.value(true); // Return true to prevent retry loops
    }
  });
}

/// Check for status updates and show notifications
Future<void> _checkStatusAndNotify() async {
  try {
    // Initialize notifications in background isolate
    await _initializeBackgroundNotifications();

    // Get last checked status
    final prefs = await SharedPreferences.getInstance();
    final lastStatus = prefs.getString(BackgroundStatusService._lastStatusKey);
    final lastNotificationTime =
        prefs.getInt(BackgroundStatusService._lastNotificationTimeKey) ?? 0;

    // Check if we should skip notification (avoid spam)
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeSinceLastNotification = now - lastNotificationTime;
    const minNotificationInterval =
        5 * 60 * 1000; // 5 minutes minimum between notifications

    // Fetch latest status from API
    final latestStatus = await _fetchLatestStatus();

    if (latestStatus == null) {
      debugPrint('⚠️ No status data received from API');
      return;
    }

    debugPrint('📊 Status check - Last: $lastStatus, Latest: $latestStatus');

    // Check if status has changed
    if (lastStatus != latestStatus) {
      // Update stored status
      await prefs.setString(
        BackgroundStatusService._lastStatusKey,
        latestStatus,
      );

      // Show notification only if enough time has passed since last notification
      if (timeSinceLastNotification >= minNotificationInterval) {
        await _showStatusNotification(latestStatus);
        await prefs.setInt(
          BackgroundStatusService._lastNotificationTimeKey,
          now,
        );
        debugPrint('✅ Status notification sent: $latestStatus');
      } else {
        debugPrint('⏰ Notification skipped - too soon since last notification');
      }
    } else {
      debugPrint('ℹ️ No status change detected');
    }
  } catch (e) {
    debugPrint('❌ Error in status check: $e');
  }
}

/// Initialize notifications in background isolate
Future<void> _initializeBackgroundNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await BackgroundStatusService._notifications.initialize(initSettings);

  // Create notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    BackgroundStatusService._channelId,
    BackgroundStatusService._channelName,
    description: 'Notifications for status updates',
    importance: Importance.high,
  );

  await BackgroundStatusService._notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

/// Fetch latest status from your API
Future<String?> _fetchLatestStatus() async {
  try {
    // Replace with your actual API endpoint
    final apiProvider = sl<ApiProvider>();

    // Example API call - replace with your actual implementation
    final response = await apiProvider
        .get('/status/check')
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.data);

      // Extract status from response - adjust based on your API structure
      if (data['success'] == true && data['data'] != null) {
        return data['data']['status']?.toString() ??
            data['data']['order_status']?.toString() ??
            data['data']['status_code']?.toString();
      }
    }

    debugPrint('⚠️ API returned status code: ${response.statusCode}');
    return null;
  } catch (e) {
    debugPrint('❌ Error fetching status: $e');
    return null;
  }
}

/// Show status update notification
Future<void> _showStatusNotification(String status) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    BackgroundStatusService._channelId,
    BackgroundStatusService._channelName,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    showWhen: true,
    icon: '@mipmap/ic_launcher',
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  // Generate unique notification ID
  final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  await BackgroundStatusService._notifications.show(
    notificationId,
    'Status Update',
    'Your order status has been updated to: $status',
    notificationDetails,
    payload: 'status_update_$status',
  );
}

/// Manual status check (for testing)
Future<void> checkStatusManually() async {
  await _checkStatusAndNotify();
}
