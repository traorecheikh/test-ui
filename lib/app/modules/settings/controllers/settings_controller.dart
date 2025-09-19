import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Observables for settings values
  final darkMode = false.obs;
  final notificationsEnabled = true.obs;
  final soundEnabled = true.obs;
  final appVersion = '1.0.0'.obs; // Added appVersion

  // Observables for animation states
  final showHeader = false.obs;
  final showToggles = false.obs;
  final showInfo = false.obs;

  final selectedLanguage = ''.obs;

  // final showAnimations = false.obs; // This will be handled by showHeader or a new composite if needed

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
    _triggerAnimations();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode =
        prefs.getString('selectedLanguage') ??
        Get.locale?.languageCode ??
        'fr_FR';
    selectedLanguage.value = langCode;
    Get.updateLocale(_localeFromCode(langCode));
  }

  void changeLanguage(String code) async {
    selectedLanguage.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', code);
    Get.updateLocale(_localeFromCode(code));
  }

  Locale _localeFromCode(String code) {
    switch (code) {
      case 'en_US':
        return const Locale('en', 'US');
      case 'fr_FR':
        return const Locale('fr', 'FR');
      case 'wo_SN':
        return const Locale('wo', 'SN');
      default:
        return const Locale('fr', 'FR');
    }
  }

  void _triggerAnimations() async {
    // Overall animation trigger (can be used for the root AnimatedOpacity in the view)
    // await Future.delayed(const Duration(milliseconds: 50));
    // showAnimations.value = true; // If we want a separate root animation flag

    // Staggered animation triggers for sections
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Initial delay before any animation
    showHeader.value = true;
    await Future.delayed(const Duration(milliseconds: 150)); // Stagger delay
    showToggles.value = true;
    await Future.delayed(const Duration(milliseconds: 150)); // Stagger delay
    showInfo.value = true;
  }

  // Methods to toggle settings
  void toggleDarkMode(bool value) => darkMode.value = value;

  void toggleNotifications(bool value) => notificationsEnabled.value = value;

  void toggleSound(bool value) => soundEnabled.value = value;

  // Placeholder methods for actions - Implement their logic
  void openAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('À propos de l\'application'),
        content: Text(
          'Version ${appVersion.value}\n\nCette application est formidable !',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void openPrivacyPolicy() {
    // TODO: Implement navigation to privacy policy screen or show a dialog
    Get.snackbar('Confidentialité', 'Politique de confidentialité à venir.');
  }

  void openTermsOfService() {
    // TODO: Implement navigation to terms of service screen or show a dialog
    Get.snackbar(
      'Conditions d\'utilisation',
      'Conditions d\'utilisation à venir.',
    );
  }

  Future<void> logout() async {
    // TODO: Implement logout logic (e.g., clear user session, navigate to login)
    // await FlutterSecureStorage().deleteAll();
    Get.offAllNamed('/login');
  }

  void showLanguageDialog() {
    // TODO: Implement language selection dialog
    Get.snackbar('Langue', 'Sélection de la langue à venir.');
  }

  // Method to change app locale
  void changeLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  ThemeMode get themeMode => darkMode.value ? ThemeMode.dark : ThemeMode.light;
}
