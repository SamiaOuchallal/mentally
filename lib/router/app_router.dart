import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/calendar/calendar_page.dart';
import '../features/progress/progress_page.dart';
import '../features/settings/settings_page.dart';
import '../features/videos/videos_page.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressPage());
      case '/calendar':
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case '/videos':
        return MaterialPageRoute(builder: (_) => const VideosPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
