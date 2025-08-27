import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String? errorMessage;

  const PaymentFailedScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset(
              'assets/lotties/failed.json',
              repeat: false,
              height: 200,
            ),
            AppSpacing.largeHeightSpacerWidget,
            Text(
                  'Paiement Échoué',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
                        errorMessage ??
                            'Nous n avons pas pu traiter votre paiement. Veuillez vérifier vos informations et réessayer.',
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
                      // Logic to retry payment
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      'Réessayer le paiement',
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
            AppSpacing.smallHeightSpacerWidget,
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // Logic to contact support
                },
                child: Text(
                  'Contacter le support',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            AppSpacing.mediumHeightSpacerWidget,
          ],
        ),
      ),
    );
  }
}
