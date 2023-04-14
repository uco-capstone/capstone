import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createDailyNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: 'Kirby Says',
      body: 'Remember to do your task!!! I\'m getting hungry :(',
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationCalendar(
      allowWhileIdle: true,
      repeats: true,
      hour: 14,
      minute: 0,
      second: 0,
      millisecond: 0,
    ),
  );
}
