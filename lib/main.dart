import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'services/user_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'daily_channel',
      channelName: 'Rappel quotidien',
      channelDescription: 'Rappel pour noter ton humeur',
      importance: NotificationImportance.High,
    ),
  ]);

  bool allowed = await AwesomeNotifications().isNotificationAllowed();
  if (!allowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await Supabase.initialize(
    url: 'https://cthoiefytkvuclzajjpq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0aG9pZWZ5dGt2dWNsemFqanBxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NDU4NDYsImV4cCI6MjA5MzEyMTg0Nn0.GZAP4oQzta-z3twu6FV2SLMGvwl7BzZD1hvpl2T6Zjo',
  );

  runApp(const MentallyApp());
}

class MentallyApp extends StatefulWidget {
  const MentallyApp({super.key});

  @override
  State<MentallyApp> createState() => MentallyAppState();
}

class MentallyAppState extends State<MentallyApp> {
  double textScale = 1.0;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTextSize();
    _loadDarkMode();
  }

  Future<void> _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    final size = prefs.getString("text_size") ?? "normal";

    setState(() {
      switch (size) {
        case "small":
          textScale = 0.85;
          break;
        case "large":
          textScale = 1.15;
          break;
        case "xlarge":
          textScale = 1.30;
          break;
        default:
          textScale = 1.0;
      }
    });
  }

  Future<void> _loadDarkMode() async {
    final value = await UserPreferences.getDarkMode();
    setState(() => isDark = value);
  }

  void toggleDarkMode(bool value) async {
    await UserPreferences.setDarkMode(value);
    setState(() => isDark = value);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Mentally',
      debugShowCheckedModeBanner: false,
      theme: isDark ? AppTheme.dark : AppTheme.light,
      onGenerateRoute: AppRouter.generate,
      initialRoute: '/',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
          child: child!,
        );
      },
    );
  }
}
