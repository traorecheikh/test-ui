import 'package:flutter/material.dart';

import '../data/models/tontine.dart';
import '../utils/formatters.dart';

class TontineCard extends StatelessWidget {
  final Tontine tontine;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? trailing;

  const TontineCard({
    super.key,
    required this.tontine,
    this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 8 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              _buildContent(theme),
              const SizedBox(height: 12),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: tontine.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(tontine.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: tontine.imageUrl == null
                ? theme.colorScheme.primaryContainer
                : null,
          ),
          child: tontine.imageUrl == null
              ? Icon(
                  Icons.groups,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tontine.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                tontine.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(theme),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tontine.status.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            theme,
            'Contribution',
            Formatters.formatCurrency(tontine.contributionAmount),
            Icons.account_balance_wallet,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            theme,
            'Participants',
            '${tontine.participantIds.length}/${tontine.maxParticipants}',
            Icons.group,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            theme,
            'Fréquence',
            tontine.frequency.label,
            Icons.schedule,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              tontine.status == TontineStatus.active &&
                      tontine.nextContributionDate != null
                  ? 'Prochain: ${Formatters.formatDate(tontine.nextContributionDate!)}'
                  : 'Créée: ${Formatters.formatDate(tontine.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        if (tontine.status == TontineStatus.active)
          Row(
            children: [
              Text(
                'Tour ${tontine.currentRound}/${tontine.totalRounds}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.trending_up,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
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
        return Colors.blue;
      case TontineStatus.cancelled:
        return Colors.red;
    }
  }
}
