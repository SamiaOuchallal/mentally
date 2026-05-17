import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user_services.dart';

class MoodService {
  final supabase = Supabase.instance.client;

  Future<void> saveMood({
    required int moodIndex,
    required String note,
    required List<String> photos,
    required List<String> activities,
  }) async {
    final userId = await UserService.getUserId();

    await supabase.from('moods').insert({
      'date': DateTime.now().toIso8601String(),
      'mood': moodIndex,
      'note': note,
      'photos': photos,
      'activities': activities,
      'user_id': userId,
    });
  }
}
