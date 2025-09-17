import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:leader_company/core/services/status_check_service.dart';

class NotificationManager {
  static const String _channelId = 'com.services.fixman';
  static const String _channelName = 'Status Updates';
  static const String _channelDescription =
      'Notifications for order status updates';

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification manager
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notification tapped: ${response.payload}');

    // Handle different notification types based on payload
    if (response.payload != null) {
      if (response.payload!.startsWith('status_update_')) {
        // Navigate to orders screen or specific order
        _handleStatusUpdateNotification(response.payload!);
      }
    }
  }

  /// Handle status update notification tap
  static void _handleStatusUpdateNotification(String payload) {
    // Extract order ID or status from payload
    final parts = payload.split('_');
    if (parts.length >= 3) {
      final orderId = parts[2];
      debugPrint('📦 Opening order: $orderId');
      // TODO: Navigate to order details screen
    }
  }

  /// Show status update notification
  static Future<void> showStatusUpdateNotification(StatusUpdate update) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: BigTextStyleInformation(
            update.statusChangeText,
            contentTitle: 'Order Status Update',
            summaryText: 'Tap to view details',
          ),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate unique notification ID
    final notificationId = update.orderId.hashCode;

    await _notifications.show(
      notificationId,
      'Order Status Update - DONE BY A.E',
      '${update.statusChangeText}\n\nDONE BY A.E',
      notificationDetails,
      payload: 'status_update_${update.orderId}',
    );

    debugPrint('✅ Status notification sent for order ${update.orderNumber}');
  }

  /// Show multiple status updates notification
  static Future<void> showMultipleUpdatesNotification(
    List<StatusUpdate> updates,
  ) async {
    if (updates.isEmpty) return;

    final title =
        updates.length == 1
            ? 'Order Status Update'
            : '${updates.length} Order Updates';

    final body =
        updates.length == 1
            ? updates.first.statusChangeText
            : 'You have ${updates.length} order status updates';

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          styleInformation: InboxStyleInformation(
            updates.map((update) => update.statusChangeText).toList(),
            contentTitle: title,
            summaryText: 'Tap to view all updates',
          ),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use timestamp as ID for multiple updates
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notifications.show(
      notificationId,
      '$title - DONE BY A.E',
      '$body\n\nDONE BY A.E',
      notificationDetails,
      payload: 'multiple_status_updates',
    );

    debugPrint(
      '✅ Multiple updates notification sent: ${updates.length} updates',
    );
  }

  /// Show simple status notification
  static Future<void> showSimpleStatusNotification(String status) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
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

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notifications.show(
      notificationId,
      'Status Update - DONE BY A.E',
      'Your order status has been updated to: $status\n\nDONE BY A.E',
      notificationDetails,
      payload: 'status_update_$status',
    );

    debugPrint('✅ Simple status notification sent: $status');
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ All notifications cancelled');
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int notificationId) async {
    await _notifications.cancel(notificationId);
    debugPrint('🗑️ Notification $notificationId cancelled');
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS doesn't have this check
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidPlugin?.requestNotificationsPermission() ?? false;
    }
    return true; // iOS permissions are handled elsewhere
  }
}

