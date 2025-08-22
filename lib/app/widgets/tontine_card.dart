import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/tontine.dart';
import '../services/storage_service.dart';
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
    final currentUser = StorageService.getCurrentUser();
    final isOrganizer = currentUser?.id == tontine.organizerId;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: isOrganizer 
                  ? Border.all(
                      color: theme.colorScheme.primary.withOpacity(
                        theme.brightness == Brightness.dark ? 0.4 : 0.3
                      ),
                      width: 1.5,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: (theme.brightness == Brightness.dark 
                      ? Colors.black.withOpacity(0.3) 
                      : Colors.black.withOpacity(0.08)
                    ),
                  blurRadius: isOrganizer ? 16 : 12,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, theme, isOrganizer),
                const SizedBox(height: 12),
                Text(
                  tontine.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(
                      theme.brightness == Brightness.dark ? 0.7 : 0.6
                    ),
                    height: 1.4,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(theme),
                const SizedBox(height: 14),
                _buildProgressBar(theme),
                if (_shouldShowActionBar()) ...[
                  const SizedBox(height: 14),
                  _buildActionBar(theme, isOrganizer),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isOrganizer) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getHeaderIcon(),
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            if (isOrganizer)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    CupertinoIcons.star_fill,
                    color: theme.colorScheme.onPrimary,
                    size: 9,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tontine.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isOrganizer)
                Text(
                  'Organisateur',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_shouldShowUrgentIndicator()) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getUrgentColor(theme).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.clock_fill,
                        color: _getUrgentColor(theme),
                        size: 10,
                      ),
                      const SizedBox(width: 1),
                      /*
                      * Text(
                        'Urgent',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getUrgentColor(theme),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      *
                      * */
                    ],
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tontine.status.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(theme),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildInfoItem(
            theme,
            CupertinoIcons.money_dollar_circle_fill,
            'Montant',
            Formatters.formatCurrency(tontine.contributionAmount),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: _buildInfoItem(
            theme,
            CupertinoIcons.person_2_fill,
            'Membres',
            '${tontine.participantIds.length}/${tontine.maxParticipants}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: _buildInfoItem(
            theme,
            CupertinoIcons.calendar,
            'Prochain',
            tontine.nextContributionDate != null
                ? Formatters.formatDate(tontine.nextContributionDate!)
                : 'N/A',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
      ThemeData theme, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              icon, 
              color: theme.colorScheme.primary, 
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(
                    theme.brightness == Brightness.dark ? 0.7 : 0.6
                  ),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    final progress = tontine.totalRounds > 0 
        ? (tontine.currentRound / tontine.totalRounds).clamp(0.0, 1.0)
        : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Progression',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${tontine.currentRound}/${tontine.totalRounds}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(
                  theme.brightness == Brightness.dark ? 0.7 : 0.6
                ),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.primary.withOpacity(
              theme.brightness == Brightness.dark ? 0.2 : 0.1
            ),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (tontine.status) {
      case TontineStatus.active:
        return theme.brightness == Brightness.dark ? Colors.green.shade400 : Colors.green.shade600;
      case TontineStatus.pending:
        return theme.brightness == Brightness.dark ? Colors.orange.shade400 : Colors.orange.shade600;
      case TontineStatus.completed:
        return theme.colorScheme.primary;
      case TontineStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  Color _getUrgentColor(ThemeData theme) {
    return theme.brightness == Brightness.dark ? Colors.red.shade400 : Colors.red.shade600;
  }

  IconData _getHeaderIcon() {
    switch (tontine.frequency) {
      case TontineFrequency.daily:
        return CupertinoIcons.clock_fill;
      case TontineFrequency.weekly:
        return CupertinoIcons.calendar;
      case TontineFrequency.biweekly:
        return CupertinoIcons.calendar_badge_plus;
      case TontineFrequency.monthly:
        return CupertinoIcons.calendar_today;
      case TontineFrequency.quarterly:
        return CupertinoIcons.chart_pie_fill;
    }
  }

  bool _shouldShowUrgentIndicator() {
    if (tontine.status != TontineStatus.active || tontine.nextContributionDate == null) {
      return false;
    }
    
    final now = DateTime.now();
    final dueDate = tontine.nextContributionDate!;
    final difference = dueDate.difference(now).inHours;
    
    // Urgent si moins de 24h pour les quotidiennes, 2 jours pour les autres
    if (tontine.frequency == TontineFrequency.daily) {
      return difference <= 24 && difference > 0;
    } else {
      return difference <= 48 && difference > 0;
    }
  }

  bool _shouldShowActionBar() {
    final currentUser = StorageService.getCurrentUser();
    if (currentUser == null) return false;
    
    final isOrganizer = currentUser.id == tontine.organizerId;
    
    // Afficher la barre d'action si:
    // - L'utilisateur est organisateur et la tontine est en attente (peut inviter)
    // - La tontine est active et a besoin d'actions
    return (isOrganizer && tontine.status == TontineStatus.pending) ||
           (tontine.status == TontineStatus.active && _shouldShowUrgentIndicator());
  }

  Widget _buildActionBar(ThemeData theme, bool isOrganizer) {
    if (isOrganizer && tontine.status == TontineStatus.pending) {
      return _buildPendingOrganizerActions(theme);
    } else if (tontine.status == TontineStatus.active && _shouldShowUrgentIndicator()) {
      return _buildActiveActions(theme);
    }
    return const SizedBox.shrink();
  }

  Widget _buildPendingOrganizerActions(ThemeData theme) {
    final spotsLeft = tontine.maxParticipants - tontine.participantIds.length;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(
          theme.brightness == Brightness.dark ? 0.15 : 0.05
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(
            theme.brightness == Brightness.dark ? 0.3 : 0.1
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.person_add_solid,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'En attente de $spotsLeft participant${spotsLeft > 1 ? 's' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implémenter partage du code d'invitation
                  },
                  icon: Icon(CupertinoIcons.share, size: 12),
                  label: Text(
                    'Inviter',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(0, 28),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: tontine.participantIds.length >= 2 ? () {
                    // TODO: Implémenter démarrage de tontine
                  } : null,
                  icon: Icon(CupertinoIcons.play_fill, size: 12),
                  label: Text(
                    'Démarrer',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(0, 28),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveActions(ThemeData theme) {
    final urgentColor = _getUrgentColor(theme);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: urgentColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.15 : 0.05
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgentColor.withOpacity(
            theme.brightness == Brightness.dark ? 0.3 : 0.1
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: urgentColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Contribution due bientôt',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: urgentColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Naviguer vers la page de paiement
            },
            style: TextButton.styleFrom(
              foregroundColor: urgentColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(0, 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Payer',
              style: TextStyle(
                color: urgentColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}