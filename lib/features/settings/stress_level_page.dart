import 'package:flutter/material.dart';
import 'package:mentally/theme/app_colors.dart';

class StressLevelPage extends StatefulWidget {
  const StressLevelPage({super.key});

  @override
  State<StressLevelPage> createState() => _StressLevelPageState();
}

class _StressLevelPageState extends State<StressLevelPage> {
  double stress = 5;

  String getStressLabel(double value) {
    if (value < 3) return "Très faible";
    if (value < 6) return "Modéré";
    if (value < 8) return "Élevé";
    return "Très élevé";
  }

  Color getStressColor(BuildContext context, double value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (value < 3) return isDark ? Colors.greenAccent : Colors.green;
    if (value < 6) return isDark ? Colors.blueAccent : Colors.blue;
    if (value < 8) return isDark ? Colors.orangeAccent : Colors.orange;
    return isDark ? Colors.redAccent : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text("Niveau de stress")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Comment évalues‑tu ton niveau de stress aujourd’hui ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              getStressLabel(stress),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: getStressColor(context, stress),
              ),
            ),

            const SizedBox(height: 20),

            // SLIDER
            Slider(
              value: stress,
              min: 0,
              max: 10,
              divisions: 10,
              activeColor: getStressColor(context, stress),
              label: stress.toStringAsFixed(0),
              onChanged: (value) {
                setState(() => stress = value);
              },
            ),

            const SizedBox(height: 40),

            // BOUTON ENREGISTRER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, stress);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Enregistrer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
