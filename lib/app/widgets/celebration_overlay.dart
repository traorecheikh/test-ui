import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CelebrationOverlay {
  static void show(BuildContext context, {String? message}) {
    final overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/lottie/confetti.json',
                      width: 220,
                      height: 220,
                      repeat: false,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 18),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context, rootOverlay: true)?.insert(overlay);
    Future.delayed(const Duration(seconds: 2), () => overlay.remove());
  }
}
