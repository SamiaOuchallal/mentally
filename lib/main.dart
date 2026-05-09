import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/notifications_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Paris'));

  await NotificationService().init();

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
  State<MentallyApp> createState() => _MentallyAppState();
}

class _MentallyAppState extends State<MentallyApp> {
  double textScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadTextSize();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentally',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
