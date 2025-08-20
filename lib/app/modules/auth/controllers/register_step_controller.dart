import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/vibration_service.dart';
import '../../../widgets/custom_snackbar.dart';

class RegisterStepController extends GetxController {
  final RxInt currentStep = 0.obs;
  final int totalSteps = 3;

  // Step 1
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxString nameError = RxString('');
  final RxString emailError = RxString('');
  final RxString profilePicturePath = ''.obs;

  // Step 2
  final language = 'FR'.obs;
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  final countryController = TextEditingController();
  final RxString cityError = RxString('');
  final RxString regionError = RxString('');
  final RxString countryError = RxString('');

  // Step validation
  final RxBool isStepValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _validateStep();
    nameController.addListener(_validateStep);
    emailController.addListener(_validateStep);
    cityController.addListener(_validateStep);
    regionController.addListener(_validateStep);
    countryController.addListener(_validateStep);
  }

  void onNameChanged(String value) {
    if (value.trim().length < 3) {
      nameError.value = 'Nom trop court';
    } else {
      nameError.value = '';
    }
    _validateStep();
  }

  void onEmailChanged(String value) {
    if (value.isNotEmpty && !value.contains('@')) {
      emailError.value = 'Email invalide';
    } else {
      emailError.value = '';
    }
    _validateStep();
  }

  void onPickProfilePicture() {
    // Simulate picking a picture
    profilePicturePath.value = 'assets/profile_placeholder.png';
    _validateStep();
  }

  void onLanguageChanged(String? value) {
    if (value != null) language.value = value;
    _validateStep();
  }

  void onCityChanged(String value) {
    if (value.trim().isEmpty) {
      cityError.value = 'Champ requis';
    } else {
      cityError.value = '';
    }
    _validateStep();
  }

  void onRegionChanged(String value) {
    if (value.trim().isEmpty) {
      regionError.value = 'Champ requis';
    } else {
      regionError.value = '';
    }
    _validateStep();
  }

  void onCountryChanged(String value) {
    if (value.trim().isEmpty) {
      countryError.value = 'Champ requis';
    } else {
      countryError.value = '';
    }
    _validateStep();
  }

  void _validateStep() {
    switch (currentStep.value) {
      case 0:
        isStepValid.value =
            nameController.text.trim().length >= 3 && nameError.value.isEmpty;
        break;
      case 1:
        isStepValid.value =
            cityController.text.trim().isNotEmpty &&
            regionController.text.trim().isNotEmpty &&
            countryController.text.trim().isNotEmpty &&
            cityError.value.isEmpty &&
            regionError.value.isEmpty &&
            countryError.value.isEmpty;
        break;
      case 2:
        isStepValid.value = true;
        break;
      default:
        isStepValid.value = false;
    }
  }

  void onNext() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      VibrationService.softVibrate();
      _validateStep();
    } else {
      // Registration complete
      VibrationService.godlyVibrate();
      CustomSnackbar.show(
        title: 'Bienvenue',
        message: 'Inscription terminée avec succès !',
        success: true,
      );
      Get.offAllNamed('/home');
    }
  }

  void onBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
      VibrationService.softVibrate();
      _validateStep();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    regionController.dispose();
    countryController.dispose();
    super.onClose();
  }
}
