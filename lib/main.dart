import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/notifications_services.dart';

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

class MentallyApp extends StatelessWidget {
  const MentallyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentally',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.generate,
      initialRoute: '/',
    );
  }
}
