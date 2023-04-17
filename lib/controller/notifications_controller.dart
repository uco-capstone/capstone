import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';

List<String> messages = [
  'Complete your tasks or I will eat your money! 👿',
  'Don\'t forget your tasks!',
  'It\'s getting lonely here... Don\'t forget your tasks!',
  'Wow so much to do still!',
  'Do your tasks you lazy bum!',
];

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createDailyNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: 'Kirby Says',
      body: messages[Random().nextInt(messages.length)],
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
