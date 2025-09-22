import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/coming_soon_teaser.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final user = controller.currentUser.value;
      /*
      *
      *   Celebration overlay logic temporarily disabled as requested.
      *   To re-enable, restore the original logic for showing the overlay.
      * */
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: AppPaddings.pageHome,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (user != null && user.name.trim().isNotEmpty)
                      ? _AnimatedAvatar(
                          initials: user.name
                              .trim()
                              .split(' ')
                              .map(
                                (e) => e.isNotEmpty ? e[0].toUpperCase() : '',
                              )
                              .take(2)
                              .join(),
                          color: theme.colorScheme.primary,
                        )
                      : Icon(
                          Icons.account_circle,
                          color: theme.colorScheme.primary.withOpacity(0.18),
                          size: AppIconSizes.extraBitLarge,
                        ),
                  AppSpacing.smallWidthSpacerWidget,
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          '${'hello'.tr}, ${user?.name.split(' ').first ?? 'user'.tr}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 4),
                  IconButton(
                    icon: Icon(
                      Icons.help_outline_rounded,
                      color: theme.colorScheme.primary,
                      size: AppIconSizes.large,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.FAQ);
                    },
                    tooltip: 'help_support'.tr,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: theme.colorScheme.primary,
                      size: AppIconSizes.large,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.settings);
                    },
                    tooltip: 'settings'.tr,
                  ),
                ],
              ),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildFinanceDataCardElevatedTEST(theme),
              // _buildPrimaryTontineSection(theme),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildQuickActionsSection(theme),
              AppSpacing.extraLargeHeightSpacerWidget,
              _buildRecentActivitiesSection(theme),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFinanceDataCardElevatedTEST(ThemeData theme) {
    final totalSavings = controller.getTotalSavings();
    final tontinesCount = controller.userTontines.length;
    final nextPaymentDate = tontinesCount > 0
        ? controller.userTontines.first.formattedNextPaymentDate
        : '--';
    final nextPaymentAmount = tontinesCount > 0
        ? Formatters.formatCurrency(
            controller.userTontines.first.contributionAmount,
          )
        : '--';

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              Color.lerp(
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
                0.4,
              )!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'total_savings'.tr.toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            AppSpacing.mediumHeightSpacer,
            AutoSizeText(
              totalSavings,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            AppSpacing.largeHeightSpacer,
            Divider(color: theme.colorScheme.onPrimary.withOpacity(0.2)),
            AppSpacing.mediumHeightSpacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'next_payment'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    AppSpacings.small,
                    Text(
                      nextPaymentDate,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'amount'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                    AppSpacings.small,
                    Text(
                      nextPaymentAmount,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDataCardElevated(ThemeData theme) {
    final totalSavings = controller.getTotalSavings();
    final tontinesCount = controller.userTontines.length;
    final nextPaymentDate = tontinesCount > 0
        ? controller.userTontines.first.formattedNextPaymentDate
        : '--';
    final nextPaymentAmount = tontinesCount > 0
        ? Formatters.formatCurrency(
            controller.userTontines.first.contributionAmount,
          )
        : '--';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 16.sp,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.12),
            blurRadius: 32.sp,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 32,
                  color: Colors.white,
                ),
                AppSpacing.smallWidthSpacerWidget,
                Text(
                  'total_savings'.tr,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.sp),
            Text(
              totalSavings,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.mediumHeightSpacer,
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
                          'next_payment'.tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacings.small,
                        Text(
                          nextPaymentDate,
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
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'amount'.tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacings.small,
                        Text(
                          nextPaymentAmount,
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
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 32.sp) / 3;
        return Wrap(
          spacing: 16.sp,
          runSpacing: 16.sp,
          children: controller.quickActions.map((action) {
            final bool isComingSoon =
                action.title == 'Sunu Points' || action.title == 'Rapports';

            final onTap = isComingSoon
                ? () {
                    ComingSoonTeaser.show(context, featureName: action.title);
                  }
                : action.onTap;
            return SizedBox(
              width: itemWidth,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                splashColor: action.color.withOpacity(0.2),
                highlightColor: action.color.withOpacity(0.1),
                onTap: onTap,
                onLongPress: onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.superExtraLarge,
                      height: AppSpacing.superExtraLargeH,
                      decoration: BoxDecoration(
                        color: action.color.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action.icon,
                        color: action.color,
                        size: AppIconSizes.large,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action.title,
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

  Widget _buildRecentActivitiesSection(ThemeData theme) {
    final activities = [
      {
        'icon': Icons.payment,
        'textKey': 'activity_payment',
        'subtitleKey': 'activity_payment_subtitle',
        'time': '2h',
      },
      {
        'icon': Icons.celebration,
        'textKey': 'activity_draw',
        'subtitleKey': 'activity_draw_subtitle',
        'time': '1j',
      },
      {
        'icon': Icons.schedule,
        'textKey': 'activity_reminder',
        'subtitleKey': 'activity_reminder_subtitle',
        'time': '2j',
      },
      {
        'icon': Icons.group_add,
        'textKey': 'activity_new_member',
        'subtitleKey': 'activity_new_member_subtitle',
        'time': '3j',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              color: theme.colorScheme.primary.withOpacity(0.8),
              size: AppIconSizes.medium,
            ),
            const SizedBox(width: 8),
            Text(
              'recent_activities'.tr,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        ...activities.map(
          (activity) => Container(
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
                  width: AppSpacing.extraBitLarge,
                  height: AppSpacing.extraBitLargeH,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    size: AppIconSizes.medium,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (activity['textKey'] as String).tr,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        (activity['subtitleKey'] as String).tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedAvatar extends StatefulWidget {
  final String initials;
  final Color color;

  const _AnimatedAvatar({required this.initials, required this.color});

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<double> _flip;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 1.18,
    ).chain(CurveTween(curve: Curves.elasticOut)).animate(_controller);
    _rotation = Tween<double>(
      begin: 0,
      end: 0.15,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_controller);
    _flip = Tween<double>(
      begin: 0,
      end: 3.14,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
  }

  void _onTap() {
    _controller.forward(from: 0).then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateY(_flip.value)
              ..rotateZ(_rotation.value)
              ..scale(_scale.value),
            child: child,
          );
        },
        child: Container(
          width: AppSpacing.extraBitLarge,
          height: AppSpacing.extraBitLargeH,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.13),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.initials,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: widget.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
