import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        // iOS: IOSInitializationSettings(
        //   requestSoundPermission: true,
        //   requestBadgePermission: true,
        //   requestAlertPermission: true,
        //   defaultPresentAlert: true,
        //   defaultPresentBadge: true,
        //   defaultPresentSound: true,
        // )
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? id) async {
      //   print("onSelectNotification");
      //   if (id!.isNotEmpty) {
      //     print("Router Value1234 $id");
      //
      //   }
      // },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // final sound = 'notification.wav';
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "aheadly",
            "aheadlychannel",
            importance: Importance.max,
            priority: Priority.high,
            // sound: RawResourceAndroidNotificationSound('new_sound')
        ),
        // iOS: IOSNotificationDetails(
        //   presentAlert: true,
        //   presentBadge: true,
        //   presentSound: true,
        //   // sound: 'new_sound.caf'
        // )
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static void enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}