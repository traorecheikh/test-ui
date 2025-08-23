import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../../../widgets/modern_pot_visual.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  final String tontineId;
  const TontineDetailScreen({super.key, required this.tontineId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Chargement de votre tontine...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (controller.tontine.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Tontine')),
          body: const Center(child: Text('Tontine non trouvée')),
        );
      }
      final theme = Theme.of(context);
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildTerangaHeroHeader(theme),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProgressCardRow(theme).animate().slideY(begin: 0.3, delay: 200.ms),
                  _buildPrimaryActionZone(theme).animate().slideY(begin: 0.4, delay: 400.ms),
                  _buildSmartDetailsExpansion(theme).animate().slideY(begin: 0.5, delay: 600.ms),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildTerangaFloatingAction(theme),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _buildTerangaHeroHeader(ThemeData theme) {
    final tontine = controller.tontine.value!;
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final currentAmount = paidCount * tontine.contributionAmount;
    final progress = currentAmount / tontine.totalPot;

    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: _getTerangaGradientStart(progress),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
         /*
         *  decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
         *
         * */
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*
              Icon(
                _getTerangaTitleIcon(progress),
                color: Colors.white,
                size: 20,
              ),

            *
            *   const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tontine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            *
            * */
            ],
          ),
        ).animate().slideY(begin: -0.3, delay: 100.ms),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getTerangaGradientStart(progress),
                _getTerangaGradientMiddle(progress),
                _getTerangaGradientEnd(progress),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 70, 24, 20),
              child: Column(
                children: [
                  // Enhanced pot visual with cultural elements
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/pot-visual', arguments: {'tontineId': tontineId}),
                      child: ModernPotVisualWidget(
                        currentAmount: currentAmount,
                        targetAmount: tontine.totalPot,
                        paidParticipants: paidCount,
                        totalParticipants: tontine.participantIds.length,
                        onTap: () => Get.toNamed('/pot-visual', arguments: {'tontineId': tontineId}),
                      ).animate().scale(delay: 300.ms, duration: 600.ms),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Cultural stats row with enhanced design
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTerangaHeaderStat(
                          theme,
                          'Tour',
                          '${tontine.currentRound}/${tontine.totalRounds}',
                          Icons.loop,
                          _getStatColor(0),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        _buildTerangaHeaderStat(
                          theme,
                          'Membres',
                          '${tontine.participantIds.length}/${tontine.maxParticipants}',
                          Icons.groups,
                          _getStatColor(1),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        _buildTerangaHeaderStat(
                          theme,
                          'Statut',
                          tontine.status.label,
                          _getStatusIcon(tontine.status.name),
                          _getStatColor(2),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.2, delay: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: controller.showInviteDialog,
            tooltip: 'Partager',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: controller.showOptionsMenu,
            tooltip: 'Options',
          ),
        ),
      ],
    );
  }

  Widget _buildTerangaHeaderStat(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.3),
                accentColor.withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildOverviewTab(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentRoundSection(theme),
          const SizedBox(height: 32),
          _buildTontineInfoSection(theme),
          const SizedBox(height: 32),
          _buildQuickActionsSection(theme),
        ],
      ),
    );
  }

  Widget _buildCurrentRoundSection(ThemeData theme) {
    final tontine = controller.tontine.value!;
    final paidContributions = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final pendingContributions =
        controller.currentRoundContributions.length - paidContributions;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tour Actuel #${tontine.currentRound}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: 22,
                  ),
                ),
              ),
              if (tontine.nextContributionDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Échéance: ${Formatters.formatDate(tontine.nextContributionDate!)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme,
                  'Payé',
                  '$paidContributions',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  theme,
                  'En attente',
                  '$pendingContributions',
                  Icons.hourglass_empty,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  theme,
                  'Total',
                  Formatters.formatCurrency(tontine.totalPot),
                  Icons.account_balance_wallet,
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTontineInfoSection(ThemeData theme) {
    final tontine = controller.tontine.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de la Tontine',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                theme,
                'Description',
                tontine.description,
                Icons.description,
              ),
              _buildInfoRow(
                theme,
                'Contribution',
                Formatters.formatCurrency(tontine.contributionAmount),
                Icons.account_balance_wallet,
              ),
              _buildInfoRow(
                theme,
                'Fréquence',
                tontine.frequency.label,
                Icons.schedule,
              ),
              _buildInfoRow(
                theme,
                'Ordre de tirage',
                tontine.drawOrder.label,
                Icons.shuffle,
              ),
              _buildInfoRow(
                theme,
                'Pénalité retard',
                '${tontine.penaltyPercentage}%',
                Icons.warning,
              ),
              _buildInfoRow(
                theme,
                'Date de création',
                Formatters.formatDate(tontine.createdAt),
                Icons.calendar_today,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              color: theme.colorScheme.primary.withOpacity(0.18),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Actions Rapides',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                theme,
                'Payer Ma Part',
                'Contribuer maintenant',
                Icons.payment,
                Colors.green,
                () => controller.showPaymentDialog(),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _buildActionCard(
                theme,
                'Inviter',
                'Ajouter des membres',
                Icons.person_add,
                theme.colorScheme.secondary,
                () => controller.showInviteDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTab(BuildContext context) {
    final theme = Theme.of(context);
    final tontine = controller.tontine.value!;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tontine.participantIds.length,
      itemBuilder: (context, index) {
        final participantId = tontine.participantIds[index];
        final isOrganizer = participantId == tontine.organizerId;
        final contribution = controller.currentRoundContributions
            .where((c) => c.participantId == participantId)
            .firstOrNull;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOrganizer ? Icons.admin_panel_settings : Icons.person,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.sampleParticipantNames[index %
                          AppConstants.sampleParticipantNames.length],
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isOrganizer)
                      Text(
                        'Organisateur',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              if (contribution != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: contribution.isPaid ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contribution.isPaid
                        ? 'Payé ${Formatters.getTimeAgo(contribution.paidDate!)}'
                        : 'En attente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    final theme = Theme.of(context);
    final tontine = controller.tontine.value!;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tontine.currentRound,
      itemBuilder: (context, index) {
        final round = tontine.currentRound - index;
        final roundContributions = controller.getRoundContributions(round);
        final paidCount = roundContributions.where((c) => c.isPaid).length;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: round == tontine.currentRound
                          ? Colors.blue
                          : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      round == tontine.currentRound ? 'En cours' : 'Terminé',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Participants payés: $paidCount/${roundContributions.length}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    'Total: ${Formatters.formatCurrency(paidCount * tontine.contributionAmount)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (round < tontine.currentRound) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.celebration, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      'Gagnant: ${AppConstants.sampleParticipantNames[round % AppConstants.sampleParticipantNames.length]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    final theme = Theme.of(context);
    final tontine = controller.tontine.value!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (tontine.rules.isNotEmpty) ...[
          Text(
            'Règles de la Tontine',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...tontine.rules.map(
            (rule) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(rule)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          'Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.share, color: theme.colorScheme.primary),
          title: const Text('Partager la tontine'),
          subtitle: const Text('Inviter de nouveaux membres'),
          onTap: () => controller.showInviteDialog(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
        ),
        const SizedBox(height: 8),
        if (controller.isOrganizer.value) ...[
          ListTile(
            leading: Icon(Icons.settings, color: theme.colorScheme.secondary),
            title: const Text('Gérer la tontine'),
            subtitle: const Text('Paramètres organisateur'),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ListTile(
          leading: Icon(Icons.exit_to_app, color: theme.colorScheme.error),
          title: const Text('Quitter la tontine'),
          subtitle: const Text('Attention: Action irréversible'),
          onTap: () => controller.showLeaveConfirmation(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(ThemeData theme) {
    return controller.buildFloatingActionButton(theme);
  }

  // Missing methods implementation with Senegalese cultural design

  Widget _buildProgressCardRow(ThemeData theme) {
    final tontine = controller.tontine.value!;
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final currentAmount = paidCount * tontine.contributionAmount;
    final progress = currentAmount / tontine.totalPot;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Progress indicator with cultural elements
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Progrès du Tour',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(progress * 100).toInt()}% complété',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$paidCount/${tontine.participantIds.length} membres ont contribué',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Amount display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.secondaryContainer,
                    theme.colorScheme.secondaryContainer.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Collecté',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.formatCurrency(currentAmount),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'sur ${Formatters.formatCurrency(tontine.totalPot)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionZone(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          // Main action buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GodlyVibrateButton(
                  onTap: () => controller.showPaymentDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade600,
                          Colors.green.shade500,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payer Ma Part',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(controller.tontine.value!.contributionAmount),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GodlyVibrateButton(
                  onTap: () => controller.showTransactionHistory(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Historique',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Secondary actions
          Row(
            children: [
              Expanded(
                child: GodlyVibrateButton(
                  onTap: () => controller.showInviteDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Inviter',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
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
                  onTap: () => controller.showOptionsMenu(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Messages',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
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
        ],
      ),
    );
  }

  Widget _buildSmartDetailsExpansion(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        collapsedBackgroundColor: theme.colorScheme.surface,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.info_outline,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          'Détails de la Tontine',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Informations, règles et participants',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                    indicatorColor: theme.colorScheme.primary,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Vue d\'ensemble'),
                      Tab(text: 'Participants'),
                      Tab(text: 'Historique'),
                      Tab(text: 'Paramètres'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: Builder(
                      builder: (context) => TabBarView(
                        children: [
                          _buildOverviewTab(context),
                          _buildParticipantsTab(context),
                          _buildHistoryTab(context),
                          _buildSettingsTab(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerangaFloatingAction(ThemeData theme) {
    final tontine = controller.tontine.value!;
    final hasUnpaidContribution = controller.currentRoundContributions
        .any((c) => !c.isPaid && c.participantId == controller.currentUserId);

    if (!hasUnpaidContribution) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade600,
            Colors.orange.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => controller.showPaymentDialog(),
        icon: const Icon(
          Icons.payment,
          color: Colors.white,
        ),
        label: const Text(
          'Contribution Due',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate().slideY(begin: 1, delay: 800.ms).then().shimmer(
      duration: 2000.ms,
      color: Colors.white.withOpacity(0.3),
    );
  }

  // Helper methods for Senegalese cultural theming
  Color _getTerangaGradientStart(double progress) {
    if (progress < 0.3) return const Color(0xFF8B4513); // Saddle brown - earth
    if (progress < 0.7) return const Color(0xFF4A90E2); // Light blue - progress
    return const Color(0xFF228B22); // Forest green - success
  }

  Color _getTerangaGradientMiddle(double progress) {
    if (progress < 0.3) return const Color(0xFFCD853F); // Peru - warm earth
    if (progress < 0.7) return const Color(0xFF87CEEB); // Sky blue - hope
    return const Color(0xFF32CD32); // Lime green - abundance
  }

  Color _getTerangaGradientEnd(double progress) {
    if (progress < 0.3) return const Color(0xFFF4A460); // Sandy brown - hospitality
    if (progress < 0.7) return const Color(0xFFE6F3FF); // Light blue - peace
    return const Color(0xFF98FB98); // Pale green - prosperity
  }

  IconData _getTerangaTitleIcon(double progress) {
    if (progress < 0.3) return Icons.hourglass_empty;
    if (progress < 0.7) return Icons.trending_up;
    return Icons.celebration;
  }

  Color _getStatColor(int index) {
    const colors = [
      Color(0xFF4A90E2), // Light blue
      Color(0xFF34C759), // Green
      Color(0xFFFF9500), // Orange
    ];
    return colors[index % colors.length];
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'actif':
        return Icons.play_circle_filled;
      case 'completed':
      case 'terminé':
        return Icons.check_circle;
      case 'pending':
      case 'en_attente':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }
}
