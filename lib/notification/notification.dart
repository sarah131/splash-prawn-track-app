import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notification {
  static final notifier = FlutterLocalNotificationsPlugin();

  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
    );
  }

  static Future init({bool initScheduler = false}) async {
    const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    await notifier.initialize(
      settings,
    );
  }

  static Future showNotifier({int? id, String? title, String? body}) async =>
      notifier.show(
        id!,
        title,
        body,
        await notificationDetails(),
      );
}
