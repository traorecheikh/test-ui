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
      body: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            statusWidget
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.5, 0.5)),
            AppSpacing.largeHeightSpacerWidget,
            Text(
                  title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0),
            AppSpacing.mediumHeightSpacerWidget,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  Text(
                        message,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms)
                      .slideY(begin: 0.2, end: 0),
            ),
            const Spacer(flex: 2),
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to home
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      backgroundColor: statusColor,
                    ),
                    child: Text(
                      'Retour à l\'accueil',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 600.ms)
                .slideY(begin: 0.5, end: 0),
            AppSpacing.mediumHeightSpacerWidget,
          ],
        ),
      ),
    );
  }
}
