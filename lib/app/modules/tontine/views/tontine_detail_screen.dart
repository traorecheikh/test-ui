import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../../../data/models/tontine.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  const TontineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final tontine = controller.tontine.value;
          if (tontine == null) {
            return const Center(child: Text('Tontine non trouvée'));
          }
          return ListView(
            padding: AppPaddings.pageHome,
            children: [
              _buildHeader(theme, tontine),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildTontineSummaryCard(theme, tontine),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildQuickActionsSection(theme),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildParticipantsSection(theme, tontine),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Tontine tontine) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Get.back(),
        ),
        AppSpacing.mediumWidthSpacer,
        Expanded(
          child: Text(
            tontine.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSpacing.mediumWidthSpacer,
        IconButton(
          icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
          onPressed: controller.showOptionsMenu,
          tooltip: 'Options',
        ),
      ],
    );
  }

  Widget _buildTontineSummaryCard(ThemeData theme, Tontine tontine) {
    final myContribution = controller.myContribution;
    final isPaid = myContribution?.isPaid ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [AppShadows.large],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Pot Actuel',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          AppSpacing.smallHeightSpacer,
          Text(
            Formatters.formatCurrency(tontine.totalPot),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.largeHeightSpacer,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: AppPaddings.cardContent,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ma Part',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.smallHeightSpacer,
                      Text(
                        Formatters.formatCurrency(tontine.contributionAmount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacings.cardGap,
              Expanded(
                child: Container(
                  padding: AppPaddings.cardContent,
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Mon Statut',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.smallHeightSpacer,
                      Text(
                        isPaid ? 'Payé' : 'En attente',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    final actions = [
      {
        'icon': Icons.payment_outlined,
        'title': 'Payer',
        'onTap': controller.showPaymentDialog,
        'color': AppActionColors.create,
      },
      {
        'icon': Icons.person_add_alt_1_outlined,
        'title': 'Inviter',
        'onTap': controller.showInviteDialog,
        'color': AppActionColors.join,
      },
      {
        'icon': Icons.history_outlined,
        'title': 'Historique',
        'onTap': controller.showTransactionHistory,
        'color': AppActionColors.history,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 32.sp) / 3;
        return Wrap(
          spacing: 16.sp,
          runSpacing: 16.sp,
          alignment: WrapAlignment.center,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: action['onTap'] as VoidCallback?,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.superExtraLarge,
                      height: AppSpacing.superExtraLargeH,
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData?,
                        color: action['color'] as Color?,
                        size: AppIconSizes.large,
                      ),
                    ),
                    AppSpacing.mediumHeightSpacer,
                    Text(
                      action['title'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildParticipantsSection(ThemeData theme, Tontine tontine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.group_outlined,
              color: theme.colorScheme.primary.withOpacity(0.8),
              size: AppIconSizes.medium,
            ),
            AppSpacing.smallWidthSpacer,
            Text(
              'Participants',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        AppSpacing.largeHeightSpacer,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tontine.participantIds.length,
          itemBuilder: (context, index) {
            final participantId = tontine.participantIds[index];
            final contribution = controller.currentRoundContributions
                .firstWhereOrNull((c) => c.participantId == participantId);
            return _buildParticipantListItem(
              theme,
              participantId,
              participantId == tontine.organizerId,
              contribution,
              index,
            );
          },
          separatorBuilder: (context, index) => AppSpacing.mediumHeightSpacer,
        ),
      ],
    );
  }

  Widget _buildParticipantListItem(
    ThemeData theme,
    int participantId,
    bool isOrganizer,
    dynamic contribution,
    int index,
  ) {
    final name =
        AppConstants.sampleParticipantNames[index %
            AppConstants.sampleParticipantNames.length];
    final isPaid = contribution?.isPaid ?? false;

    return Container(
      padding: EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [AppShadows.small],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Text(
              name.split(' ').map((n) => n[0]).take(2).join(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          AppSpacing.mediumWidthSpacer,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isOrganizer)
                  Text(
                    'Organisateur',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.mediumWidthSpacer,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Text(
              isPaid ? 'Payé' : 'En attente',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isPaid ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
