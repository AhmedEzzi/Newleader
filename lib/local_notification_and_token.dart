import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class GlobalMethods {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<String?> registerNotification(BuildContext context) async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await configureLocalNotifications(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showLocalNotification(message.notification ?? const RemoteNotification());
    });

    try {
      String? token = await firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        return token;
      }
    } catch (error) {
      // AppFunctions.showsToast(error.toString(), AppColors.red, context);
    }
    return null;
  }

  Future<void> configureLocalNotifications(BuildContext context) async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
          'com.services.fixman',
          'fixman',
          importance: Importance.high,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('📩 Notification payload: ${details.payload}');
      },
    );
  }

  void showLocalNotification(RemoteNotification remoteNotification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'com.services.fixman',
          'fixman',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      notificationDetails,
      payload: 'notification_payload',
    );
  }
}
