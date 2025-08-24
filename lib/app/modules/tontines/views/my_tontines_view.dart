import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/tontine.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';
import '../../home/controllers/home_controller.dart';

class MyTontinesView extends GetView<HomeController> {
  const MyTontinesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        title: Text(
          'Vos Tontines',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.add_circled,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            onPressed: () => Get.toNamed(Routes.create),
            tooltip: 'Créer une tontine',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState(theme);
        }
        if (controller.userTontines.isEmpty) {
          return _buildEmptyState(theme, context);
        }
        return _buildTontineList(theme);
      }),
    );
  }

  Widget _buildTontineList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: controller.userTontines.length,
      itemBuilder: (context, i) {
        final tontine = controller.userTontines[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _ModernTontineCard(
            tontine: tontine,
            onTap: () => Get.toNamed(Routes.detail, arguments: tontine.id),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: theme.colorScheme.surface.withOpacity(0.5),
          highlightColor: theme.colorScheme.surface,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            height: 220,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.collections,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Commencez votre aventure d\'épargne',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Créez une nouvelle tontine ou rejoignez un groupe existant pour commencer.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.create),
              icon: const Icon(CupertinoIcons.add, size: 20),
              label: const Text('Créer une Tontine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement Join Tontine functionality
              },
              icon: const Icon(CupertinoIcons.person_add, size: 20),
              label: const Text('Rejoindre une Tontine'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernTontineCard extends StatelessWidget {
  final Tontine tontine;
  final VoidCallback? onTap;

  const _ModernTontineCard({required this.tontine, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOrganizer =
        StorageService.getCurrentUser()?.id == tontine.organizerId;
    final bool needsAction = _shouldShowUrgentIndicator();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: needsAction
              ? Border.all(color: Colors.orangeAccent, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isOrganizer),
            SizedBox(height: 16.h),
            _buildParticipantInfo(theme),
            SizedBox(height: 12.h),
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
            color: _getStatusColor(theme).withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            _getHeaderIcon(),
            color: _getStatusColor(theme),
            size: 32,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tontine.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tontine.status.label.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(theme),
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
              color: Colors.amber.withOpacity(0.1),
            ),
            child: const Icon(
              CupertinoIcons.star_fill,
              color: Colors.amber,
              size: 18,
            ),
          ),
      ],
    );
  }

  Widget _buildParticipantInfo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.group_solid,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: 20,
        ),
        SizedBox(width: 8.w),
        Text(
          '${tontine.participantIds.length} / ${tontine.maxParticipants} Membres',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
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
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(theme)),
          ),
        ),
      ],
    );
  }

  // Helper methods for styling
  Color _getStatusColor(ThemeData theme) {
    switch (tontine.status) {
      case TontineStatus.active:
        return Colors.green.shade600;
      case TontineStatus.pending:
        return Colors.blue.shade600;
      case TontineStatus.completed:
        return theme.colorScheme.primary;
      case TontineStatus.cancelled:
        return theme.colorScheme.error;
    }
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
    if (tontine.status != TontineStatus.active ||
        tontine.nextContributionDate == null) {
      return false;
    }
    final difference = tontine.nextContributionDate!
        .difference(DateTime.now())
        .inHours;
    return difference <= 48 && difference > 0;
  }
}
