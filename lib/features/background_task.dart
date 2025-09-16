// // lib/background_task.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/foundation.dart';
//
// // نفس القناة اللي بتستخدمها في الأب
// const String kChannelId = 'com.services.fixman';
// const String kChannelName = 'fixman';
//
// // اسم التسك
// const String kPeriodicTaskName = 'check_status_task';
//
// final FlutterLocalNotificationsPlugin _bgNotifications =
// FlutterLocalNotificationsPlugin();
//
// Future<void> _initLocalNotificationsForBg() async {
//   // لازم تهيّأ البلاجن تاني في الـ background isolate
//   const AndroidInitializationSettings androidInit =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
//   const InitializationSettings initSettings =
//   InitializationSettings(android: androidInit, iOS: iosInit);
//
//   await _bgNotifications.initialize(initSettings);
//
//   // إنشاء القناة للأندرويد (لو كانت مش موجودة)
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     kChannelId,
//     kChannelName,
//     importance: Importance.high,
//   );
//
//   await _bgNotifications
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }
//
// Future<void> _showBgNotification({
//   required String title,
//   required String body,
// }) async {
//   const androidDetails = AndroidNotificationDetails(
//     kChannelId,
//     kChannelName,
//     importance: Importance.max,
//     priority: Priority.high,
//     playSound: true,
//     enableVibration: true,
//   );
//   const iosDetails = DarwinNotificationDetails();
//   const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//   await _bgNotifications.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title,
//     body,
//     details,
//     payload: 'bg_status_update',
//   );
// }
//
// /// مثال API: رجّع status من endpoint بتاعك.
// /// عدّل الـ URL وطريقة البارسينج حسب الـ API عندك.
// Future<String?> _fetchLatestStatusFromApi() async {
//   final uri = Uri.parse('https://api.example.com/status'); // عدّلها
//   final res = await http.get(uri).timeout(const Duration(seconds: 15));
//   if (res.statusCode == 200) {
//     final data = jsonDecode(res.body);
//     // مثلاً لو الـ JSON فيه { "status": "NEW" }
//     return data['status']?.toString();
//   }
//   return null;
// }
//
// Future<bool> _checkAndNotify() async {
//   try {
//     await _initLocalNotificationsForBg();
//
//     final prefs = await SharedPreferences.getInstance();
//     final prev = prefs.getString('last_status');
//
//     final latest = await _fetchLatestStatusFromApi();
//     if (latest == null) {
//       if (kDebugMode) debugPrint('No status / API failed');
//       return true; // نرجّع true عشان ما يعتبرها workmanager فشل
//     }
//
//     if (prev == null || prev != latest) {
//       await prefs.setString('last_status', latest);
//       await _showBgNotification(
//         title: 'تحديث جديد',
//         body: 'الـStatus اتغيرت إلى: $latest',
//       );
//     }
//
//     return true;
//   } catch (e) {
//     if (kDebugMode) debugPrint('BG task error: $e');
//     return true; // رجّع true برضه عشان WorkManager ما يعمل Retry Aggressive
//   }
// }
//
// /// مهم: لازم يبقى Top-level function
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // ممكن تفرّق لو عندك Tasks متعددة
//     switch (task) {
//       case kPeriodicTaskName:
//       default:
//         return await _checkAndNotify();
//     }
//   });
// }
