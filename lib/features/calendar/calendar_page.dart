import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../widgets/app_scaffold.dart';
import 'calendar_repo.dart';
import 'mood_day_detail_page.dart';
import 'package:mentally/theme/app_mood_emojis.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final repo = CalendarRepository();
  Map<DateTime, Map<String, dynamic>> moodsByDay = {};
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMonth(focusedDay);
  }

  Future<void> _loadMonth(DateTime month) async {
    final moods = await repo.getMoodsForMonth(month);

    final map = <DateTime, Map<String, dynamic>>{};

    for (var m in moods) {
      final date = m['date']; // déjà local
      final key = DateUtils.dateOnly(date);

      // moods est trié DESC = le plus récent
      if (!map.containsKey(key)) {
        map[key] = m;
      }
    }

    setState(() => moodsByDay = map);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Calendrier",
      currentIndex: 2,
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/progress');
            break;
          case 2:
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/videos');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2030),
          focusedDay: focusedDay,

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          eventLoader: (day) {
            final key = DateUtils.dateOnly(day);
            return moodsByDay.containsKey(key) ? [moodsByDay[key]] : [];
          },

          onPageChanged: (newMonth) {
            focusedDay = newMonth;
            _loadMonth(newMonth);
          },

          onDaySelected: (selected, _) async {
            final mood = await repo.getMoodForDay(DateUtils.dateOnly(selected));
            if (mood != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MoodDayDetailPage(mood: mood),
                ),
              );
            }
          },

          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors
                  .transparent, // on laisse transparent si on met un emoji
              shape: BoxShape.circle,
            ),
          ),

          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                final event = events.first as Map<String, dynamic>;
                final mood = event['mood'];
                return Text(
                  moodEmojis[mood] ?? '',
                  style: const TextStyle(fontSize: 20),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
