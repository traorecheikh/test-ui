import 'package:get/get.dart';

class SettingsController extends GetxController {
  final darkMode = false.obs;
  final notificationsEnabled = true.obs;
  final soundEnabled = true.obs;

  void toggleDarkMode(bool value) => darkMode.value = value;
  void toggleNotifications(bool value) => notificationsEnabled.value = value;
  void toggleSound(bool value) => soundEnabled.value = value;

  void showLanguageDialog() {
    // TODO: Implement language selection dialog
  }
}
