import 'package:supabase_flutter/supabase_flutter.dart';

class MoodService {
  final supabase = Supabase.instance.client;

  Future<void> saveMood({
    required int moodIndex,
    required String note,
    required List<String> photos,
  }) async {
    await supabase.from('moods').insert({
      'date': DateTime.now().toLocal().toIso8601String(),
      'mood': moodIndex,
      'note': note,
      'photos': photos,
    });
  }
}
