import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../services/storage_service.dart';
import '../../../services/tontine_service.dart';

class RemindersController extends GetxController {
  // Reactive state variables
  final RxList<Tontine> reminders = <Tontine>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt totalReminders = 0.obs;
  final RxDouble totalAmountDue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  @override
  void onReady() {
    super.onReady();
    // Auto-refresh reminders every 30 seconds when screen is active
    ever(reminders, (_) => _calculateTotals());
  }

  /// Load payment reminders for current user
  Future<void> loadReminders() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final currentUser = StorageService.getCurrentUser();
      if (currentUser?.id == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Get tontines with reminders (unpaid contributions)
      final reminderTontines = TontineService.getTontinesWithReminders(currentUser!.id!);

      reminders.assignAll(reminderTontines);
      _calculateTotals();

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate total reminders count and amount due
  void _calculateTotals() {
    totalReminders.value = reminders.length;

    double totalAmount = 0.0;
    for (final tontine in reminders) {
      // Only count active tontines for amount calculation
      if (tontine.status == TontineStatus.active) {
        totalAmount += tontine.contributionAmount;
      }
    }
    totalAmountDue.value = totalAmount;
  }

  /// Refresh reminders data
  Future<void> refresh() async {
    await loadReminders();
  }

  /// Get days until next payment for a tontine
  int getDaysUntilPayment(Tontine tontine) {
    if (tontine.nextContributionDate == null) return 0;

    final now = DateTime.now();
    final nextDate = tontine.nextContributionDate!;
    final difference = nextDate.difference(now).inDays;

    return difference;
  }

  /// Get priority level for a reminder based on days remaining
  ReminderPriority getPriority(Tontine tontine) {
    final daysUntil = getDaysUntilPayment(tontine);

    if (daysUntil < 0) return ReminderPriority.overdue;
    if (daysUntil == 0) return ReminderPriority.dueToday;
    if (daysUntil <= 2) return ReminderPriority.urgent;
    if (daysUntil <= 7) return ReminderPriority.upcoming;
    return ReminderPriority.future;
  }

  /// Get formatted time remaining string
  String getTimeRemainingText(Tontine tontine) {
    final daysUntil = getDaysUntilPayment(tontine);

    if (daysUntil < 0) {
      return 'En retard de ${daysUntil.abs()} jour${daysUntil.abs() > 1 ? 's' : ''}';
    } else if (daysUntil == 0) {
      return 'À payer aujourd\'hui';
    } else if (daysUntil == 1) {
      return 'À payer demain';
    } else {
      return 'Dans $daysUntil jours';
    }
  }

  /// Mark a contribution as paid (simulate payment)
  Future<void> markAsPaid(Tontine tontine) async {
    try {
      isLoading.value = true;

      // In a real app, this would process the payment
      // For demo, we'll just mark as paid in the service
      // await TontineService.markContributionPaid(contributionId, paymentReference);

      // Refresh the reminders list
      await loadReminders();

      // Show success message
      Get.snackbar(
        'Paiement effectué',
        'Votre contribution pour ${tontine.name} a été enregistrée',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer le paiement: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to tontine details
  void goToTontineDetails(Tontine tontine) {
    // In real app: Get.toNamed(Routes.TONTINE_DETAILS, arguments: tontine);
    Get.snackbar(
      'Navigation',
      'Ouverture des détails de ${tontine.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Get overdue reminders count
  int get overdueCount => reminders.where((t) => getPriority(t) == ReminderPriority.overdue).length;

  /// Get due today count
  int get dueTodayCount => reminders.where((t) => getPriority(t) == ReminderPriority.dueToday).length;

  /// Get urgent count (due in 1-2 days)
  int get urgentCount => reminders.where((t) => getPriority(t) == ReminderPriority.urgent).length;
}

/// Priority levels for reminders
enum ReminderPriority {
  overdue,
  dueToday,
  urgent,
  upcoming,
  future,
}