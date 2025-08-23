import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/routes/app_pages.dart';

import '../../../data/models/tontine.dart';
import '../../../data/models/user.dart';
import '../../../services/storage_service.dart';
import '../../../services/tontine_service.dart';
import '../../../services/vibration_service.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  final RxList<Tontine> userTontines = <Tontine>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool showCelebration = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = AppUser(
      id: '0',
      name: "cheikh",
      phone: "781706184",
      createdAt: DateTime.parse('2025-10-02'),
      preferences: UserPreferences(
        darkMode: false,
        language: 'fr',
        soundEnabled: true,
        notificationsEnabled: true,
        currencyFormat: 'FCFA',
      ),
    );

    _initializeAndLoadData();
  }

  void _initializeAndLoadData() async {
    // Initialiser StorageService et sauvegarder l'utilisateur
    await StorageService.init();
    await StorageService.saveUser(currentUser.value!);

    _loadData();
  }

  void _loadData() async {
    isLoading.value = true;
    // S'assurer que le TontineService est initialisé
    await TontineService.init();

    currentUser.value = StorageService.getCurrentUser();
    print('DEBUG: Current user from storage: ${currentUser.value?.id}');

    final previousCount = userTontines.length;
    if (currentUser.value != null) {
      userTontines.value = TontineService.getUserTontines(
        currentUser.value!.id,
      );
      print(
        'DEBUG: Found ${userTontines.length} tontines for user ${currentUser.value!.id}',
      );
    } else {
      userTontines.clear();
      print('DEBUG: No current user found');
    }
    isLoading.value = false;
    if (previousCount == 0 && userTontines.isNotEmpty) {
      showCelebration.value = true;
    }
    currentUser.value = AppUser(
      id: '0',
      name: "cheikh",
      phone: "781706184",
      createdAt: DateTime.parse('2025-10-02'),
      preferences: UserPreferences(
        darkMode: false,
        language: 'fr',
        soundEnabled: true,
        notificationsEnabled: true,
        currencyFormat: 'FCFA',
      ),
    );
  }

  String getTotalSavings() {
    currentUser.value = AppUser(
      id: '0',
      name: "cheikh",
      phone: "781706184",
      createdAt: DateTime.parse('2025-10-02'),
      preferences: UserPreferences(
        darkMode: false,
        language: 'fr',
        soundEnabled: true,
        notificationsEnabled: true,
        currencyFormat: 'FCFA',
      ),
    );

    double total = 0;
    for (final tontine in userTontines) {
      total += tontine.contributionAmount * tontine.participantIds.length;
    }
    return Formatters.formatCurrency(total);
  }

  // Méthode pour recharger les données manuellement
  void refreshTontines() {
    _loadData();
  }

  List<dynamic> get quickActions => [
    _ActionButtonData(
      title: 'Créer',
      icon: Icons.add_circle,
      color: Colors.greenAccent,
      onTap: () {
        VibrationService.godlyVibrate();
        Get.toNamed(Routes.create);
      },
    ),
    _ActionButtonData(
      title: 'Rejoindre',
      icon: Icons.group_add,
      color: Colors.blueAccent,
      onTap: () {
        VibrationService.godlyVibrate();
        Get.toNamed(Routes.joinScanner);
        print('Rejoindre Tontine');
      },
    ),
    _ActionButtonData(
      title: 'Mes Tontines',
      icon: Icons.group_add,
      color: Colors.indigo,
      onTap: () {
        VibrationService.godlyVibrate();
        Get.toNamed(Routes.myTontine);
      },
    ),
    _ActionButtonData(
      title: 'Historique',
      icon: Icons.history,
      color: Color(0xFFFFC107),
      onTap: () {
        VibrationService.softVibrate();
        Get.toNamed(Routes.history);
      },
    ),
    _ActionButtonData(
      title: 'Sunu Points',
      icon: Icons.stars,
      color: Color(0xFFFF9800),
      onTap: () {
        VibrationService.softVibrate();
        CustomSnackbar.show(
          title: 'Sunu Points',
          message: 'Fonctionnalité à venir !',
          success: true,
        );
      },
    ),
    _ActionButtonData(
      title: 'Rapports',
      icon: Icons.trending_up,
      color: Colors.purple,
      onTap: () {
        VibrationService.softVibrate();
        CustomSnackbar.show(
          title: 'Rapports',
          message: 'Fonctionnalité à venir !',
          success: true,
        );
      },
    ),
  ];
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
