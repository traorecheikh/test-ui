import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Stack(
            children: [
              // Animated gradient background
              Positioned.fill(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1600),
                  builder: (context, value, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withOpacity(
                              0.15 + 0.25 * value,
                            ),
                            theme.colorScheme.secondary.withOpacity(
                              0.10 + 0.20 * value,
                            ),
                            theme.colorScheme.background,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Centered splash content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Lottie with fade/scale
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.7, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: Lottie.asset(
                              'assets/lottie/splash.json',
                              width: 180,
                              height: 180,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Typewriter effect for app name
                    _TypewriterText(
                      text: 'TontineFlow',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                      duration: const Duration(milliseconds: 900),
                    ),
                    const SizedBox(height: 12),
                    // Tagline slide-in
                    TweenAnimationBuilder<Offset>(
                      tween: Tween(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, value.dy * 30),
                          child: Opacity(
                            opacity: 1 - value.dy,
                            child: Text(
                              'L’avenir de la tontine, aujourd’hui',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Typewriter text widget for app name
class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  const _TypewriterText({
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _charCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _charCount.value),
          style: widget.style,
        );
      },
    );
  }
}
