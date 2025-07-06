import 'dart:developer';

import 'package:chat/utils/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
class FcmNotification {
  static String? _pushToken;
  static Future<void> init() async {
    try {
      _pushToken ??= await FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');
      });
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (e) {
      log('Error initializing FCM: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    log('Handling a background message: ${message.messageId}');
    await NotificationService.showNotification(message);
  }

  static String getToken() {
    return _pushToken!;
  }
}
