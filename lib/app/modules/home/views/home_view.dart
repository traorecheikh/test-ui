import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
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
          padding: const EdgeInsets.only(
            top: 32,
            left: 20,
            right: 20,
            bottom: 20,
          ),
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
                        size: 48,
                      ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Formatters.getGreeting()}, ${user?.name.split(' ').first ?? 'Utilisateur'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.settings);
                  },
                  tooltip: 'Paramètres',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildFinanceDataCard(theme),
            const SizedBox(height: 0),
            _buildPrimaryTontineSection(theme),
            const SizedBox(height: 32),
            _buildQuickActionsSection(theme),
            const SizedBox(height: 32),
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
            blurRadius: 18,
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
              const SizedBox(width: 12),
              Text(
                'Épargne Totale',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            totalSavings,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Prochain paiement',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextPaymentDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Montant à payer',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextPaymentAmount,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  Widget _buildPrimaryTontineSection(ThemeData theme) {
    final primaryTontine = controller.userTontines.isNotEmpty
        ? controller.userTontines.first
        : null;

    if (primaryTontine == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            primaryTontine.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12), // Increased spacing for better separation
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Ensures even spacing
            crossAxisAlignment:
                CrossAxisAlignment.center, // Vertically centers content
            children: [
              Text(
                '${(primaryTontine.progress * 100).toStringAsFixed(0)}% complété',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '${primaryTontine.members.length} membres',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Consistent spacing before progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: primaryTontine.progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 24), // More space before next section
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  theme,
                  'Prochain Tirage',
                  primaryTontine.formattedNextPaymentDate,
                  Icons.calendar_today,
                  isWhite: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoChip(
                  theme,
                  'Ma Position',
                  '#${_getUserPosition(primaryTontine)}',
                  Icons.person_pin_circle,
                  isWhite: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoChip(
                  theme,
                  'Montant',
                  Formatters.formatCurrency(primaryTontine.contributionAmount),
                  Icons.account_balance_wallet,
                  isWhite: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getUserPosition(Tontine tontine) {
    if (tontine.organizerId == controller.currentUser.value?.id) return 1;
    return 5; // Sample position
  }

  Widget _buildInfoChip(
    ThemeData theme,
    String label,
    String value,
    IconData icon, {
    bool isWhite = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.white.withOpacity(0.15)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isWhite
            ? Border.all(color: Colors.white.withOpacity(0.2))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isWhite
                    ? Colors.white.withOpacity(0.8)
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isWhite
                        ? Colors.white.withOpacity(0.8)
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isWhite ? Colors.white : theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 32) / 3;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
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
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: action.color.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action.icon,
                            color: action.color,
                            size: 32,
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
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Activités Récentes',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
                fontSize: 22,
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
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    size: 20,
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
                      const SizedBox(height: 2),
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
          width: 48,
          height: 48,
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
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtonData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _ActionButtonData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
