import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/payment/payment_method_screen.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../../../data/models/tontine.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/modern_pot_visual.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  const TontineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState(theme);
          }
          final tontine = controller.tontine.value;
          if (tontine == null) {
            return _buildErrorState(theme);
          }
          return _AnimatedDetailView(
            child: ListView(
              padding: AppPaddings.pageHome,
              children: [
                _buildTontineHeader(theme, tontine),
                AppSpacing.extraLargeHeightSpacerWidget,
                _buildPotVisualSection(theme, tontine),
                AppSpacing.extraLargeHeightSpacerWidget,
                _buildStatsCards(theme, tontine),
                AppSpacing.extraLargeHeightSpacerWidget,
                _buildQuickActionsSection(theme),
                AppSpacing.extraLargeHeightSpacerWidget,
                _buildParticipantsSection(theme, tontine),
                AppSpacing.extraLargeHeightSpacerWidget,
              ],
            ),
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          CupertinoIcons.xmark,
          color: theme.colorScheme.primary,
          size: 28,
        ),
        onPressed: () => Get.back(),
        tooltip: 'Retour',
      ),
      title: Obx(() {
        final tontine = controller.tontine.value;
        return Text(
          tontine?.name ?? 'Détails Tontine',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        );
      }),
      actions: [
        IconButton(
          icon: Icon(
            CupertinoIcons.ellipsis_circle,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          onPressed: controller.showOptionsMenu,
          tooltip: 'Options',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          AppSpacing.largeHeightSpacerWidget,
          Text(
            'Chargement...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 80,
              color: theme.colorScheme.error.withOpacity(0.3),
            ),
            AppSpacing.largeHeightSpacerWidget,
            Text(
              'Tontine introuvable',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            AppSpacing.mediumHeightSpacerWidget,
            Text(
              'Cette tontine n\'existe plus ou a été supprimée.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.extraLargeHeightSpacerWidget,
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTontineHeader(ThemeData theme, Tontine tontine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(theme, tontine.status).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTontineIcon(tontine.frequency),
                color: _getStatusColor(theme, tontine.status),
                size: AppIconSizes.extraLarge,
              ),
            ),
            AppSpacing.mediumWidthSpacer,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tontine.description,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.smallHeightSpacer,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        theme,
                        tontine.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${tontine.status.label} • ${tontine.frequency.label}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getStatusColor(theme, tontine.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPotVisualSection(ThemeData theme, Tontine tontine) {
    final currentAmount = tontine.currentRound * tontine.contributionAmount;
    final targetAmount = tontine.totalPot;
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;

    return ModernPotVisualWidget(
      currentAmount: currentAmount.toDouble(),
      targetAmount: targetAmount,
      paidParticipants: paidCount,
      totalParticipants: tontine.participantIds.length,
      onTap: controller.showPotDetails,
    );
  }

  Widget _buildStatsCards(ThemeData theme, Tontine tontine) {
    final myContribution = controller.myContribution;
    final isPaid = myContribution?.isPaid ?? false;
    // Progress calculation - could be used for future enhancements

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            'Ma Contribution',
            Formatters.formatCurrency(tontine.contributionAmount),
            CupertinoIcons.money_dollar,
            theme.colorScheme.primary,
          ),
        ),
        AppSpacing.mediumWidthSpacer,
        Expanded(
          child: _buildStatCard(
            theme,
            'Mon Statut',
            isPaid ? 'Payé' : 'En attente',
            isPaid
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.clock_fill,
            isPaid ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppShadows.small],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
            ],
          ),
          AppSpacing.mediumHeightSpacer,
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.smallHeightSpacer,
          AutoSizeText(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    final actions = [
      {
        'icon': CupertinoIcons.creditcard,
        'title': 'Payer',
        'subtitle': 'Effectuer un paiement',
        'onTap': () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showPaymentSheet(Get.context!);
          });
        },
        'color': AppActionColors.create,
      },
      {
        'icon': CupertinoIcons.person_add,
        'title': 'Inviter',
        'subtitle': 'Partager le code',
        'onTap': controller.showInviteDialog,
        'color': AppActionColors.join,
      },
      {
        'icon': CupertinoIcons.time,
        'title': 'Historique',
        'subtitle': 'Voir les transactions',
        'onTap': controller.showTransactionHistory,
        'color': AppActionColors.history,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.bolt,
              color: theme.colorScheme.primary.withOpacity(0.8),
              size: AppIconSizes.medium,
            ),
            AppSpacing.smallWidthSpacer,
            Text(
              'Actions Rapides',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        AppSpacing.largeHeightSpacer,
        ...actions.map(
          (action) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: action['onTap'] as VoidCallback?,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppShadows.small],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 28,
                      ),
                    ),
                    AppSpacing.mediumWidthSpacer,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action['title'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.smallHeightSpacer,
                          Text(
                            action['subtitle'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(ThemeData theme, Tontine tontine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.group,
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
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${tontine.participantIds.length}/${tontine.maxParticipants}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
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
    final initials = name.split(' ').map((n) => n[0]).take(2).join();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [AppShadows.small],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPaid
                  ? Colors.green.withOpacity(0.1)
                  : theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPaid
                        ? Colors.green.shade600
                        : theme.colorScheme.primary,
                  ),
                ),
                if (isPaid)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.checkmark,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.mediumWidthSpacer,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isOrganizer)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.star_fill,
                              color: Colors.amber.shade600,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Organisateur',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.amber.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                AppSpacing.smallHeightSpacer,
                Text(
                  isPaid ? 'Contribution payée' : 'En attente de paiement',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isPaid
                        ? Colors.green.shade600
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(ThemeData theme, TontineStatus status) {
    switch (status) {
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

  IconData _getTontineIcon(TontineFrequency frequency) {
    switch (frequency) {
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
}

// Animation Widget for smooth entrance
class _AnimatedDetailView extends StatefulWidget {
  final Widget child;

  const _AnimatedDetailView({required this.child});

  @override
  State<_AnimatedDetailView> createState() => _AnimatedDetailViewState();
}

class _AnimatedDetailViewState extends State<_AnimatedDetailView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
