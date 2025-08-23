import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../services/storage_service.dart';
import '../../../services/tontine_service.dart';

class JoinTontineController extends GetxController {
  final codeController = TextEditingController();

  final Rx<Tontine?> foundTontine = Rx<Tontine?>(null);
  final RxString? searchError = RxString('');
  final RxBool isSearching = false.obs;
  final RxBool isJoining = false.obs;

  // Search for a tontine by invite code
  Future<void> searchTontine(String code) async {
    isSearching.value = true;
    searchError?.value = '';
    foundTontine.value = null;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final tontine = TontineService.getTontineByInviteCode(code);
      foundTontine.value = tontine;
      isSearching.value = false;
      if (tontine == null) {
        searchError?.value = 'Aucune tontine trouvée avec ce code';
      } else if (tontine.participantIds.length >= tontine.maxParticipants) {
        searchError?.value = 'Cette tontine est complète';
      } else if (tontine.status != TontineStatus.pending &&
          tontine.status != TontineStatus.active) {
        searchError?.value =
            'Cette tontine n\'accepte plus de nouveaux membres';
      }
    } catch (e) {
      isSearching.value = false;
      searchError?.value = 'Erreur lors de la recherche';
    }
  }

  void clearSearch() {
    foundTontine.value = null;
    searchError?.value = '';
    isSearching.value = false;
  }

  // Show QR scanner (stub for now)
  void showQRScanner() {
    // This would trigger a QR scanner in a real app
    // For now, just show a dialog or snackbar
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_scanner, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Scanner QR Code',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cette fonctionnalité sera disponible dans une prochaine version',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  // Join the found tontine
  Future<void> joinTontine() async {
    final tontine = foundTontine.value;
    if (tontine == null) return;
    final currentUser = StorageService.getCurrentUser();
    if (currentUser == null) {
      Get.snackbar(
        'Erreur',
        'Utilisateur non connecté',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }
    isJoining.value = true;
    try {
      if (tontine.id == null || currentUser.id == null) {
        Get.snackbar(
          'Erreur',
          'Données manquantes pour rejoindre la tontine',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }
      final success = await TontineService.joinTontine(
        tontine.id!,
        currentUser.id!,
      );
      if (success) {
        Get.snackbar(
          'Succès',
          'Vous avez rejoint la tontine avec succès!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(result: tontine.id);
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de rejoindre la tontine',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isJoining.value = false;
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
