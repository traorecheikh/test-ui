import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../controllers/pot_visual_controller.dart';

class PotVisualScreen extends GetView<PotVisualController> {
  const PotVisualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState(theme);
        }
        
        if (controller.tontine.value == null) {
          return _buildErrorState(theme);
        }
        
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAnimatedAppBar(theme),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildMainPotVisualization(theme),
                  const SizedBox(height: 32),
                  _buildProgressStats(theme),
                  const SizedBox(height: 24),
                  _buildMotivationalSection(theme),
                  const SizedBox(height: 24),
                  _buildActionButtons(theme),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingRefreshButton(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            'Chargement de la cagnotte...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Impossible de charger la tontine',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Obx(() => Text(
          'Cagnotte ${controller.tontine.value?.name ?? ""}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        )).animate().slideY(begin: -0.3, delay: 100.ms),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => Row(
                  children: [
                    Icon(
                      controller.getPotIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.getPotStatus(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )).animate().slideY(begin: 0.3, delay: 200.ms),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: () => Get.back(),
          tooltip: 'Retour aux détails',
        ),
      ],
    );
  }

  Widget _buildMainPotVisualization(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow effect
          Obx(() => Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _getPotColor().withOpacity(0.2),
                  _getPotColor().withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 3000.ms)),
          
          // Main pot container
          _buildAnimatedPotContainer(theme),
          
          // Floating elements (coins/bills)
          ..._buildFloatingElements(theme),
          
          // Progress overlay
          _buildProgressOverlay(theme),
        ],
      ),
    );
  }

  Widget _buildAnimatedPotContainer(ThemeData theme) {
    return Obx(() {
      final progress = controller.animatedProgress.value;
      
      return Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(125),
            bottomRight: Radius.circular(125),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
              theme.colorScheme.primary.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: _getPotColor(),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: _getPotColor().withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Liquid fill
            Positioned(
              bottom: 0,
              left: 4,
              right: 4,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: (245 - 8) * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getPotColor().withOpacity(0.3),
                      _getPotColor().withOpacity(0.6),
                      _getPotColor(),
                      _getPotColor().withOpacity(0.9),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(121),
                    bottomRight: Radius.circular(121),
                  ),
                ),
              ),
            ),
            
            // Liquid surface animation
            if (progress > 0.1)
              Positioned(
                bottom: (245 - 8) * progress,
                left: 10,
                right: 10,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.6)),
              ),
            
            // Pot lid decoration
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getPotColor(),
                      _getPotColor().withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPotColor().withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().scale(delay: 400.ms, duration: 800.ms);
    });
  }

  List<Widget> _buildFloatingElements(ThemeData theme) {
    return [
      Obx(() {
        final progress = controller.progressPercentage.value;
        if (progress < 0.2) return const SizedBox.shrink();
        
        return Positioned(
          top: 50 + controller.coinAnimation.value,
          left: 50,
          child: _buildFloatingCoin(theme, 1),
        );
      }),
      Obx(() {
        final progress = controller.progressPercentage.value;
        if (progress < 0.2) return const SizedBox.shrink();
        
        return Positioned(
          top: 80 + controller.coinAnimation.value * 0.7,
          right: 60,
          child: _buildFloatingBill(theme, 1),
        );
      }),
      Obx(() {
        final progress = controller.progressPercentage.value;
        if (progress < 0.5) return const SizedBox.shrink();
        
        return Positioned(
          top: 120 + controller.coinAnimation.value * 1.2,
          left: 200,
          child: _buildFloatingCoin(theme, 2),
        );
      }),
      Obx(() {
        final progress = controller.progressPercentage.value;
        if (progress < 0.7) return const SizedBox.shrink();
        
        return Positioned(
          top: 60 + controller.coinAnimation.value * 0.9,
          left: 120,
          child: _buildFloatingBill(theme, 2),
        );
      }),
    ];
  }

  Widget _buildFloatingCoin(ThemeData theme, int index) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700), // Gold
            const Color(0xFFFFA500), // Orange
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'F',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .rotate(duration: 2000.ms + (index * 500).ms)
      .then()
      .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildFloatingBill(ThemeData theme, int index) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.tertiary,
            theme.colorScheme.tertiary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'CFA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
      .slideY(begin: 0, end: 0.3, duration: 1800.ms + (index * 300).ms);
  }

  Widget _buildProgressOverlay(ThemeData theme) {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.water_drop,
              color: _getPotColor(),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${(controller.progressPercentage.value * 100).toInt()}%',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'complété',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        )),
      ).animate().slideY(begin: 0.5, delay: 600.ms),
    );
  }

  Widget _buildProgressStats(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              theme,
              'Collecté',
              Obx(() => Text(
                Formatters.formatCurrency(controller.currentAmount.value.toDouble()),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.tertiary,
                ),
              )),
              Icons.account_balance_wallet,
              theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              theme,
              'Objectif',
              Obx(() => Text(
                Formatters.formatCurrency(controller.targetAmount.value.toDouble()),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              )),
              Icons.flag,
              theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String label, Widget valueWidget, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          valueWidget,
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 500.ms, duration: 600.ms);
  }

  Widget _buildMotivationalSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.secondary.withOpacity(0.1),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Obx(() => Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.getPotIcon(),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.getMotivationalMessage(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(height: 16),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildParticipantStat(
                theme,
                'Ont payé',
                '${controller.paidParticipants.value}',
                theme.colorScheme.tertiary,
              ),
              Container(
                height: 30,
                width: 1,
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
              _buildParticipantStat(
                theme,
                'Restants',
                '${controller.totalParticipants.value - controller.paidParticipants.value}',
                theme.colorScheme.error,
              ),
              Container(
                height: 30,
                width: 1,
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
              _buildParticipantStat(
                theme,
                'Total',
                '${controller.totalParticipants.value}',
                theme.colorScheme.primary,
              ),
            ],
          )),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _buildParticipantStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GodlyVibrateButton(
              onTap: controller.simulateContribution,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.tertiary,
                      theme.colorScheme.tertiary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Simuler contribution',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GodlyVibrateButton(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.surface,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Retour',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 800.ms);
  }

  Widget _buildFloatingRefreshButton(ThemeData theme) {
    return FloatingActionButton(
      onPressed: controller.refreshPotData,
      backgroundColor: theme.colorScheme.secondary,
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .shimmer(duration: 3000.ms, color: Colors.white.withOpacity(0.2));
  }

  Color _getPotColor() {
    return Get.find<PotVisualController>().progressPercentage.value >= 0.75
        ? const Color(0xFF34C759) // Success green
        : Get.find<PotVisualController>().progressPercentage.value >= 0.5
            ? const Color(0xFF4A90E2) // Secondary blue
            : const Color(0xFF1B365D); // Primary blue
  }
}