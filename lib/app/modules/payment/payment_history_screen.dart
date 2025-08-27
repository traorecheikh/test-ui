import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Dummy data for transaction history
    final List<Map<String, dynamic>> transactions = [
      {'amount': 5000, 'date': '28 Juil 2024', 'status': 'Réussi', 'method': 'Wave'},
      {'amount': 2500, 'date': '27 Juil 2024', 'status': 'Échoué', 'method': 'Orange Money'},
      {'amount': 10000, 'date': '26 Juil 2024', 'status': 'Réussi', 'method': 'Free Money'},
      {'amount': 5000, 'date': '25 Juil 2024', 'status': 'Réussi', 'method': 'Wave'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Paiements', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: AppPaddings.pageHome,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isSuccess = transaction['status'] == 'Réussi';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: AppSpacing.small,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle_outline : Icons.highlight_off,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 28,
                  ),
                ),
                AppSpacing.mediumWidthSpacer,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction['amount']} FCFA',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${transaction['method']} - ${transaction['date']}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ), 
                ),
                Text(
                  transaction['status'],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
        },
      ),
    );
  }
}