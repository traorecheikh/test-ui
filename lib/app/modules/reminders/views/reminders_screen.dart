import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../theme.dart';
import '../../../utils/formatters.dart';
import '../controllers/reminders_controller.dart';

class RemindersScreen extends GetView<RemindersController> {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: _buildBody(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.colorScheme.primary,
          size: AppIconSizes.medium,
        ),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rappels de paiement',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => Text(
            '${controller.totalReminders.value} paiement${controller.totalReminders.value > 1 ? 's' : ''} en attente',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          )),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: theme.colorScheme.primary,
            size: AppIconSizes.medium,
          ),
          onPressed: controller.refresh,
        ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoading(theme);
      }

      if (controller.hasError.value) {
        return _buildError(theme);
      }

      if (controller.reminders.isEmpty) {
        return _buildEmptyState(theme);
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: Column(
          children: [
            _buildSummaryCards(theme),
            Expanded(
              child: _buildRemindersList(theme),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLoading(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          AppSpacing.mediumHeightSpacer,
          Text(
            'Chargement des rappels...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppIconSizes.superExtraLarge,
              color: theme.colorScheme.error,
            ),
            AppSpacing.largeHeightSpacer,
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.mediumHeightSpacer,
            Text(
              controller.errorMessage.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.largeHeightSpacer,
            ElevatedButton.icon(
              onPressed: controller.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: AppIconSizes.superExtraLarge,
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            AppSpacing.largeHeightSpacer,
            Text(
              'Aucun rappel',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.mediumHeightSpacer,
            Text(
              'Tous vos paiements sont à jour !\nBravo pour votre ponctualité.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.largeHeightSpacer,
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              theme,
              'En retard',
              controller.overdueCount.toString(),
              Icons.warning_rounded,
              theme.colorScheme.error,
            ),
          ),
          AppSpacing.smallWidthSpacer,
          Expanded(
            child: _buildSummaryCard(
              theme,
              'Aujourd\'hui',
              controller.dueTodayCount.toString(),
              Icons.today_rounded,
              AppActionColors.sunuPoints,
            ),
          ),
          AppSpacing.smallWidthSpacer,
          Expanded(
            child: _buildSummaryCard(
              theme,
              'Urgent',
              controller.urgentCount.toString(),
              Icons.priority_high_rounded,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    ThemeData theme,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [AppShadows.small],
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppIconSizes.medium,
          ),
          AppSpacing.smallHeightSpacer,
          Text(
            count,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      itemCount: controller.reminders.length,
      itemBuilder: (context, index) {
        final tontine = controller.reminders[index];
        return _buildReminderCard(tontine, theme, index);
      },
    );
  }

  Widget _buildReminderCard(Tontine tontine, ThemeData theme, int index) {
    final priority = controller.getPriority(tontine);
    final timeText = controller.getTimeRemainingText(tontine);
    final daysUntil = controller.getDaysUntilPayment(tontine);

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.medium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [AppShadows.small],
        border: Border.all(
          color: _getPriorityColor(priority, theme).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.goToTontineDetails(tontine),
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Padding(
            padding: AppPaddings.cardContent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with priority and time
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority, theme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPriorityIcon(priority),
                            size: 12.sp,
                            color: _getPriorityColor(priority, theme),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            timeText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getPriorityColor(priority, theme),
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.formatCurrency(tontine.contributionAmount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                AppSpacing.mediumHeightSpacer,
                // Tontine name and description
                Text(
                  tontine.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.smallHeightSpacer,
                Text(
                  'Round ${tontine.currentRound} • ${tontine.frequency.label}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                AppSpacing.mediumHeightSpacer,
                // Due date
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: AppIconSizes.small,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Échéance: ${tontine.formattedNextPaymentDate}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                AppSpacing.mediumHeightSpacer,
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.goToTontineDetails(tontine),
                        icon: Icon(
                          Icons.info_outline,
                          size: AppIconSizes.small,
                        ),
                        label: const Text('Détails'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                    AppSpacing.smallWidthSpacer,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => controller.markAsPaid(tontine),
                        icon: Icon(
                          Icons.payment_rounded,
                          size: AppIconSizes.small,
                        ),
                        label: const Text('Payer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getPriorityColor(priority, theme),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(ReminderPriority priority, ThemeData theme) {
    switch (priority) {
      case ReminderPriority.overdue:
        return theme.colorScheme.error;
      case ReminderPriority.dueToday:
        return AppActionColors.sunuPoints;
      case ReminderPriority.urgent:
        return Colors.orange;
      case ReminderPriority.upcoming:
        return AppActionColors.join;
      case ReminderPriority.future:
        return theme.colorScheme.primary;
    }
  }

  IconData _getPriorityIcon(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.overdue:
        return Icons.warning_rounded;
      case ReminderPriority.dueToday:
        return Icons.today_rounded;
      case ReminderPriority.urgent:
        return Icons.priority_high_rounded;
      case ReminderPriority.upcoming:
        return Icons.schedule_rounded;
      case ReminderPriority.future:
        return Icons.calendar_month_rounded;
    }
  }
}