import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> moodMessages = [
  "Prends 10 secondes pour respirer profondément.",
  "Note ton humeur, c’est important pour toi.",
  "Petit check mental du jour 💛",
  "Comment va ton esprit aujourd’hui ?",
  "Un instant pour toi, juste maintenant.",
  "Tu mérites de prendre soin de toi.",
  "Ton humeur compte vraiment.",
];

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> requestPermission() async {
    bool allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> showTestNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'daily_channel',
        title: "Comment te sens‑tu aujourd’hui ?",
        body: "Pense à enregistrer ton humeur 🌤️",
      ),
    );
  }

  Future<void> scheduleDailyReminder(int hour, int minute) async {
    await AwesomeNotifications().cancelAll();

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("user_name") ?? "";

    moodMessages.shuffle();
    final randomMessage = moodMessages.first;

    final personalizedMessage = userName.isNotEmpty
        ? "$userName, $randomMessage"
        : randomMessage;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'daily_channel',
        title: "Comment te sens‑tu aujourd’hui ?",
        body: personalizedMessage,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
  }
}
