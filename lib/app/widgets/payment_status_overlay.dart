import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../theme.dart';

/// Premium payment status overlay for tontineflow.
/// - Rounded card with animation, bold message
/// - Fade-in/fade-out
/// - Dismiss only via button
/// - Accessibility and responsiveness
class PaymentStatusOverlay {
  static void show(BuildContext context, {required PaymentStatus status}) {
    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (context) {
        return _PaymentStatusContent(
          status: status,
          onDismiss: () {
            overlay?.remove();
          },
        );
      },
    );
    Overlay.of(context, rootOverlay: true)?.insert(overlay);
  }
}

enum PaymentStatus { successful, pending, failed }

class _PaymentStatusContent extends StatelessWidget {
  final PaymentStatus status;
  final VoidCallback onDismiss;

  const _PaymentStatusContent({required this.status, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget statusWidget;
    String title;
    String message;
    Color statusColor;

    switch (status) {
      case PaymentStatus.successful:
        statusWidget = Lottie.asset(
          'assets/lotties/payment-success.json',
          repeat: false,
          height: 120,
        );
        title = 'Paiement Réussi !';
        message = 'Votre paiement a été traité avec succès.';
        statusColor = Colors.green;
        break;
      case PaymentStatus.pending:
        statusWidget = Lottie.asset('assets/lotties/pending.json', height: 120);
        title = 'Paiement en Attente';
        message = 'Votre paiement est en cours de traitement.';
        statusColor = Colors.orange;
        break;
      case PaymentStatus.failed:
        statusWidget = Lottie.asset(
          'assets/lotties/failed.json',
          repeat: false,
          height: 120,
        );
        title = 'Paiement Échoué';
        message = 'Malheureusement, votre paiement n\'a pas pu être traité.';
        statusColor = Colors.red;
        break;
    }

    return Material(
      color: Colors.black.withOpacity(0.35),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              statusWidget
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 12),
              Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    backgroundColor: statusColor,
                    elevation: 8,
                    shadowColor: statusColor.withOpacity(0.25),
                  ),
                  child: Text(
                    'Retour à l\'accueil',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
