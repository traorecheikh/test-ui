import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/vibration_service.dart';
import '../../../widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final RxString phoneError = RxString('');
  final RxBool isValid = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Country> selectedCountry = Country.parse("SN").obs;

  final RxList<Country> countries = <Country>[
    Country.parse('SN'), // Senegal
    Country.parse('CI'), // Côte d'Ivoire
    Country.parse('ML'), // Mali
    Country.parse('BF'), // Burkina Faso
    Country.parse('TG'), // Togo
    Country.parse('BJ'), // Benin
    Country.parse('NE'), // Niger
    Country.parse('GW'), // Guinea-Bissau
  ].obs;

  void onCountrySelected(Country country) {
    selectedCountry.value = country;
    VibrationService.softVibrate();
    // Re-validate phone
    onPhoneChanged(phoneController.text);
  }

  void onPhoneChanged(String value) {
    // Validate: must be digits, at least 6 digits, no leading zero
    final phone = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.length < 6) {
      phoneError.value = 'phone_error_short'.tr;
      isValid.value = false;
      VibrationService.softVibrate();
    } else {
      phoneError.value = '';
      isValid.value = true;
      VibrationService.softVibrate();
    }
  }

  void onRequestOtp() {
    isLoading.value = true;
    VibrationService.godlyVibrate();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      final fullPhone =
          '+${selectedCountry.value.phoneCode}${phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')}';
      Get.toNamed('/otp', arguments: fullPhone);
    });
  }

  void onHelp() {
    VibrationService.softVibrate();
    CustomSnackbar.show(
      title: 'help_title'.tr,
      message: 'help_message'.tr,
      success: true,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
