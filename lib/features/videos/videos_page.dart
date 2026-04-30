import 'package:flutter/material.dart';
import '../../../../widgets/app_scaffold.dart';
import 'exercise_detail_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {
        'title': 'Respiration 4-4',
        'description':
            'Inspire 4s et expire 4s pour calmer le système nerveux.',
        'type': 'breathing_44',
      },

      {
        'title': 'Relaxation',
        'description': 'Une courte séance audio pour relâcher les tensions.',
        'type': 'audio',
      },
    ];

    return AppScaffold(
      title: "Exercices",
      currentIndex: 3,
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/progress');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/calendar');
            break;
          case 3:
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Card(
            child: ListTile(
              title: Text(ex['title']!),
              subtitle: Text(ex['description']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseDetailPage(exercise: ex),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
