import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../../../widgets/pot_visual.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  final String tontineId;
  const TontineDetailScreen({super.key, required this.tontineId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (controller.tontine.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Tontine')),
          body: const Center(child: Text('Tontine non trouvée')),
        );
      }
      final theme = Theme.of(context);
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(theme),
            SliverFillRemaining(
              child: Column(
                children: [
                  _buildTabBar(theme),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        _buildOverviewTab(context),
                        _buildParticipantsTab(context),
                        _buildHistoryTab(context),
                        _buildSettingsTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(theme),
      );
    });
  }

  Widget _buildAppBar(ThemeData theme) {
    final tontine = controller.tontine.value!;
    final paidCount = controller.currentRoundContributions
        .where((c) => c.isPaid)
        .length;
    final currentAmount = paidCount * tontine.contributionAmount;
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tontine.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 70, 24, 20),
              child: Column(
                children: [
                  Expanded(
                    child: PotVisualWidget(
                      currentAmount: currentAmount,
                      targetAmount: tontine.totalPot,
                      paidParticipants: paidCount,
                      totalParticipants: tontine.participantIds.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        theme,
                        'Tour',
                        '${tontine.currentRound}/${tontine.totalRounds}',
                        Icons.trending_up,
                      ),
                      _buildHeaderStat(
                        theme,
                        'Statut',
                        tontine.status.label,
                        Icons.info,
                      ),
                      _buildHeaderStat(
                        theme,
                        'Participants',
                        '${tontine.participantIds.length}/${tontine.maxParticipants}',
                        Icons.group,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        if (controller.isOrganizer.value)
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: controller.showInviteDialog,
          ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: controller.showOptionsMenu,
        ),
      ],
    );
  }

  Widget _buildHeaderStat(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: TabBar(
        controller: controller.tabController,
        tabs: const [
          Tab(text: 'Vue d\'ensemble'),
          Tab(text: 'Participants'),
          Tab(text: 'Historique'),
          Tab(text: 'Paramètres'),
        ],
      ),
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
}
