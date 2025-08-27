import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:snt_ui_test/app/theme.dart';

enum PaymentStatus { successful, pending, failed }

class PaymentStatusScreen extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusScreen({super.key, required this.status});

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
          height: 200,
        );
        title = 'Paiement Réussi !';
        message = 'Votre paiement a été traité avec succès.';
        statusColor = Colors.green;
        break;
      case PaymentStatus.pending:
        statusWidget = Lottie.asset('assets/lotties/pending.json', height: 200);
        title = 'Paiement en Attente';
        message = 'Votre paiement est en cours de traitement.';
        statusColor = Colors.orange;
        break;
      case PaymentStatus.failed:
        statusWidget = Lottie.asset(
          'assets/lotties/failed.json',
          repeat: false,
          height: 200,
        );
        title = 'Paiement Échoué';
        message = 'Malheureusement, votre paiement n\'a pas pu être traité.';
        statusColor = Colors.red;
        break;
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status animation with soft shadow
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: statusWidget
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),
                Text(
                  title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                AppSpacing.mediumHeightSpacerWidget,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    message,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                ),
                AppSpacing.largeHeightSpacerWidget,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
