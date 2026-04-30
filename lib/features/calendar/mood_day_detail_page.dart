import 'package:flutter/material.dart';
import 'package:mentally/theme/app_mood_emojis.dart';

class MoodDayDetailPage extends StatelessWidget {
  final Map<String, dynamic> mood;

  const MoodDayDetailPage({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Humeur du jour")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Humeur : ${moodEmojis[mood['mood']] ?? '❓'}",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 10),
            Text("Note : ${mood['note'] ?? ''}"),
            const SizedBox(height: 20),
            const Text("Photos :"),
            const SizedBox(height: 10),
            if (mood['photos'] != null)
              Wrap(
                spacing: 10,
                children: [
                  for (var p in mood['photos'])
                    Image.network(p, width: 80, height: 80, fit: BoxFit.cover),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
