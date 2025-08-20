import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (controller.currentUser.value == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: const Center(child: Text('Utilisateur non trouvé')),
        );
      }
      final theme = Theme.of(context);
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: CustomScrollView(
          slivers: [
            _buildAppBar(theme),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsSection(theme),
                  const SizedBox(height: 32),
                  _buildPersonalInfoSection(theme),
                  const SizedBox(height: 32),
                  _buildAchievementsSection(theme),
                  const SizedBox(height: 32),
                  _buildPreferencesSection(theme),
                  const SizedBox(height: 32),
                  _buildSupportSection(theme),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAppBar(ThemeData theme) {
    final user = controller.currentUser.value!;
    return SliverAppBar(
      expandedHeight: 240,
      pinned: false,
      backgroundColor: theme.colorScheme.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: theme.colorScheme.background,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.18),
                            width: 4,
                          ),
                          image: user.profileImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(user.profileImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: user.profileImageUrl == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.5,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Formatters.formatPhoneNumber(user.phone),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              '${user.sunuPoints} pts',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          user.level.label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    final user = controller.currentUser.value!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Statistiques',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Tontines',
                  '${user.totalTontines}',
                  Icons.account_balance_wallet,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Organisées',
                  '${user.organizedTontineIds.length}',
                  Icons.admin_panel_settings,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Score',
                  '${user.reliabilityScore}/5',
                  Icons.star,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(ThemeData theme) {
    final user = controller.currentUser.value!;
    return _buildSection(theme, 'Informations Personnelles', [
      _buildInfoTile(
        theme,
        'Téléphone',
        Formatters.formatPhoneNumber(user.phone),
        Icons.phone,
        controller.editProfile,
      ),
      if (user.email != null)
        _buildInfoTile(
          theme,
          'Email',
          user.email!,
          Icons.email,
          controller.editProfile,
        ),
      _buildInfoTile(
        theme,
        'Membre depuis',
        Formatters.formatDate(user.createdAt),
        Icons.calendar_today,
        null,
      ),
    ]);
  }

  Widget _buildAchievementsSection(ThemeData theme) {
    final achievements = [
      {
        'name': 'Premier Pas',
        'desc': 'Première contribution',
        'icon': Icons.verified,
        'earned': true,
      },
      {
        'name': 'Régulier',
        'desc': '10 paiements à temps',
        'icon': Icons.schedule,
        'earned': true,
      },
      {
        'name': 'Organisateur',
        'desc': 'Première tontine créée',
        'icon': Icons.group_add,
        'earned': false,
      },
      {
        'name': 'Ambassadeur',
        'desc': '5 amis invités',
        'icon': Icons.people,
        'earned': false,
      },
    ];

    return _buildSection(theme, 'Badges et Réalisations', [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final isEarned = achievement['earned'] as bool;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEarned
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isEarned
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  achievement['icon'] as IconData,
                  size: 32,
                  color: isEarned
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  achievement['name'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isEarned
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  achievement['desc'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isEarned
                        ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildPreferencesSection(ThemeData theme) {
    final user = controller.currentUser.value!;
    return _buildSection(theme, 'Préférences', [
      SwitchListTile(
        title: const Text('Mode sombre'),
        subtitle: const Text('Interface avec thème sombre'),
        value: user.preferences.darkMode,
        onChanged: (value) => controller.updatePreference('darkMode', value),
        secondary: const Icon(Icons.dark_mode),
      ),
      SwitchListTile(
        title: const Text('Notifications'),
        subtitle: const Text('Recevoir les rappels et alertes'),
        value: user.preferences.notificationsEnabled,
        onChanged: (value) =>
            controller.updatePreference('notifications', value),
        secondary: const Icon(Icons.notifications),
      ),
      SwitchListTile(
        title: const Text('Sons'),
        subtitle: const Text('Sons pour les notifications'),
        value: user.preferences.soundEnabled,
        onChanged: (value) => controller.updatePreference('sound', value),
        secondary: const Icon(Icons.volume_up),
      ),
      ListTile(
        title: const Text('Langue'),
        subtitle: Text('Français (${user.preferences.language})'),
        leading: const Icon(Icons.language),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: controller.showLanguageDialog,
      ),
    ]);
  }

  Widget _buildSupportSection(ThemeData theme) {
    return _buildSection(theme, 'Support et Aide', [
      ListTile(
        title: const Text('Centre d\'aide'),
        subtitle: const Text('FAQ et guides d\'utilisation'),
        leading: const Icon(Icons.help),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => controller.openSupport('help'),
      ),
      ListTile(
        title: const Text('Nous contacter'),
        subtitle: Text(AppConstants.supportEmail),
        leading: const Icon(Icons.contact_support),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => controller.openSupport('contact'),
      ),
      ListTile(
        title: const Text('À propos'),
        subtitle: Text('${AppConstants.appName} ${AppConstants.appVersion}'),
        leading: const Icon(Icons.info),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: controller.showAboutDialog,
      ),
      ListTile(
        title: const Text('Déconnexion'),
        subtitle: const Text('Se déconnecter de l\'application'),
        leading: Icon(Icons.logout, color: theme.colorScheme.error),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: controller.showLogoutConfirmation,
      ),
    ]);
  }

  Widget _buildInfoTile(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label),
      subtitle: Text(value),
      trailing: onTap != null ? const Icon(Icons.edit, size: 20) : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
