import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../services/tontine_service.dart';
import '../../../services/vibration_service.dart';
import '../../../widgets/custom_snackbar.dart';

class PotVisualController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Observables
  final Rx<Tontine?> tontine = Rx<Tontine?>(null);
  final RxBool isLoading = true.obs;
  final RxDouble progressPercentage = 0.0.obs;
  final RxDouble animatedProgress = 0.0.obs;
  final RxInt currentAmount = 0.obs;
  final RxInt targetAmount = 0.obs;
  final RxInt paidParticipants = 0.obs;
  final RxInt totalParticipants = 0.obs;
  final RxBool isAnimating = false.obs;

  // Animation controllers
  late AnimationController animationController;
  late Animation<double> fillAnimation;
  late Animation<double> shimmerAnimation;
  late Animation<double> coinAnimation;

  Timer? _progressTimer;
  int? tontineId;

  @override
  void onInit() {
    super.onInit();

    // Get tontine ID from arguments
    final args = Get.arguments;
    if (args is Map && args.containsKey('tontineId')) {
      tontineId = args['tontineId'] as int?;
    }

    _initializeAnimations();
    _loadTontineData();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Smooth fill animation
    fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Shimmer effect for coins/bills
    shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    // Coin drop animation
    coinAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );

    // Listen to animation progress
    fillAnimation.addListener(() {
      animatedProgress.value = fillAnimation.value * progressPercentage.value;
    });
  }

  void _loadTontineData() {
    isLoading.value = true;

    if (tontineId == null) {
      _showError('ID tontine manquant');
      return;
    }

    try {
      // Load tontine data
      final tontineData = TontineService.getTontine(tontineId!);
      if (tontineData == null) {
        _showError('Tontine non trouvée');
        return;
      }

      tontine.value = tontineData;

      // Calculate progress
      final contributions = TontineService.getTontineContributions(
        tontineId!,
        round: tontineData.currentRound,
      );

      final paid = contributions.where((c) => c.isPaid).length;
      final total = tontineData.participantIds.length;
      final collected = paid * tontineData.contributionAmount;

      // Update observables
      paidParticipants.value = paid;
      totalParticipants.value = total;
      currentAmount.value = collected.toInt();
      targetAmount.value = tontineData.totalPot.toInt();
      progressPercentage.value = total > 0
          ? collected / tontineData.totalPot
          : 0.0;

      // Start animation
      _startProgressAnimation();
    } catch (e) {
      _showError('Erreur lors du chargement: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _startProgressAnimation() {
    animationController.reset();
    isAnimating.value = true;

    animationController.forward().then((_) {
      isAnimating.value = false;
      _startCoinDropEffect();
    });
  }

  void _startCoinDropEffect() {
    if (progressPercentage.value > 0.5) {
      // Add coin drop effects for good progress
      VibrationService.softVibrate();
    }
  }

  // Simulate progress update (for demo purposes)
  void simulateContribution() {
    if (tontine.value == null) return;

    VibrationService.godlyVibrate();

    // Simulate adding a contribution
    final newPaid = math.min(
      paidParticipants.value + 1,
      totalParticipants.value,
    );
    if (tontine.value == null) return;
    final newAmount = newPaid * tontine.value!.contributionAmount;
    final newProgress = newAmount / targetAmount.value;

    paidParticipants.value = newPaid;
    currentAmount.value = newAmount.toInt();
    progressPercentage.value = newProgress;

    _startProgressAnimation();

    CustomSnackbar.show(
      title: 'Contribution ajoutée !',
      message: 'Progression mise à jour : ${(newProgress * 100).toInt()}%',
      success: true,
    );
  }

  // Refresh pot data
  void refreshPotData() {
    VibrationService.softVibrate();
    _loadTontineData();

    CustomSnackbar.show(
      title: 'Actualisation',
      message: 'Données mises à jour',
      success: true,
    );
  }

  // Get pot status based on progress
  String getPotStatus() {
    final progress = progressPercentage.value;
    if (progress >= 1.0) return 'Objectif atteint !';
    if (progress >= 0.75) return 'Presque terminé';
    if (progress >= 0.5) return 'Bonne progression';
    if (progress >= 0.25) return 'En cours';
    return 'Début de collecte';
  }

  // Get pot icon based on progress
  IconData getPotIcon() {
    final progress = progressPercentage.value;
    if (progress >= 1.0) return Icons.celebration;
    if (progress >= 0.75) return Icons.trending_up;
    if (progress >= 0.5) return Icons.savings;
    if (progress >= 0.25) return Icons.account_balance_wallet;
    return Icons.scatter_plot;
  }

  // Get motivational message
  String getMotivationalMessage() {
    final progress = progressPercentage.value;
    final remaining = totalParticipants.value - paidParticipants.value;

    if (progress >= 1.0) {
      return 'Félicitations ! La cagnotte est complète !';
    } else if (progress >= 0.75) {
      return 'Plus que $remaining contributions pour atteindre l\'objectif !';
    } else if (progress >= 0.5) {
      return 'Excellente progression ! Continuez ainsi !';
    } else if (progress >= 0.25) {
      return 'La collecte prend forme, encouragez vos amis !';
    } else {
      return 'Le début d\'une belle aventure financière !';
    }
  }

  void _showError(String message) {
    CustomSnackbar.show(title: 'Erreur', message: message, success: false);
  }

  @override
  void onClose() {
    animationController.dispose();
    _progressTimer?.cancel();
    super.onClose();
  }
}
