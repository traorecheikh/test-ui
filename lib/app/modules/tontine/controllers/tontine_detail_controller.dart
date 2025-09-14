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

class TontineDetailController extends GetxController {
  final Rx<Tontine?> tontine = Rx<Tontine?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isOrganizer = false.obs;

  // Animation flags
  final showSummary = false.obs;
  final showStatus = false.obs;
  final showParticipants = false.obs;
  final showActions = false.obs;

  List<Contribution> currentRoundContributions = [];

  int get currentUserId => 1;

  Contribution? get myContribution {
    return currentRoundContributions.firstWhereOrNull(
      (c) => c.participantId == currentUserId,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadTontineData();
  }

  void _triggerAnimations() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => showSummary.value = true,
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () => showStatus.value = true,
    );
    Future.delayed(
      const Duration(milliseconds: 300),
      () => showParticipants.value = true,
    );
    Future.delayed(
      const Duration(milliseconds: 400),
      () => showActions.value = true,
    );
  }

  void _loadTontineData() {
    isLoading.value = true;
    final tontineId = Get.arguments as int?;
    if (tontineId == null) {
      tontine.value = null;
      isLoading.value = false;
      return;
    }

    final t = TontineService.getTontine(tontineId);
    tontine.value = t;

    if (t != null) {
      isOrganizer.value = t.organizerId == currentUserId;
      if (t.id != null) {
        currentRoundContributions = TontineService.getTontineContributions(
          t.id!,
          round: t.currentRound,
        );
      }
    }

    isLoading.value = false;
    _triggerAnimations();
  }

  List<Contribution> getRoundContributions(int round) {
    final t = tontine.value;
    if (t == null || t.id == null) return [];
    return TontineService.getTontineContributions(t.id!, round: round);
  }

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
            const Text('Partagez ce code ou le QR pour inviter des membres.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void showOptionsMenu() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.share,
                    title: 'Partager',
                    onTap: () {
                      Get.back();
                      VibrationService.softVibrate();
                      showShareDialog();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildOptionTile(
                    icon: Icons.history,
                    title: 'Voir l\'historique',
                    onTap: () {
                      Get.back();
                      showTransactionHistory();
                    },
                  ),
                  if (isOrganizer.value) ...[
                    const SizedBox(height: 16),
                    _buildOptionTile(
                      icon: Icons.settings,
                      title: 'Gérer la tontine',
                      onTap: () {
                        Get.back();
                        // TODO: Navigate to tontine management screen
                        CustomSnackbar.show(
                          title: 'Info',
                          message: 'Écran de gestion à venir.',
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildOptionTile(
                    icon: Icons.exit_to_app,
                    title: 'Quitter la tontine',
                    isDestructive: true,
                    onTap: () {
                      Get.back();
                      showLeaveConfirmation();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Get.theme;
    final color = isDestructive ? Colors.red : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void showLeaveConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Quitter la Tontine'),
        content: const Text(
          'Êtes-vous sûr de vouloir quitter cette tontine ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Go back from detail screen
              CustomSnackbar.show(
                title: 'Succès',
                message: 'Vous avez quitté la tontine.',
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

  void showTransactionHistory() {
    VibrationService.softVibrate();
    // In a real app, you would navigate to a dedicated transaction history screen
    Get.dialog(
      AlertDialog(
        title: const Text('Historique des Transactions'),
        content: const Text('L\'historique des transactions sera affiché ici.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

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
    Get.back(); // Close payment options
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
      Get.back(); // Close progress indicator
      CustomSnackbar.show(
        title: 'Succès',
        message: 'Paiement effectué avec succès!',
        success: true,
      );
      _loadTontineData(); // Refresh data
    });
  }

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
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
          TextButton(
            onPressed: () {
              // In a real app, you would use a share plugin
              Get.snackbar('Copié', 'Code copié dans le presse-papiers');
            },
            child: const Text('Copier le Code'),
          ),
        ],
      ),
    );
  }

  Future<void> refreshTontineData() async {
    VibrationService.softVibrate();
    _loadTontineData();
    CustomSnackbar.show(
      title: 'Actualisé',
      message: 'Les données de la tontine ont été mises à jour.',
      success: false,
    );
  }

  void showPotDetails() {
    final t = tontine.value;
    if (t == null) return;

    VibrationService.softVibrate();

    final currentAmount = t.currentRound * t.contributionAmount;
    final targetAmount = t.totalPot;
    final progress = (currentAmount / targetAmount * 100).toInt();
    final paidCount = currentRoundContributions.where((c) => c.isPaid).length;
    final pendingCount = t.participantIds.length - paidCount;

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.savings, color: Get.theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(child: Text('Détails du Pot')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              'Cagnotte Actuelle',
              Formatters.formatCurrency(currentAmount.toDouble()),
            ),
            _buildDetailRow(
              'Objectif Total',
              Formatters.formatCurrency(targetAmount),
            ),
            _buildDetailRow('Progression', '$progress%'),
            const Divider(),
            _buildDetailRow(
              'Tour Actuel',
              '${t.currentRound} / ${t.totalRounds}',
            ),
            _buildDetailRow(
              'Paiements Effectués',
              '$paidCount / ${t.participantIds.length}',
            ),
            if (pendingCount > 0)
              _buildDetailRow(
                'En Attente',
                '$pendingCount participant${pendingCount > 1 ? 's' : ''}',
              ),
            const Divider(),
            _buildDetailRow('Prochain Tirage', t.formattedNextPaymentDate),
            _buildDetailRow('Fréquence', t.frequency.label),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
