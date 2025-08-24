import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Premium celebration overlay for tontineflow.
/// - Confetti animation
/// - Rounded card with emoji, bold message
/// - Fade-in/fade-out
/// - Tap outside to dismiss
/// - Accessibility and responsiveness
class CelebrationOverlay {
  /// Shows a premium confetti celebration overlay with message, emoji, and a 'Merci' button.
  /// Dismisses only when the user taps 'Merci'.
  static void show(BuildContext context, {String? message}) {
    final controller = ConfettiController(duration: const Duration(seconds: 2));
    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (context) {
        return _CelebrationContent(
          controller: controller,
          message: message ?? 'Bravo ! Première tontine créée 🎉',
          onDismiss: () {
            controller.stop();
            controller.dispose();
            overlay?.remove();
          },
        );
      },
    );
    Overlay.of(context, rootOverlay: true)?.insert(overlay);
    controller.play();
  }
}

class _CelebrationContent extends StatefulWidget {
  final ConfettiController controller;
  final String message;
  final VoidCallback onDismiss;

  const _CelebrationContent({
    required this.controller,
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_CelebrationContent> createState() => _CelebrationContentState();
}

class _CelebrationContentState extends State<_CelebrationContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.black.withOpacity(0.12),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth < 400.w
              ? constraints.maxWidth * 0.9
              : 360.w;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConfettiWidget(
                confettiController: widget.controller,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.08,
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 8,
                gravity: 0.3,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.yellow,
                ],
                shouldLoop: false,
              ),
              SizedBox(height: 24.h),
              Center(
                child: Container(
                  width: cardWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 28.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 24.sp,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🎉',
                        style: TextStyle(fontSize: 56.sp, height: 1),
                        semanticsLabel: 'Célébration',
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        widget.message,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 22.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 28.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                          onPressed: widget.onDismiss,
                          child: Text(
                            'Merci',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
