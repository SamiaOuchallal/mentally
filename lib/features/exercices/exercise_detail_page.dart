import 'package:flutter/material.dart';
import 'animation.dart';

class ExerciseDetailPage extends StatelessWidget {
  final Map<String, String> exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise['description']!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),

            if (exercise['type'] == 'breathing_44')
              const BreathingAnimation(inhale: 4, exhale: 4),

            if (exercise['type'] == 'audio') const Text("audio à intégrer"),
          ],
        ),
      ),
    );
  }
}
