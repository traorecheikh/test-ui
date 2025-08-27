import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final String paymentMethod;
  final String paymentMethodImage;
  final double amount;

  const PaymentConfirmationScreen({
    super.key,
    required this.paymentMethod,
    required this.paymentMethodImage,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmer le Paiement', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Text(
              'Vous êtes sur le point de payer',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
            AppSpacing.mediumHeightSpacer,
            Text(
              '${amount.toStringAsFixed(0)} FCFA',
              style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
            AppSpacing.extraLargeHeightSpacerWidget,
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                 boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    paymentMethodImage,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                  ),
                  AppSpacing.mediumWidthSpacer,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avec',
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        paymentMethod,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideX(begin: -0.2, end: 0),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Proceed with payment
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Text(
                  'Confirmer et Payer',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            AppSpacing.smallHeightSpacer,
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Annuler',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ),
            AppSpacing.mediumHeightSpacer,
          ].animate(interval: 100.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
        ),
      ),
    );
  }
}