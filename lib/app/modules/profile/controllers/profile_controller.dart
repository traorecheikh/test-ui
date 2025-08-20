import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user.dart';
import '../../../services/storage_service.dart';
import '../../../utils/constants.dart';

class ProfileController extends GetxController {
  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    isLoading.value = true;
    currentUser.value = StorageService.getCurrentUser();
    isLoading.value = false;
  }

  void editProfile() {
    // Show edit profile dialog (stub)
    Get.snackbar(
      'Bientôt',
      'La modification du profil sera disponible dans une prochaine version.',
    );
  }

  void updatePreference(String key, dynamic value) {
    final user = currentUser.value;
    if (user == null) return;
    // Update preferences locally (simulate)
    switch (key) {
      case 'darkMode':
        user.preferences.darkMode = value;
        break;
      case 'notifications':
        user.preferences.notificationsEnabled = value;
        break;
      case 'sound':
        user.preferences.soundEnabled = value;
        break;
    }
    StorageService.saveUser(user);
    currentUser.refresh();
    Get.snackbar('Préférences', 'Préférences mises à jour');
  }

  void showLanguageDialog() {
    final user = currentUser.value;
    if (user == null) return;
    Get.dialog(
      AlertDialog(
        title: const Text('Choisir la Langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: user.preferences.language,
              onChanged: (value) {
                user.preferences.language = value!;
                StorageService.saveUser(user);
                currentUser.refresh();
                Get.back();
                Get.snackbar('Langue', 'Langue mise à jour');
              },
            ),
            RadioListTile<String>(
              title: const Text('Wolof'),
              subtitle: const Text('Bientôt disponible'),
              value: 'wo',
              groupValue: user.preferences.language,
              onChanged: null,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void openSupport(String type) {
    Get.dialog(
      AlertDialog(
        title: Text(type == 'help' ? 'Centre d\'Aide' : 'Nous Contacter'),
        content: Text(
          type == 'help'
              ? 'Le centre d\'aide complet sera disponible dans une prochaine version.'
              : 'Contactez-nous à ${AppConstants.supportEmail} ou au ${AppConstants.supportPhone}',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void showAboutDialog() {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) => AlertDialog(
        title: const Text('À propos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${AppConstants.appName} ${AppConstants.appVersion}'),
            const SizedBox(height: 16),
            Text(AppConstants.appDescription),
            const SizedBox(height: 16),
            const Text(
              'Développé avec ❤️ pour la communauté sénégalaise\n\n'
              'Équipe fondatrice:\n'
              '• Cheikh Tidiane - CEO/Tech\n'
              '• Houleymatou - CTO/Design\n'
              '• Bon Rosinard - Backend\n'
              '• Jean Yves - Full Stack',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ? '
          'Vos données locales seront conservées.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
              Get.snackbar('Déconnexion', 'Vous avez été déconnecté');
            },
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.error,
            ),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }
}
