import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class ModernPotVisualWidget extends StatelessWidget {
  final double currentAmount;
  final double targetAmount;
  final int paidParticipants;
  final int totalParticipants;
  final VoidCallback? onTap;

  const ModernPotVisualWidget({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    required this.paidParticipants,
    required this.totalParticipants,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (targetAmount > 0)
        ? (currentAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularProgress(theme, percentage),
            const SizedBox(height: 24),
            _buildAmountText(theme),
            const SizedBox(height: 8),
            _buildParticipantText(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(ThemeData theme, double percentage) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 8,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(percentage),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getPotIcon(percentage),
                color: _getStatusColor(percentage),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                '${(percentage * 100).toInt()}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountText(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Cagnotte Actuelle',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(currentAmount),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantText(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.group,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '$paidParticipants / $totalParticipants Participants',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 1.0) return Colors.green.shade600;
    if (percentage >= 0.75) return Colors.blue.shade600;
    if (percentage >= 0.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  IconData _getPotIcon(double percentage) {
    if (percentage >= 1.0) return Icons.celebration;
    if (percentage >= 0.5) return Icons.savings;
    return Icons.hourglass_empty;
  }
}
