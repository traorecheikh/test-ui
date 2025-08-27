import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text('Reçu de Paiement', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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
        ],
      ),
      body: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Paiement Réussi',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      AppSpacing.mediumHeightSpacerWidget,
                      Text(
                        '${amount.toStringAsFixed(0)} FCFA',
                        style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                      AppSpacing.largeHeightSpacerWidget,
                      QrImageView(
                        data: transactionId,
                        version: QrVersions.auto,
                        size: 160.0,
                      ),
                      AppSpacing.largeHeightSpacerWidget,
                      _buildReceiptDetailRow(theme, 'ID de Transaction', transactionId),
                      const Divider(height: 24),
                      _buildReceiptDetailRow(theme, 'Date', date),
                      const Divider(height: 24),
                      _buildReceiptDetailRow(theme, 'Méthode de Paiement', paymentMethod),
                      const Divider(height: 24),
                      _buildReceiptDetailRow(theme, 'Destinataire', recipient),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.largeHeightSpacerWidget,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Text(
                  'Terminé',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            AppSpacing.mediumHeightSpacerWidget,
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildReceiptDetailRow(ThemeData theme, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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