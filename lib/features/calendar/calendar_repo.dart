import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarRepository {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMoodsForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final response = await supabase
        .from('moods')
        .select()
        .gte('date', start.toIso8601String())
        .lt('date', end.toIso8601String())
        .order('date', ascending: false);

    // Convertir toutes les dates en local
    return response.map((row) {
      final date = DateTime.parse(row['date']).toLocal();
      return {...row, 'date': date};
    }).toList();
  }

  Future<Map<String, dynamic>?> getMoodForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final response = await supabase
        .from('moods')
        .select()
        .gte('date', start.toIso8601String())
        .lt('date', end.toIso8601String())
        .order('date', ascending: false);

    if (response.isEmpty) return null;

    // Convertir la date en local
    final row = response.first;
    final date = DateTime.parse(row['date']).toLocal();

    return {...row, 'date': date};
  }
}
