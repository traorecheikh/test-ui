import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../../../widgets/modern_pot_visual.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  final int tontineId;
  const TontineDetailScreen({super.key, required this.tontineId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingExperience(context);
      }
      
      final tontine = controller.tontine.value;
      if (tontine == null) {
        return _buildErrorExperience(context);
      }

      return _buildMainExperience(context, tontine);
    });
  }

  // ================================
  // LOADING & ERROR EXPERIENCES
  // ================================

  Widget _buildLoadingExperience(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ).animate().scale(
              duration: 1200.ms, 
              curve: Curves.easeInOut,
            ).then().shimmer(duration: 1500.ms),
            SizedBox(height: 32.h),
            Text(
              'Préparation de votre tontine...',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 300.ms),
            SizedBox(height: 8.h),
            Text(
              'Un moment s\'il vous plaît',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorExperience(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GodlyVibrateButton(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 48.w,
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Tontine introuvable',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Cette tontine n\'existe pas ou a été supprimée.\nVeuillez vérifier le lien ou contacter l\'organisateur.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              GodlyVibrateButton(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    'Retour à l\'accueil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================
  // MAIN TONTINE EXPERIENCE
  // ================================

  Widget _buildMainExperience(BuildContext context, tontine) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await controller.refreshTontineData();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildImmersiveHeroSection(theme, tontine),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildActionCommandCenter(theme, tontine)
                    .animate()
                    .slideY(begin: 0.3, delay: 200.ms)
                    .fadeIn(),
                  SizedBox(height: 24.h),
                  _buildSmartOverviewCards(theme, tontine)
                    .animate()
                    .slideY(begin: 0.4, delay: 400.ms)
                    .fadeIn(),
                  SizedBox(height: 24.h),
                  _buildParticipantSocialStream(theme, tontine)
                    .animate()
                    .slideY(begin: 0.5, delay: 600.ms)
                    .fadeIn(),
                  SizedBox(height: 24.h),
                  _buildContextualInsights(theme, tontine)
                    .animate()
                    .slideY(begin: 0.6, delay: 800.ms)
                    .fadeIn(),
                  SizedBox(height: 100.h), // Space for floating elements
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSmartFloatingActions(theme, tontine),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ================================
  // IMMERSIVE HERO SECTION
  // ================================

  Widget _buildImmersiveHeroSection(ThemeData theme, tontine) {
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final currentAmount = (paidCount * tontine.contributionAmount).toDouble();
    final progress = tontine.totalPot > 0 ? (currentAmount / tontine.totalPot).clamp(0.0, 1.0) : 0.0;
    final healthColor = _getTontineHealthColor(progress);

    return SliverAppBar(
      expandedHeight: 420.h,
      pinned: true,
      stretch: true,
      backgroundColor: healthColor.withOpacity(0.1),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: GodlyVibrateButton(
        onTap: () => Get.back(),
        child: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: healthColor,
            size: 20.w,
          ),
        ),
      ),
      actions: [
        GodlyVibrateButton(
          onTap: () => controller.showShareDialog(),
          child: Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.share_rounded,
              color: healthColor,
              size: 20.w,
            ),
          ),
        ),
        GodlyVibrateButton(
          onTap: () => controller.showOptionsMenu(),
          child: Container(
            margin: EdgeInsets.only(right: 16.w, top: 8.w, bottom: 8.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: healthColor,
              size: 20.w,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                healthColor,
                healthColor.withOpacity(0.8),
                healthColor.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tontine name and status
                  _buildHeroTitle(theme, tontine, healthColor)
                    .animate()
                    .slideX(begin: -0.3, delay: 100.ms)
                    .fadeIn(),
                  SizedBox(height: 24.h),
                  
                  // Main progress visualization
                  Expanded(
                    child: _buildHeroProgressVisualization(theme, tontine, progress, currentAmount, paidCount)
                      .animate()
                      .scale(delay: 300.ms, duration: 800.ms, curve: Curves.easeOutBack),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Live stats bar
                  _buildLiveStatsBar(theme, tontine, progress, paidCount)
                    .animate()
                    .slideY(begin: 0.3, delay: 600.ms)
                    .fadeIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTitle(ThemeData theme, tontine, Color healthColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _getStatusDotColor(tontine.status.label),
                      shape: BoxShape.circle,
                    ),
                  ).animate().scale(
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ).then().shimmer(duration: 2000.ms),
                  SizedBox(width: 8.w),
                  Text(
                    tontine.status.label.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          tontine.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            height: 1.2,
            shadows: [
              Shadow(
                offset: const Offset(0, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          _getHeroSubtitle(tontine),
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroProgressVisualization(ThemeData theme, tontine, double progress, double currentAmount, int paidCount) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer progress ring
          SizedBox(
            width: 200.w,
            height: 200.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12.w,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          
          // Inner content
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: _getTontineHealthColor(progress),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Complété',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  Formatters.formatCurrency(currentAmount),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatsBar(ThemeData theme, tontine, double progress, int paidCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Tour',
            '${tontine.currentRound}/${tontine.totalRounds}',
            Icons.refresh,
            theme.colorScheme.primary,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Membres',
            '${paidCount}/${tontine.participantIds.length}',
            Icons.group,
            progress > 0.7 ? Colors.green : Colors.orange,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Objectif',
            Formatters.formatCurrency(tontine.totalPot),
            Icons.flag,
            theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16.w,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1.w,
      height: 40.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.grey.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ================================
  // ACTION COMMAND CENTER
  // ================================

  Widget _buildActionCommandCenter(ThemeData theme, tontine) {
    final hasUnpaidContribution = controller.currentRoundContributions
        .any((c) => !c.isPaid && c.participantId == controller.currentUserId);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Primary action button
          if (hasUnpaidContribution)
            _buildPrimaryActionButton(theme, tontine),
          
          SizedBox(height: hasUnpaidContribution ? 16.h : 0),
          
          // Secondary actions row
          _buildSecondaryActionsRow(theme, tontine),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(ThemeData theme, tontine) {
    return GodlyVibrateButton(
      onTap: () => controller.showPaymentDialog(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF34C759), Color(0xFF30D158)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34C759).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payment_rounded,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payer Ma Contribution',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  Formatters.formatCurrency(tontine.contributionAmount),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16.w,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(
      delay: 100.ms,
      duration: 600.ms,
      curve: Curves.easeOutBack,
    ).then().shimmer(
      duration: 2000.ms,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildSecondaryActionsRow(ThemeData theme, tontine) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryActionCard(
            theme,
            'Inviter',
            'Ajouter des amis',
            Icons.person_add_rounded,
            theme.colorScheme.secondary,
            () => controller.showInviteDialog(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSecondaryActionCard(
            theme,
            'Historique',
            'Voir les paiements',
            Icons.history_rounded,
            Colors.purple,
            () => _showHistoryBottomSheet(theme, tontine),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSecondaryActionCard(
            theme,
            'Messages',
            'Chat du groupe',
            Icons.chat_bubble_rounded,
            Colors.orange,
            () => _showMessagesBottomSheet(theme, tontine),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActionCard(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GodlyVibrateButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.w,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // SMART OVERVIEW CARDS
  // ================================

  Widget _buildSmartOverviewCards(ThemeData theme, tontine) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aperçu Intelligent',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildContributionStatusCard(theme, tontine),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildNextDrawCard(theme, tontine),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTontineInfoCard(theme, tontine),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContributionStatusCard(ThemeData theme, tontine) {
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final pendingCount = controller.currentRoundContributions.length - paidCount;
    final progress = controller.currentRoundContributions.isNotEmpty 
        ? paidCount / controller.currentRoundContributions.length 
        : 0.0;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: theme.colorScheme.primary,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tour Actuel #${tontine.currentRound}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      _getProgressMessage(progress),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(8.r),
            minHeight: 8.h,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat('Payé', paidCount.toString(), Colors.green),
              _buildProgressStat('En attente', pendingCount.toString(), Colors.orange),
              _buildProgressStat('Total', '${controller.currentRoundContributions.length}', theme.colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildNextDrawCard(ThemeData theme, tontine) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: theme.colorScheme.secondary,
              size: 20.w,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Prochain Tirage',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tontine.nextContributionDate != null 
              ? Formatters.formatDate(tontine.nextContributionDate!)
              : 'À définir',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTontineInfoCard(ThemeData theme, tontine) {
    return GodlyVibrateButton(
      onTap: () => _showTontineDetailsBottomSheet(theme, tontine),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.purple.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: Colors.purple,
                    size: 20.w,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.purple.withOpacity(0.7),
                  size: 16.w,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Détails Complets',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Voir tout',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // PARTICIPANT SOCIAL STREAM
  // ================================

  Widget _buildParticipantSocialStream(ThemeData theme, tontine) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Communauté',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              GodlyVibrateButton(
                onTap: () => _showAllParticipantsBottomSheet(theme, tontine),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tous',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.primary,
                        size: 14.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: math.min(tontine.participantIds.length, 5),
              itemBuilder: (context, index) {
                final participantId = tontine.participantIds[index];
                final isOrganizer = participantId == tontine.organizerId;
                final contribution = controller.currentRoundContributions
                    .where((c) => c.participantId == participantId)
                    .firstOrNull;
                
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: _buildParticipantAvatar(theme, participantId, isOrganizer, contribution, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantAvatar(ThemeData theme, int participantId, bool isOrganizer, contribution, int index) {
    final name = AppConstants.sampleParticipantNames[index % AppConstants.sampleParticipantNames.length];
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    final isPaid = contribution?.isPaid ?? false;
    
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPaid ? Colors.green : Colors.orange.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (isOrganizer)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 12.w,
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  isPaid ? Icons.check : Icons.schedule,
                  color: Colors.white,
                  size: 12.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          name.split(' ')[0],
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          isPaid ? 'Payé' : 'En attente',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isPaid ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  // ================================
  // CONTEXTUAL INSIGHTS
  // ================================

  Widget _buildContextualInsights(ThemeData theme, tontine) {
    final insights = _generateContextualInsights(tontine);
    
    if (insights.isEmpty) return const SizedBox();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conseils Personnalisés',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.h),
          ...insights.map((insight) => _buildInsightCard(theme, insight)).toList(),
        ],
      ),
    );
  }

  Widget _buildInsightCard(ThemeData theme, Map<String, dynamic> insight) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: insight['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: insight['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: insight['color'].withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              insight['icon'],
              color: insight['color'],
              size: 20.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: insight['color'],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  insight['message'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // SMART FLOATING ACTIONS
  // ================================

  Widget _buildSmartFloatingActions(ThemeData theme, tontine) {
    final hasUrgentAction = _hasUrgentAction(tontine);
    
    if (!hasUrgentAction) return const SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildUrgentActionFAB(theme, tontine),
          ),
          SizedBox(width: 16.w),
          _buildQuickActionsFAB(theme),
        ],
      ),
    );
  }

  Widget _buildUrgentActionFAB(ThemeData theme, tontine) {
    return GodlyVibrateButton(
      onTap: () => controller.showPaymentDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.priority_high,
                color: Colors.white,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contribution Due',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Payer maintenant',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
      .slideY(begin: 1, delay: 800.ms)
      .fadeIn()
      .then()
      .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildQuickActionsFAB(ThemeData theme) {
    return GodlyVibrateButton(
      onTap: () => _showQuickActionsBottomSheet(theme),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.more_horiz,
          color: theme.colorScheme.primary,
          size: 24.w,
        ),
      ),
    ).animate()
      .slideY(begin: 1, delay: 1000.ms)
      .fadeIn();
  }

  // ================================
  // BOTTOM SHEETS
  // ================================

  void _showHistoryBottomSheet(ThemeData theme, tontine) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: theme.colorScheme.primary,
                    size: 24.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Historique des Contributions',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: tontine.currentRound,
                itemBuilder: (context, index) {
                  final round = tontine.currentRound - index;
                  return _buildHistoryRoundCard(theme, tontine, round);
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showMessagesBottomSheet(ThemeData theme, tontine) {
    // Implementation for messages
    Get.snackbar(
      'Fonctionnalité à venir',
      'Les messages de groupe arrivent bientôt !',
      backgroundColor: theme.colorScheme.primaryContainer,
      colorText: theme.colorScheme.onPrimaryContainer,
    );
  }

  void _showTontineDetailsBottomSheet(ThemeData theme, tontine) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: theme.colorScheme.primary,
                    size: 24.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Détails de la Tontine',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildTontineDetailsContent(theme, tontine),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAllParticipantsBottomSheet(ThemeData theme, tontine) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    color: theme.colorScheme.primary,
                    size: 24.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Tous les Participants',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${tontine.participantIds.length}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: tontine.participantIds.length,
                itemBuilder: (context, index) {
                  final participantId = tontine.participantIds[index];
                  final isOrganizer = participantId == tontine.organizerId;
                  final contribution = controller.currentRoundContributions
                      .where((c) => c.participantId == participantId)
                      .firstOrNull;
                  
                  return _buildParticipantListItem(theme, participantId, isOrganizer, contribution, index);
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showQuickActionsBottomSheet(ThemeData theme) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Text(
                'Actions Rapides',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
              child: Column(
                children: [
                  _buildQuickActionItem(
                    theme,
                    'Partager la Tontine',
                    'Inviter de nouveaux membres',
                    Icons.share,
                    () {
                      Get.back();
                      controller.showInviteDialog();
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildQuickActionItem(
                    theme,
                    'Notifications',
                    'Gérer les alertes',
                    Icons.notifications,
                    () {
                      Get.back();
                      Get.snackbar('À venir', 'Fonctionnalité bientôt disponible');
                    },
                  ),
                  SizedBox(height: 16.h),
                  if (controller.isOrganizer.value)
                    _buildQuickActionItem(
                      theme,
                      'Gérer la Tontine',
                      'Options organisateur',
                      Icons.admin_panel_settings,
                      () {
                        Get.back();
                        Get.snackbar('À venir', 'Panneau administrateur bientôt disponible');
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GodlyVibrateButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.primary.withOpacity(0.7),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // HELPER WIDGETS
  // ================================

  Widget _buildHistoryRoundCard(ThemeData theme, tontine, int round) {
    final roundContributions = controller.getRoundContributions(round);
    final paidCount = roundContributions.where((c) => c.isPaid).length;
    final isCurrentRound = round == tontine.currentRound;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrentRound 
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrentRound 
            ? theme.colorScheme.primary.withOpacity(0.3)
            : theme.colorScheme.outline.withOpacity(0.2),
          width: isCurrentRound ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tour #$round',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isCurrentRound ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  isCurrentRound ? 'En cours' : 'Terminé',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Participants payés: $paidCount/${roundContributions.length}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Text(
                'Total: ${Formatters.formatCurrency((paidCount * tontine.contributionAmount).toDouble())}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (!isCurrentRound) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.celebration, size: 16.w, color: Colors.green),
                SizedBox(width: 8.w),
                Text(
                  'Gagnant: ${AppConstants.sampleParticipantNames[round % AppConstants.sampleParticipantNames.length]}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTontineDetailsContent(ThemeData theme, tontine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSection(
          theme,
          'Description',
          tontine.description,
          Icons.description,
        ),
        SizedBox(height: 20.h),
        _buildDetailSection(
          theme,
          'Contribution',
          Formatters.formatCurrency(tontine.contributionAmount),
          Icons.account_balance_wallet,
        ),
        SizedBox(height: 20.h),
        _buildDetailSection(
          theme,
          'Fréquence',
          tontine.frequency.label,
          Icons.schedule,
        ),
        SizedBox(height: 20.h),
        _buildDetailSection(
          theme,
          'Ordre de tirage',
          tontine.drawOrder.label,
          Icons.shuffle,
        ),
        SizedBox(height: 20.h),
        _buildDetailSection(
          theme,
          'Pénalité retard',
          '${tontine.penaltyPercentage}%',
          Icons.warning,
        ),
        SizedBox(height: 20.h),
        _buildDetailSection(
          theme,
          'Date de création',
          Formatters.formatDate(tontine.createdAt),
          Icons.calendar_today,
        ),
        if (tontine.rules.isNotEmpty) ...[
          SizedBox(height: 30.h),
          Text(
            'Règles de la Tontine',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.h),
          ...tontine.rules.map(
            (rule) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20.w,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      rule,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDetailSection(ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantListItem(ThemeData theme, int participantId, bool isOrganizer, contribution, int index) {
    final name = AppConstants.sampleParticipantNames[index % AppConstants.sampleParticipantNames.length];
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    final isPaid = contribution?.isPaid ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPaid ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (isOrganizer)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                if (isOrganizer)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Organisateur',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaid ? Icons.check : Icons.schedule,
                  color: Colors.white,
                  size: 16.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  isPaid 
                    ? (contribution?.paidDate != null 
                        ? 'Payé ${Formatters.getTimeAgo(contribution!.paidDate!)}'
                        : 'Payé')
                    : 'En attente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // HELPER METHODS
  // ================================

  Color _getTontineHealthColor(double progress) {
    if (progress < 0.3) return const Color(0xFF8B4513); // Saddle brown - starting
    if (progress < 0.7) return const Color(0xFF4A90E2); // Light blue - progressing
    return const Color(0xFF34C759); // Green - thriving
  }

  Color _getStatusDotColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'en attente':
        return Colors.orange;
      case 'terminée':
        return Colors.blue;
      case 'annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getHeroSubtitle(tontine) {
    final progress = controller.currentRoundContributions.isNotEmpty 
        ? controller.currentRoundContributions.where((c) => c.isPaid).length / controller.currentRoundContributions.length
        : 0.0;
    
    if (progress == 1.0) return 'Tour complété avec succès ! 🎉';
    if (progress > 0.7) return 'Excellente progression ce mois-ci';
    if (progress > 0.3) return 'La communauté se mobilise';
    return 'Ensemble, construisons notre avenir';
  }

  String _getProgressMessage(double progress) {
    if (progress == 1.0) return 'Tour complété ! 🎉';
    if (progress > 0.8) return 'Presque terminé';
    if (progress > 0.5) return 'Bonne progression';
    if (progress > 0.2) return 'En cours';
    return 'Vient de commencer';
  }

  List<Map<String, dynamic>> _generateContextualInsights(tontine) {
    final insights = <Map<String, dynamic>>[];
    final progress = controller.currentRoundContributions.isNotEmpty 
        ? controller.currentRoundContributions.where((c) => c.isPaid).length / controller.currentRoundContributions.length
        : 0.0;
    
    // Personal payment status insight
    final hasUnpaidContribution = controller.currentRoundContributions
        .any((c) => !c.isPaid && c.participantId == controller.currentUserId);
    
    if (hasUnpaidContribution) {
      insights.add({
        'title': 'Contribution En Attente',
        'message': 'Votre paiement pour ce tour est attendu. Payez maintenant pour éviter les pénalités.',
        'icon': Icons.payment,
        'color': Colors.orange,
      });
    }
    
    // Progress insight
    if (progress > 0 && progress < 1.0) {
      final remaining = controller.currentRoundContributions.length - controller.currentRoundContributions.where((c) => c.isPaid).length;
      insights.add({
        'title': 'Progression du Tour',
        'message': 'Plus que $remaining paiements attendus pour compléter ce tour.',
        'icon': Icons.trending_up,
        'color': Colors.blue,
      });
    }
    
    // Community insight
    if (tontine.participantIds.length < tontine.maxParticipants) {
      final available = tontine.maxParticipants - tontine.participantIds.length;
      insights.add({
        'title': 'Invitez Vos Proches',
        'message': '$available places sont encore disponibles. Plus nous sommes, plus le pot grandit !',
        'icon': Icons.group_add,
        'color': Colors.green,
      });
    }
    
    return insights;
  }

  bool _hasUrgentAction(tontine) {
    return controller.currentRoundContributions
        .any((c) => !c.isPaid && c.participantId == controller.currentUserId);
  }
}