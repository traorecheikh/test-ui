import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/models/contribution.dart';
import '../../../data/models/tontine.dart';
import '../../../services/tontine_service.dart';
import '../../../services/vibration_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/custom_snackbar.dart';

class TontineDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<Tontine?> tontine = Rx<Tontine?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isOrganizer = false.obs;
  late TabController tabController;
  List<Contribution> currentRoundContributions = [];
  
  // Current user ID (in a real app, this would come from a storage service)
  int get currentUserId => 1;

  // Initialization
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    _loadTontineData();
  }

  void _loadTontineData() {
    isLoading.value = true;
    // In a real app, tontineId would come from arguments
    final tontineId = Get.arguments as int?;
    if (tontineId == null) {
      tontine.value = null;
      isLoading.value = false;
      return;
    }
    final t = TontineService.getTontine(tontineId);
    tontine.value = t;
    if (t != null) {
      // Organizer check (replace with real user check)
      isOrganizer.value = t.organizerId == currentUserId;
      if (t.id != null) {
        currentRoundContributions = TontineService.getTontineContributions(
          t.id!,
          round: t.currentRound,
        );
      }
    }
    isLoading.value = false;
  }

  /// Returns the list of contributions for a given round.
  List<Contribution> getRoundContributions(int round) {
    final t = tontine.value;
    if (t == null) return [];
    if (t.id != null) {
      return TontineService.getTontineContributions(t.id!, round: round);
    }
    return [];
  }

  // Floating action button builder
  Widget? buildFloatingActionButton(ThemeData theme) {
    // Example: Only show for organizer
    if (!isOrganizer.value) return null;
    return FloatingActionButton(
      onPressed: showInviteDialog,
      backgroundColor: theme.colorScheme.primary,
      child: const Icon(Icons.person_add),
      tooltip: 'Inviter',
    );
  }

  // Show invite dialog
  void showInviteDialog() {
    final t = tontine.value;
    if (t == null) return;
    VibrationService.softVibrate();
    Get.dialog(
      AlertDialog(
        title: const Text('Inviter des membres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: t.inviteCode,
              version: QrVersions.auto,
              size: 120,
            ),
            const SizedBox(height: 12),
            Text(
              'Code d\'invitation: ${t.inviteCode}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Partagez ce code ou le QR pour inviter des membres.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  // Show options menu
  void showOptionsMenu() {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager'),
            onTap: () {
              Get.back();
              VibrationService.softVibrate();
              showInviteDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Informations'),
            onTap: () {
              Get.back();
              tabController.animateTo(3);
            },
          ),
          if (isOrganizer.value)
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Gérer'),
              onTap: () {
                Get.back();
                // Organizer settings
              },
            ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Fermer'),
            onTap: () => Get.back(),
          ),
        ],
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  // Show leave confirmation
  void showLeaveConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Quitter la Tontine'),
        content: const Text(
          'Êtes-vous sûr de vouloir quitter cette tontine ? '
          'Cette action est irréversible et vous perdrez votre place.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              CustomSnackbar.show(
                title: 'Succès',
                message: 'Vous avez quitté la tontine',
                success: true,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.error,
            ),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }

  // Show transaction history
  void showTransactionHistory() {
    VibrationService.softVibrate();
    Get.toNamed('/transaction-history', arguments: tontine.value?.id);
  }

  // Show payment dialog
  void showPaymentDialog() {
    final t = tontine.value;
    if (t == null) return;
    Get.dialog(
      AlertDialog(
        title: const Text('Payer Ma Contribution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Montant: ${Formatters.formatCurrency(t.contributionAmount)}'),
            const SizedBox(height: 8),
            Text(
              'Destinataire: Organisateur (${AppConstants.sampleParticipantNames[0]})',
            ),
            const SizedBox(height: 8),
            Text('Référence: #TONTINE-${t.inviteCode}-T${t.currentRound}'),
            const SizedBox(height: 16),
            const Text('Choisissez votre méthode de paiement:'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPaymentOption('Wave', Colors.blue),
                _buildPaymentOption('Orange', Colors.orange),
                _buildPaymentOption('Free', Colors.red),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String name, Color color) {
    return GestureDetector(
      onTap: () => processPayment(name),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.payment, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void processPayment(String method) {
    VibrationService.godlyVibrate();
    Get.back();
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Traitement du paiement via $method...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      CustomSnackbar.show(
        title: 'Succès',
        message: 'Paiement effectué avec succès!',
        success: true,
      );
      _loadTontineData();
    });
  }

  // Show share dialog
  void showShareDialog() {
    final t = tontine.value;
    if (t == null) return;
    
    Get.dialog(
      AlertDialog(
        title: Text('Partager ${t.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code d\'invitation: ${t.inviteCode}'),
            const SizedBox(height: 16),
            Center(
              child: QrImageView(
                data: t.inviteCode,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Partagez ce code ou le QR avec vos proches!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), 
            child: const Text('Fermer')
          ),
          TextButton(
            onPressed: () {
              // Copy to clipboard functionality
              Get.snackbar('Copié', 'Code copié dans le presse-papiers');
            },
            child: const Text('Copier le Code'),
          ),
        ],
      ),
    );
  }

  // Refresh tontine data
  Future<void> refreshTontineData() async {
    VibrationService.softVibrate();
    _loadTontineData();
    Get.snackbar(
      'Actualisé',
      'Les données ont été mises à jour',
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
