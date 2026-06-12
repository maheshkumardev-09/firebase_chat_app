import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message: ${message.notification?.title}");
}

class NotificationController extends GetxController {
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await _messaging.requestPermission();

    // ✅ Version 22 ka sahi tarika
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notification tapped: ${response.payload}");
      },
    );

    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Chat app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    // ✅ Version 22 — named parameters
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }
}
