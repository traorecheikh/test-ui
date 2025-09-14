import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:snt_ui_test/app/modules/settings/controllers/settings_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../auth/views/pin_setup_screen.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: Obx(
        () => AnimatedOpacity(
          opacity: controller.showHeader.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              // Profile Section
              _buildProfileSection(theme),
              SizedBox(height: 32.h),

              // Settings Groups
              _buildSettingsGroup(
                theme,
                title: 'Préférences',
                children: [
                  _buildSettingItem(
                    theme,
                    Icons.dark_mode_outlined,
                    'Mode sombre',
                    trailing: Obx(
                      () => Switch(
                        value: controller.darkMode.value,
                        onChanged: controller.toggleDarkMode,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    theme,
                    Icons.notifications_outlined,
                    'Notifications',
                    trailing: Obx(
                      () => Switch(
                        value: controller.notificationsEnabled.value,
                        onChanged: controller.toggleNotifications,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    theme,
                    Icons.volume_up_outlined,
                    'Sons',
                    trailing: Obx(
                      () => Switch(
                        value: controller.soundEnabled.value,
                        onChanged: controller.toggleSound,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Security Section
              _buildSettingsGroup(
                theme,
                title: 'Sécurité',
                children: [
                  Obx(
                    () => _buildSettingItem(
                      theme,
                      Icons.pin_outlined,
                      'Code PIN',
                      subtitle: 'Protection par code à 4 chiffres',
                      trailing: Switch(
                        value: authService.isPinEnabled.value,
                        onChanged: (value) =>
                            _handlePinToggle(value, authService),
                      ),
                    ),
                  ),
                  Obx(
                    () => authService.isBiometricAvailable.value
                        ? _buildBiometricItem(theme, authService)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Info Section
              _buildSettingsGroup(
                theme,
                title: 'Informations',
                children: [
                  _buildSettingItem(
                    theme,
                    Icons.person_outline,
                    'Mon compte',
                    onTap: () => Get.toNamed(Routes.profile),
                  ),
                  _buildSettingItem(
                    theme,
                    Icons.info_outline,
                    'À propos',
                    onTap: controller.openAboutDialog,
                  ),
                  _buildSettingItem(
                    theme,
                    Icons.privacy_tip_outlined,
                    'Confidentialité',
                    onTap: controller.openPrivacyPolicy,
                  ),
                  _buildSettingItem(
                    theme,
                    Icons.description_outlined,
                    'Conditions d\'utilisation',
                    onTap: controller.openTermsOfService,
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Logout Button
              _buildLogoutButton(theme),

              SizedBox(height: 24.h),

              // Version Info
              _buildVersionInfo(theme),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Paramètres',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 30.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mon Compte',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Gérez vos informations',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(
    ThemeData theme, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(children: children.map((child) => child).toList()),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    ThemeData theme,
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 16.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricItem(ThemeData theme, AuthService authService) {
    return FutureBuilder<List<BiometricType>>(
      future: authService.getAvailableBiometrics(),
      builder: (context, snapshot) {
        final biometrics = snapshot.data ?? [];
        IconData icon = Icons.fingerprint;
        String title = 'Biométrie';
        String subtitle = 'Authentification biométrique';

        if (biometrics.contains(BiometricType.face)) {
          icon = Icons.face;
          title = 'Face ID';
          subtitle = 'Authentification par reconnaissance faciale';
        } else if (biometrics.contains(BiometricType.fingerprint)) {
          icon = Icons.fingerprint;
          title = 'Empreinte digitale';
          subtitle = 'Authentification par empreinte';
        }

        return _buildSettingItem(
          theme,
          icon,
          title,
          subtitle: subtitle,
          trailing: Obx(
            () => Switch(
              value: authService.isBiometricEnabled.value,
              onChanged: (value) async {
                if (value && !authService.isPinEnabled.value) {
                  Get.snackbar(
                    'PIN requis',
                    'Configurez d\'abord un PIN',
                    backgroundColor: theme.colorScheme.error,
                    colorText: Colors.white,
                  );
                  return;
                }
                await authService.toggleBiometricAuth(value);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.logout,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: theme.colorScheme.error, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Se déconnecter',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(ThemeData theme) {
    return Center(
      child: Obx(
        () => Text(
          'Version ${controller.appVersion.value}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePinToggle(bool value, AuthService authService) async {
    if (value) {
      final result = await Get.to(() => const PinSetupScreen());
      if (result != true) {
        return;
      }
    } else {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Désactiver le PIN'),
          content: const Text(
            'Êtes-vous sûr de vouloir désactiver la protection par PIN ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Désactiver'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await authService.togglePinAuth(false);
      }
    }
  }
}
