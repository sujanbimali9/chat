import 'package:chat/utils/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotification {
  static String? _pushToken;
  static Future<void> init() async {
    try {
      _pushToken ??= await FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (e) {}
  }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    await NotificationService.showNotification(message);
  }

  static String getToken() {
    return _pushToken!;
  }
}
