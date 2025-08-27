import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final String transactionId;
  final double amount;
  final String date;
  final String paymentMethod;
  final String recipient;

  const PaymentReceiptScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reçu de Paiement', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Logic to share receipt
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Logic to download receipt
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.pageHome,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              child: Column(
                children: [
                  QrImageView(
                    data: transactionId,
                    version: QrVersions.auto,
                    size: 150.0,
                  ).animate().fadeIn(duration: 500.ms).scale(),
                  AppSpacing.largeHeightSpacer,
                  Text(
                    'Paiement Réussi',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  AppSpacing.largeHeightSpacer,
                  _buildReceiptDetailRow(theme, 'ID de Transaction', transactionId),
                  _buildReceiptDetailRow(theme, 'Montant Payé', '${amount.toStringAsFixed(0)} FCFA'),
                  _buildReceiptDetailRow(theme, 'Date', date),
                  _buildReceiptDetailRow(theme, 'Méthode de Paiement', paymentMethod),
                  _buildReceiptDetailRow(theme, 'Destinataire', recipient),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
            AppSpacing.extraLargeHeightSpacerWidget,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Text(
                  'Terminé',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            AppSpacing.mediumHeightSpacer,
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptDetailRow(ThemeData theme, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}