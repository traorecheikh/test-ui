import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:snt_ui_test/app/modules/settings/controllers/settings_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../auth/views/pin_setup_screen.dart';
// import 'package:snt_ui_test/app/theme.dart'; // Assuming AppPaddings, AppRadius etc. were intended to be here

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Obx(
          () => AnimatedOpacity(
            // Use one of the controller's flags for the root animation
            opacity: controller.showHeader.value
                ? 1.0
                : 0.0, // Or a dedicated 'showScreen' flag if preferred
            duration: const Duration(
              milliseconds: 300,
            ), // Short overall fade-in
            curve: Curves.easeIn,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  offset: controller.showHeader.value
                      ? Offset.zero
                      : const Offset(0, 0.2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () => Get.back(),
                          tooltip: 'Retour',
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Paramètres',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Security Section
                _buildSettingsSection(
                  theme,
                  controller,
                  showSection: controller.showToggles.value,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'Sécurité',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Obx(
                      () => _buildSecurityToggleItem(
                        theme,
                        Icons.pin_outlined,
                        'Code PIN',
                        'Sécurisez l\'accès avec un PIN à 4 chiffres',
                        authService.isPinEnabled,
                        (value) => _handlePinToggle(value, authService),
                      ),
                    ),
                    Obx(
                      () => authService.isBiometricAvailable.value
                          ? _buildBiometricToggleItem(theme, authService)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                _buildSettingsSection(
                  theme,
                  controller,
                  showSection: controller.showToggles.value,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'Préférences',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    _buildInfoItem(
                      theme,
                      Icons.person_outline,
                      'Compte utilisateur',
                      onTap: () => Get.toNamed(Routes.profile),
                    ),
                    _buildToggleItem(
                      theme,
                      Icons.brightness_6,
                      'Mode sombre',
                      controller.darkMode,
                      controller.toggleDarkMode,
                    ),
                    _buildToggleItem(
                      theme,
                      Icons.notifications_none,
                      'Notifications',
                      controller.notificationsEnabled,
                      controller.toggleNotifications,
                    ),
                    _buildToggleItem(
                      theme,
                      Icons.volume_up_outlined,
                      'Sons',
                      controller.soundEnabled,
                      controller.toggleSound,
                    ),
                  ],
                ),
                SizedBox(height: 32.h), // Changed from 24.h
                _buildSettingsSection(
                  theme,
                  controller,
                  showSection: controller.showInfo.value,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'Informations',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    _buildInfoItem(
                      theme,
                      Icons.info_outline,
                      'À propos de l\'application',
                      onTap: controller.openAboutDialog,
                    ),
                    _buildInfoItem(
                      theme,
                      Icons.privacy_tip_outlined,
                      'Confidentialité',
                      onTap: controller.openPrivacyPolicy,
                    ),
                    _buildInfoItem(
                      theme,
                      Icons.description_outlined,
                      'Conditions d\'utilisation',
                      onTap: controller.openTermsOfService,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Se déconnecter',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      onTap: controller.logout,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h, // Changed from 8.h
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      child: Obx(
                        () => Text(
                          'Version ${controller.appVersion.value}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
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
    );
  }

  Future<void> _handlePinToggle(bool value, AuthService authService) async {
    if (value) {
      // Navigate to PIN setup screen
      final result = await Get.to(() => const PinSetupScreen());
      if (result != true) {
        // If PIN setup was cancelled or failed, don't enable PIN
        return;
      }
    } else {
      // Show confirmation dialog before disabling PIN
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

  Widget _buildSecurityToggleItem(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
    RxBool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      value: value.value,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
      inactiveThumbColor: theme.colorScheme.onSurface.withOpacity(0.4),
      inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.1),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  Widget _buildBiometricToggleItem(ThemeData theme, AuthService authService) {
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
          subtitle = 'Utilisez Face ID pour vous authentifier';
        } else if (biometrics.contains(BiometricType.fingerprint)) {
          icon = Icons.fingerprint;
          title = 'Empreinte digitale';
          subtitle = 'Utilisez votre empreinte pour vous authentifier';
        }

        return _buildSecurityToggleItem(
          theme,
          icon,
          title,
          subtitle,
          authService.isBiometricEnabled,
          (value) async {
            if (value && !authService.isPinEnabled.value) {
              Get.snackbar(
                'PIN requis',
                'Vous devez d\'abord configurer un PIN avant d\'activer l\'authentification biométrique',
                backgroundColor: theme.colorScheme.error,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
              return;
            }
            await authService.toggleBiometricAuth(value);
          },
        );
      },
    );
  }

  Widget _buildSettingsSection(
    ThemeData theme,
    SettingsController controller, {
    required bool showSection,
    required List<Widget> children,
  }) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      offset: showSection ? Offset.zero : const Offset(0, 0.3),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        opacity: showSection ? 1.0 : 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h), // Added this padding
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: children, // Removed the map and divider logic
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    ThemeData theme,
    IconData icon,
    String title,
    RxBool value,
    ValueChanged<bool> onChanged,
  ) {
    // Removed showDivider parameter
    return Obx(
      () => SwitchListTile(
        secondary: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        value: value.value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
        inactiveThumbColor: theme.colorScheme.onSurface.withOpacity(0.4),
        inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ), // Changed from 8.h
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    IconData icon,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            )
          : null,
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          Icons.arrow_forward_ios,
          key: ValueKey(
            theme.iconTheme.color,
          ), // Ensures animation on theme change
          size: 16.sp,
          color: theme.iconTheme.color?.withOpacity(0.5),
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 20.h,
      ), // Changed from 12.h
    );
  }
}
