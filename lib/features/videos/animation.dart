import 'package:flutter/material.dart';

class BreathingAnimation extends StatefulWidget {
  final int inhale;
  final int exhale;

  const BreathingAnimation({
    super.key,
    required this.inhale,
    required this.exhale,
  });

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.inhale + widget.exhale),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          final t = controller.value;
          final isInhale = t < widget.inhale / (widget.inhale + widget.exhale);
          final progress = isInhale
              ? t * (widget.inhale + widget.exhale) / widget.inhale
              : (1 - t) * (widget.inhale + widget.exhale) / widget.exhale;

          return Column(
            children: [
              Text(
                isInhale ? "Inspire…" : "Expire…",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Container(
                width: 150 + 50 * progress,
                height: 150 + 50 * progress,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
