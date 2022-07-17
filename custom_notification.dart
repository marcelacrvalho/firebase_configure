import 'package:app_adove/app/routes/app_routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

class NotificationService {
  static NotificationService get to => Get.find<NotificationService>();
  
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;
  late IOSNotificationDetails iosDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    const _android =
        AndroidInitializationSettings('assets/images/icon-background.png');
    const _ios = IOSInitializationSettings();

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: _android,
        iOS: _ios,
      ),
      onSelectNotification: _onSelectedNotification,
    );
  }

  _onSelectedNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Get.offNamed(Routes.INITIAL);
    }
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
    iosDetails = const IOSNotificationDetails();

    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      _onSelectedNotification(details.payload);
    }
  }
}
