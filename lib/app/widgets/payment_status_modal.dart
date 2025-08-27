import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:snt_ui_test/app/routes/app_pages.dart';

import '../theme.dart';

/// Modal for payment status, matching Coming Soon Teaser style.
class PaymentStatusModal extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusModal({super.key, required this.status});

  static void show(BuildContext context, {required PaymentStatus status}) {
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return PaymentStatusModal(status: status);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.18),
    );
  }

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

    return Center(
      child: Material(
        color: Colors.transparent,
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
              statusWidget,
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.home),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PaymentStatus { successful, pending, failed }
