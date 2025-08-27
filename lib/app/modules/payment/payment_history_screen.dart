import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Dummy data for transaction history
    final List<Map<String, dynamic>> transactions = [
      {'amount': 5000, 'date': '28 Juil 2024', 'status': 'Réussi', 'method': 'Wave', 'icon': 'assets/images/payment/wave.png'},
      {'amount': 2500, 'date': '27 Juil 2024', 'status': 'Échoué', 'method': 'Orange Money', 'icon': 'assets/images/payment/orange_money.png'},
      {'amount': 10000, 'date': '26 Juil 2024', 'status': 'Réussi', 'method': 'Free Money', 'icon': 'assets/images/payment/free.png'},
      {'amount': 5000, 'date': '25 Juil 2024', 'status': 'Réussi', 'method': 'Wave', 'icon': 'assets/images/payment/wave.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Paiements', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: AppPaddings.pageHome,
        itemCount: transactions.length,
        separatorBuilder: (context, index) => AppSpacing.mediumHeightSpacerWidget,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isSuccess = transaction['status'] == 'Réussi';

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Adjusted padding for richness
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
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
                Container(
                  width: AppIconSizes.large, // Adjusted icon size for richness
                  height: AppIconSizes.large, // Adjusted icon size for richness
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(transaction['icon']),
                      fit: BoxFit.cover, // Ensure image covers the circle
                    ),
                  ),
                ),
                AppSpacing.mediumWidthSpacerWidget, // Consistent spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['method'],
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface), // Adjusted text style for richness
                      ),
                      AppSpacing.smallHeightSpacerWidget,
                      Text(
                        transaction['date'],
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                      '${transaction['amount']} FCFA',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                    ),
                    AppSpacing.smallHeightSpacerWidget,
                    Text(
                      transaction['status'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSuccess ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: (100 * index).ms).moveX(begin: -10);
        },
      ),
    );
  }
}