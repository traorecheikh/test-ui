import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/tontine.dart';
import '../services/storage_service.dart';

class TontineCard extends StatelessWidget {
  final Tontine tontine;
  final VoidCallback? onTap;

  const TontineCard({super.key, required this.tontine, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOrganizer = StorageService.getCurrentUser()?.id == tontine.organizerId;
    final bool needsAction = _shouldShowUrgentIndicator();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getBackgroundGradient(theme),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: needsAction
              ? Border.all(color: Colors.orangeAccent, width: 2.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: _getBackgroundColor(theme).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isOrganizer),
            const Spacer(),
            _buildParticipantInfo(theme),
            const SizedBox(height: 12),
            _buildProgressBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isOrganizer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(_getHeaderIcon(), color: Colors.white, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tontine.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tontine.status.label.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isOrganizer)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
            child: Icon(
              CupertinoIcons.star_fill,
              color: _getBackgroundColor(theme),
              size: 18,
            ),
          ),
      ],
    );
  }

  Widget _buildParticipantInfo(ThemeData theme) {
    return Row(
      children: [
        const Icon(CupertinoIcons.group_solid, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          '${tontine.participantIds.length} / ${tontine.maxParticipants} Membres',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
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
      children: [
        Text(
          'Tour ${tontine.currentRound} sur ${tontine.totalRounds}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }

  // Helper methods for styling
  Color _getBackgroundColor(ThemeData theme) {
    switch (tontine.status) {
      case TontineStatus.active:
        return Colors.green.shade400;
      case TontineStatus.pending:
        return Colors.blue.shade400;
      case TontineStatus.completed:
        return theme.colorScheme.primary;
      case TontineStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  List<Color> _getBackgroundGradient(ThemeData theme) {
    final baseColor = _getBackgroundColor(theme);
    return [baseColor, baseColor.withOpacity(0.7)];
  }

  IconData _getHeaderIcon() {
    switch (tontine.frequency) {
      case TontineFrequency.daily:
        return CupertinoIcons.sun_max_fill;
      case TontineFrequency.weekly:
        return CupertinoIcons.calendar_today;
      case TontineFrequency.monthly:
        return CupertinoIcons.moon_fill;
      default:
        return CupertinoIcons.group_solid;
    }
  }

  bool _shouldShowUrgentIndicator() {
    if (tontine.status != TontineStatus.active || tontine.nextContributionDate == null) {
      return false;
    }
    final difference = tontine.nextContributionDate!.difference(DateTime.now()).inHours;
    return difference <= 48 && difference > 0;
  }
}