import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/tontine.dart';
import '../utils/formatters.dart';

class TontineCard extends StatelessWidget {
  final Tontine tontine;
  final VoidCallback? onTap;
  final Widget? trailing;

  const TontineCard(
      {super.key, required this.tontine, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 16),
            Text(
              tontine.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            _buildInfoRow(theme),
            const SizedBox(height: 16),
            _buildProgressBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            CupertinoIcons.group_solid,
            color: theme.colorScheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            tontine.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(theme).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tontine.status.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _getStatusColor(theme),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(
          theme,
          CupertinoIcons.money_dollar_circle_fill,
          'Contribution',
          Formatters.formatCurrency(tontine.contributionAmount),
        ),
        _buildInfoItem(
          theme,
          CupertinoIcons.person_2_fill,
          'Membres',
          '${tontine.participantIds.length}/${tontine.maxParticipants}',
        ),
        _buildInfoItem(
          theme,
          CupertinoIcons.calendar,
          'Prochain tour',
          tontine.nextContributionDate != null
              ? Formatters.formatDate(tontine.nextContributionDate!)
              : 'N/A',
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      ThemeData theme, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    final progress = tontine.currentRound / tontine.totalRounds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${tontine.currentRound} / ${tontine.totalRounds} tours',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (tontine.status) {
      case TontineStatus.active:
        return Colors.green;
      case TontineStatus.pending:
        return Colors.orange;
      case TontineStatus.completed:
        return theme.colorScheme.primary;
      case TontineStatus.cancelled:
        return theme.colorScheme.error;
    }
  }
}