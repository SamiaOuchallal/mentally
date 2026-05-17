import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../widgets/app_scaffold.dart';
import 'calendar_repo.dart';
import 'mood_day_detail_page.dart';
import 'package:mentally/theme/app_mood_emojis.dart';
import 'package:mentally/theme/app_colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final repo = CalendarRepository();
  Map<DateTime, Map<String, dynamic>> moodsByDay = {};
  DateTime focusedDay = DateTime.now();
  DateTime? _selectJour;
  Map<String, dynamic>? _selectHumeur;

  @override
  void initState() {
    super.initState();
    _loadMonth(focusedDay);
  }

  Future<void> _loadMonth(DateTime month) async {
    final moods = await repo.getMoodsForMonth(month);

    final map = <DateTime, Map<String, dynamic>>{};

    for (var m in moods) {
      final date = m['date'];
      final key = DateUtils.dateOnly(date);

      if (!map.containsKey(key)) {
        map[key] = m;
      }
    }

    setState(() => moodsByDay = map);
  }

  String _moisEnFrancais(int mois) {
    const noms = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return noms[mois];
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2022),
                lastDay: DateTime.utc(2220),
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
                  setState(() {
                    _selectJour = selected;
                    _selectHumeur = mood;
                  });
                },

                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),

                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      final event = events.first as Map<String, dynamic>;
                      final mood = event['mood'];
                      final imageName = moodEmojis[mood];
                      if (imageName == null) return null;
                      return Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child: Image.asset(
                          'assets/emojis/$imageName',
                          width: 67,
                          height: 67,
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),

            if (_selectJour != null) ...[
                const Divider(
                  thickness: 2,
                  color: AppColors.blueTeal,
                  indent: 16,
                  endIndent: 16,
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    "${_selectJour!.day} ${_moisEnFrancais(_selectJour!.month)} ${_selectJour!.year}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueDeep,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectHumeur != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MoodDayDetailPage(mood: _selectHumeur!),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Aucune humeur enregistrée ce jour.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],

          ],
        ),
      ),
    );
  }
}