import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedValidationIcon extends StatelessWidget {
  final bool isValid;
  final bool isVisible;

  const AnimatedValidationIcon({
    super.key,
    required this.isValid,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        ScaleEffect(duration: 300.ms, curve: Curves.elasticOut),
      ],
      child: Icon(
        isValid ? Icons.check_circle : Icons.error,
        color: isValid ? Colors.green : Colors.red,
        size: 22,
      ),
    );
  }
}
