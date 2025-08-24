import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTontineController extends GetxController {
  // PageView controller
  late final PageController pageController;

  // Stepper state
  final currentStep = 0.obs;

  int get stepCount => 5; // We have 5 steps now
  bool get isLastStep => currentStep.value == stepCount - 1;

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final maxParticipantsController = TextEditingController();
  final maxHandsController = TextEditingController();
  final organizerHandsController = TextEditingController();
  final gracePeriodController = TextEditingController();
  final penaltyRateController = TextEditingController();
  final maxPenaltyController = TextEditingController();

  // Dropdowns & switches
  final selectedFrequency = Rxn<String>();
  final selectedCurrency = Rxn<String>();
  final organizerParticipates = false.obs;
  final penaltiesEnabled = false.obs;

  // Options (should be loaded from config/service in real app)
  final frequencyOptions = [
    const DropdownMenuItem(value: 'MONTHLY', child: Text('Mensuel')),
    const DropdownMenuItem(value: 'WEEKLY', child: Text('Hebdomadaire')),
    const DropdownMenuItem(value: 'DAILY', child: Text('Quotidien')),
  ];
  final currencyOptions = [
    const DropdownMenuItem(value: 'XOF', child: Text('XOF (Franc CFA)')),
    const DropdownMenuItem(value: 'USD', child: Text('USD (US Dollar)')),
    const DropdownMenuItem(value: 'EUR', child: Text('EUR (Euro)')),
  ];

  // Validation
  String? nameValidator(String? value) =>
      (value == null || value.isEmpty) ? 'Le nom est requis' : null;

  String? descriptionValidator(String? value) =>
      (value == null || value.isEmpty) ? 'La description est requise' : null;

  String? amountValidator(String? value) =>
      (value == null || double.tryParse(value) == null)
      ? 'Un montant valide est requis'
      : null;

  String? maxParticipantsValidator(String? value) =>
      (value == null || int.tryParse(value) == null)
      ? 'Un nombre valide est requis'
      : null;

  String? maxHandsValidator(String? value) =>
      (value == null || int.tryParse(value) == null)
      ? 'Un nombre valide est requis'
      : null;

  String? organizerHandsValidator(String? value) =>
      (value == null || int.tryParse(value) == null)
      ? 'Un nombre valide est requis'
      : null;

  String? gracePeriodValidator(String? value) =>
      (value == null || int.tryParse(value) == null)
      ? 'Un nombre valide est requis'
      : null;

  String? penaltyRateValidator(String? value) =>
      (value == null || double.tryParse(value) == null)
      ? 'Un taux valide est requis'
      : null;

  String? maxPenaltyValidator(String? value) =>
      (value == null || double.tryParse(value) == null)
      ? 'Un taux valide est requis'
      : null;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    // Set default values for dropdowns
    selectedCurrency.value = 'XOF';
    selectedFrequency.value = 'MONTHLY';
  }

  /// Page navigation
  void nextStep() {
    if (isLastStep) {
      submitTontine();
    } else {
      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Submits the tontine creation request.
  void submitTontine() {
    // TODO: Implement API call and error handling
    // Validate all fields before submission
    // Show loading indicator, handle success/error, navigate on success
    Get.dialog(
      AlertDialog(
        title: const Text('Tontine Créée'),
        content: const Text('La logique de soumission est à implémenter.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    maxParticipantsController.dispose();
    maxHandsController.dispose();
    organizerHandsController.dispose();
    gracePeriodController.dispose();
    penaltyRateController.dispose();
    maxPenaltyController.dispose();
    super.onClose();
  }
}
