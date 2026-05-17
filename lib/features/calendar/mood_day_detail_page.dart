import 'package:flutter/material.dart';
import 'package:mentally/theme/app_mood_emojis.dart';
import 'package:mentally/theme/app_colors.dart';

class MoodDayDetailPage extends StatelessWidget {
  final Map<String, dynamic> mood;

  const MoodDayDetailPage({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Text(
                "Humeur : ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueDeep,
                ),
              ),
              if (moodEmojis[mood['mood']] != null)
                Image.asset(
                  'assets/emojis/${moodEmojis[mood['mood']]}',
                  width: 84,
                  height: 84,
                )
              else
                const Text("❓", style: TextStyle(fontSize: 40)),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "Notes :",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.blueDeep,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              mood['note'] ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.blueNight,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (mood['activities'] != null &&
              (mood['activities'] as List).isNotEmpty) ...[
            const Text(
              "Activités :",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blueDeep,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                (mood['activities'] as List).length,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueDeep.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.blueDeep.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    mood['activities'][index],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueDeep,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (mood['photos'] != null) ...[
            const Text(
              "Photos :",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blueDeep,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var p in mood['photos'])
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      p,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ],

        ],
      ),
    );
  }
}