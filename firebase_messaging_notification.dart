import 'package:app_adove/app/data/notification/custom_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseMessagingNotification {
  static FirebaseMessagingNotification get to =>
      Get.find<FirebaseMessagingNotification>();

  final NotificationService _notificationService;

  FirebaseMessagingNotification(this._notificationService);

  Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    getDeviceFirebaseToken();
    _onMessage();
  }

  getDeviceFirebaseToken() async {
    final firebaseToken = await FirebaseMessaging.instance.getToken();
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title,
            body: notification.body,
            payload: message.data['route'] ?? '',
          ),
        );
      }
    });
  }
}
