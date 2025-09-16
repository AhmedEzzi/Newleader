import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationHelper {
  static Future<void> initialize(FlutterLocalNotificationsPlugin fln) async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await fln.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print("📩 Foreground Notification Received:");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
        print("Data: ${message.data}");
      }
      await showNotification(message, fln);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(" Notification Opened: ${message.data['type']}");
    });
  }

  static Future<void> showNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin fln,
  ) async {
    String? title = message.notification?.title ?? message.data['title'];
    String? body = message.notification?.body ?? message.data['body'];
    String? imageUrl;

    if (Platform.isAndroid) {
      imageUrl =
          message.notification?.android?.imageUrl ?? message.data['image'];
    } else if (Platform.isIOS) {
      imageUrl = message.notification?.apple?.imageUrl ?? message.data['image'];
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        await _showBigPictureNotification(title, body, imageUrl, fln);
      } catch (e) {
        await _showTextNotification(title, body, fln);
      }
    } else {
      await _showTextNotification(title, body, fln);
    }
  }

  static Future<void> _showTextNotification(
    String? title,
    String? body,
    FlutterLocalNotificationsPlugin fln,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          importance: Importance.max,
          priority: Priority.max,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await fln.show(0, title, body, platformDetails);
  }

  static Future<void> _showBigPictureNotification(
    String? title,
    String? body,
    String imageUrl,
    FlutterLocalNotificationsPlugin fln,
  ) async {
    final String largeIconPath = await _downloadAndSaveFile(
      imageUrl,
      'largeIcon',
    );
    final String bigPicturePath = await _downloadAndSaveFile(
      imageUrl,
      'bigPicture',
    );

    final BigPictureStyleInformation bigPictureStyle =
        BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          contentTitle: title,
          summaryText: body,
        );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          styleInformation: bigPictureStyle,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await fln.show(0, title, body, platformDetails);
  }

  static Future<String> _downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

class NotificationBody {
  int? orderId;
  String? type;

  NotificationBody({this.orderId, this.type});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['type'] = type;
    return data;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(
      "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}",
    );
  }
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}
