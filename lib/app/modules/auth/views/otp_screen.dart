import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 48),
            _buildOtpInput(theme),
            const SizedBox(height: 32),
            _buildValidateButton(theme),
            const SizedBox(height: 24),
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lottie animation fallback
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(
            CupertinoIcons.lock_shield_fill,
            color: theme.colorScheme.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Vérification',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Entrez le code à 6 chiffres envoyé au ${controller.identifier}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(ThemeData theme) {
    return Column(
      children: [
        // This is the invisible text field that handles input
        SizedBox(
          height: 0,
          width: 0,
          child: TextFormField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            autofocus: true,
            onChanged: controller.onOtpChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        // This is the visible row of OTP boxes
        GestureDetector(
          onTap: () {
            // You might need to request focus here if it's lost
          },
          child: GetX<OtpController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final isFilled = controller.otpValue.value.length > index;
                  final isFocused =
                      controller.otpValue.value.length == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isFocused
                            ? theme.colorScheme.primary
                            : Colors.grey.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: isFilled
                        ? Text(
                            controller.otpValue.value[index],
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildValidateButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isValid.value ? controller.onValidateOtp : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            elevation: 5,
            shadowColor: theme.colorScheme.primary.withOpacity(0.3),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Valider le code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(CupertinoIcons.check_mark_circled, size: 22),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Center(
      child: Obx(
        () => TextButton(
          onPressed: controller.canResend.value ? controller.onResendOtp : null,
          child: controller.canResend.value
              ? const Text('Renvoyer le code')
              : Text('Renvoyer dans ${controller.resendSeconds.value}s'),
          style: TextButton.styleFrom(
            foregroundColor: controller.canResend.value
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
