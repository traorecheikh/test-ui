import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/formatters.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = controller.currentUser.value;
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
                            .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Formatters.getGreeting()}, ${user?.name.split(' ').first ?? 'Utilisateur'}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                /*
              *
              *   IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: theme.colorScheme.secondary,
                    size: 28,
                  ),
                  onPressed: () {
                    controller.refreshTontines();
                  },
                  tooltip: 'Recharger les tontines',
                ),   c
              * */
                AppSpacing.smallWidthSpacerWidget,
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.colorScheme.primary,
                    size: AppIconSizes.large,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.settings);
                  },
                  tooltip: 'Paramètres',
                ),
              ],
            ),

            AppSpacing.extraLargeHeightSpacerWidget,
            _buildFinanceDataCard(theme),
            // _buildPrimaryTontineSection(theme),
            AppSpacing.extraLargeHeightSpacerWidget,
            _buildQuickActionsSection(theme),
            AppSpacing.extraLargeHeightSpacerWidget,
            _buildRecentActivitiesSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceDataCard(ThemeData theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 18.sp,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, size: 32, color: Colors.white),
              AppSpacing.extraLargeHeightSpacerWidget,
              Text(
                'Épargne Totale',
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
                        'Prochain paiement',
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
                        'Montant à payer',
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
    );
  }

  // Widget _buildPrimaryTontineSection(ThemeData theme) {
  //   final primaryTontine = controller.userTontines.isNotEmpty
  //       ? controller.userTontines.first
  //       : null;
  //
  //   if (primaryTontine == null) return const SizedBox.shrink();
  //
  //   return GestureDetector(
  //     onTap: () => Get.toNamed(Routes.detail, arguments: primaryTontine.id),
  //     child: Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: theme.colorScheme.primary,
  //         borderRadius: BorderRadius.circular(28),
  //         boxShadow: [
  //           BoxShadow(
  //             color: theme.colorScheme.primary.withOpacity(0.3),
  //             blurRadius: AppSpacing.large,
  //             offset: const Offset(0, 8),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             primaryTontine.name,
  //             style: theme.textTheme.headlineSmall?.copyWith(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           AppSpacing.largeWidthSpacer,
  //           Row(
  //             mainAxisAlignment:
  //                 MainAxisAlignment.spaceBetween, // Ensures even spacing
  //             crossAxisAlignment:
  //                 CrossAxisAlignment.center, // Vertically centers content
  //             children: [
  //               Text(
  //                 '${(primaryTontine.progress * 100).toStringAsFixed(0)}% complété',
  //                 style: theme.textTheme.bodyMedium?.copyWith(
  //                   color: Colors.white.withOpacity(0.8),
  //                 ),
  //               ),
  //               Text(
  //                 '${primaryTontine.members} membres',
  //                 style: theme.textTheme.bodyMedium?.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 12,
  //           ), // Consistent spacing before progress bar
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: LinearProgressIndicator(
  //               value: primaryTontine.progress,
  //               backgroundColor: Colors.white.withOpacity(0.2),
  //               valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
  //               minHeight: 10,
  //             ),
  //           ),
  //           const SizedBox(height: 24), // More space before next section
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: _buildInfoChip(
  //                   theme,
  //                   'Prochain Tirage',
  //                   primaryTontine.formattedNextPaymentDate,
  //                   Icons.calendar_today,
  //                   isWhite: true,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: _buildInfoChip(
  //                   theme,
  //                   'Ma Position',
  //                   '#${_getUserPosition(primaryTontine)}',
  //                   Icons.person_pin_circle,
  //                   isWhite: true,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: _buildInfoChip(
  //                   theme,
  //                   'Montant',
  //                   Formatters.formatCurrency(
  //                     primaryTontine.contributionAmount,
  //                   ),
  //                   Icons.account_balance_wallet,
  //                   isWhite: true,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // int _getUserPosition(Tontine tontine) {
  //   if (tontine.organizerId == controller.currentUser.value?.id) return 1;
  //   return 5; // Sample position
  // }
  //
  // Widget _buildInfoChip(
  //   ThemeData theme,
  //   String label,
  //   String value,
  //   IconData icon, {
  //   bool isWhite = false,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: isWhite
  //           ? Colors.white.withOpacity(0.15)
  //           : theme.colorScheme.surface,
  //       borderRadius: BorderRadius.circular(12),
  //       border: isWhite
  //           ? Border.all(color: Colors.white.withOpacity(0.2))
  //           : null,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               icon,
  //               size: 16,
  //               color: isWhite
  //                   ? Colors.white.withOpacity(0.8)
  //                   : theme.colorScheme.primary,
  //             ),
  //             const SizedBox(width: 6),
  //             Expanded(
  //               child: Text(
  //                 label,
  //                 style: theme.textTheme.bodySmall?.copyWith(
  //                   color: isWhite
  //                       ? Colors.white.withOpacity(0.8)
  //                       : theme.colorScheme.onSurface.withOpacity(0.7),
  //                 ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           value,
  //           style: theme.textTheme.bodyMedium?.copyWith(
  //             fontWeight: FontWeight.w600,
  //             color: isWhite ? Colors.white : theme.colorScheme.onSurface,
  //           ),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 32.sp) / 3;
        return Wrap(
          spacing: 16.sp,
          runSpacing: 16.sp,
          children: controller.quickActions
              .map(
                (action) => SizedBox(
                  width: itemWidth,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    splashColor: action.color.withOpacity(0.2),
                    highlightColor: action.color.withOpacity(0.1),
                    onTap: action.onTap,
                    onLongPress: action.onTap,
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
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRecentActivitiesSection(ThemeData theme) {
    final activities = [
      {
        'icon': Icons.payment,
        'text': 'Paiement 25,000 FCFA',
        'subtitle': 'Tontine Famille (+10 pts)',
        'time': '2h',
      },
      {
        'icon': Icons.celebration,
        'text': 'Tirage gagné',
        'subtitle': 'Moussa gagne 125,000 FCFA',
        'time': '1j',
      },
      {
        'icon': Icons.schedule,
        'text': 'Rappel cotisation',
        'subtitle': 'Demain à 14h00',
        'time': '2j',
      },
      {
        'icon': Icons.group_add,
        'text': 'Nouveau membre',
        'subtitle': 'Fatou a rejoint Tontine Amis',
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
              'Activités Récentes',
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
                        activity['text'] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        activity['subtitle'] as String,
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
