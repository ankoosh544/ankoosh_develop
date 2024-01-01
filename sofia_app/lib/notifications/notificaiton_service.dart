import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //new code
  final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_launcher');

  void initNotification() async {
    final initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notification.initialize(initializationSettings);
  }

  void sendNotification({
    required int notificationId,
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _notification.show(notificationId, title, body, notificationDetails);
  }
}
