import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/vibration_service.dart';
import '../../../widgets/custom_snackbar.dart';

class OtpController extends GetxController {
  String identifier = '';
  final otpController = TextEditingController();
  final otpValue = ''.obs;
  final RxString otpError = RxString('');
  final RxBool isValid = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  final RxInt resendSeconds = 30.obs;

  @override
  void onInit() {
    super.onInit();
    identifier = Get.arguments as String? ?? '';
    _startResendTimer();
  }

  void onOtpChanged(String value) {
    otpValue.value = value;
    if (value.length != 6) {
      otpError.value = 'Code incomplet';
      isValid.value = false;
      VibrationService.softVibrate();
    } else {
      otpError.value = '';
      isValid.value = true;
      VibrationService.softVibrate();
    }
  }

  void onValidateOtp() {
    isLoading.value = true;
    VibrationService.godlyVibrate();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      // Simulate: if OTP is 000000, treat as new user
      if (otpController.text == '000000') {
        CustomSnackbar.show(
          title: 'Succès',
          message: 'Inscription requise',
          success: true,
        );
        Get.toNamed('/register');
      } else {
        CustomSnackbar.show(
          title: 'Succès',
          message: 'Connexion réussie',
          success: true,
        );
        Get.offAllNamed('/home');
      }
    });
  }

  void onResendOtp() {
    canResend.value = false;
    resendSeconds.value = 30;
    _startResendTimer();
    VibrationService.softVibrate();
    CustomSnackbar.show(
      title: 'Code envoyé',
      message: 'Un nouveau code a été envoyé à votre numéro.',
      success: true,
    );
  }

  void _startResendTimer() {
    canResend.value = false;
    resendSeconds.value = 30;
    ever(resendSeconds, (int sec) {
      if (sec <= 0) {
        canResend.value = true;
      }
    });
    _tick();
  }

  void _tick() {
    if (resendSeconds.value > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        resendSeconds.value--;
        _tick();
      });
    }
  }

  void onHelp() {
    VibrationService.softVibrate();
    CustomSnackbar.show(
      title: 'Aide',
      message: 'Contactez le support si vous avez des problèmes de connexion.',
      success: true,
    );
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
