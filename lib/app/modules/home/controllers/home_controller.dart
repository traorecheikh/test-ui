import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/routes/app_pages.dart';

import '../../../data/models/tontine.dart';
import '../../../data/models/user.dart';
import '../../../services/storage_service.dart';
import '../../../services/tontine_service.dart';
import '../../../services/vibration_service.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/celebration_overlay.dart';
import '../../../widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  final RxList<Tontine> userTontines = <Tontine>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    isLoading.value = true;
    currentUser.value = StorageService.getCurrentUser();
    final previousCount = userTontines.length;
    if (currentUser.value != null) {
      userTontines.value = TontineService.getUserTontines(
        currentUser.value!.id,
      );
    } else {
      userTontines.clear();
    }
    isLoading.value = false;
    // Show celebration if first tontine created
    if (previousCount == 0 && userTontines.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final context = Get.context;
        if (context != null) {
          CelebrationOverlay.show(
            context,
            message: 'Bravo ! Première tontine créée 🎉',
          );
        }
      });
    }
  }

  String getTotalSavings() {
    double total = 0;
    for (final tontine in userTontines) {
      total += tontine.contributionAmount * tontine.participantIds.length;
    }
    return Formatters.formatCurrency(total);
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
        Get.toNamed(Routes.join);
      },
    ),
    _ActionButtonData(
      title: 'Historique',
      icon: Icons.history,
      color: Colors.purpleAccent,
      onTap: () {
        VibrationService.softVibrate();
        CustomSnackbar.show(
          title: 'Historique',
          message: 'Fonctionnalité à venir !',
          success: false,
        );
      },
    ),
    _ActionButtonData(
      title: 'Paramètres',
      icon: Icons.settings,
      color: Colors.redAccent,
      onTap: () {
        VibrationService.softVibrate();
        Get.toNamed(Routes.profile);
      },
    ),
    _ActionButtonData(
      title: 'Aide',
      icon: Icons.help_outline,
      color: Colors.tealAccent,
      onTap: () {
        VibrationService.softVibrate();
        CustomSnackbar.show(
          title: 'Aide',
          message: 'Contactez le support si besoin.',
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
