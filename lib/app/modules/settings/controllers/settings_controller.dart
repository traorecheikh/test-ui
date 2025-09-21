import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

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

  static const String _selectedLanguageKey = 'selectedLanguage';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
    _triggerAnimations();
  }

  Future<void> _loadLanguage() async {
    String langCode =
        await _secureStorage.read(key: _selectedLanguageKey) ??
        Get.locale?.languageCode ??
        'fr_FR';
    // Map short codes to full codes
    if (langCode == 'fr') langCode = 'fr_FR';
    if (langCode == 'en') langCode = 'en_US';
    if (langCode == 'wo') langCode = 'wo_SN';
    // Fallback if not valid
    const validCodes = ['fr_FR', 'en_US', 'wo_SN'];
    if (!validCodes.contains(langCode)) langCode = 'fr_FR';
    selectedLanguage.value = langCode;
    Get.updateLocale(_localeFromCode(langCode));
  }

  void changeLanguage(String code) async {
    selectedLanguage.value = code;
    await _secureStorage.write(key: _selectedLanguageKey, value: code);
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
