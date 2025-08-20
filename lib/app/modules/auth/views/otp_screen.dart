import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Lottie.asset(
                  //     'assets/lottie/otp.json',
                  //     width: 120,
                  //     height: 120,
                  //     repeat: true,
                  //   ).animate().fadeIn(duration: 600.ms),
                  // ),
                  const SizedBox(height: 12),
                  Text(
                    'Vérification',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 32,
                    ),
                  ).animate().slideY(begin: -0.3, duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Entrez le code reçu par SMS',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  const SizedBox(height: 32),
                  // Segmented OTP input
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        final text = (controller.otpController.text.length > i)
                            ? controller.otpController.text[i]
                            : '';
                        final isActive =
                            controller.otpController.text.length == i;
                        return AnimatedContainer(
                          duration: 200.ms,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 44,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primary.withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : Colors.grey.shade300,
                              width: isActive ? 2.5 : 1.2,
                            ),
                            boxShadow: [
                              if (isActive)
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.12,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Hidden OTP input field for focus
                  SizedBox(
                    height: 0,
                    width: 0,
                    child: TextFormField(
                      controller: controller.otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      autofocus: true,
                      onChanged: controller.onOtpChanged,
                      style: const TextStyle(fontSize: 1),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Progress indicator
                  Obx(
                    () => LinearProgressIndicator(
                      value: controller.otpController.text.length / 6.0,
                      backgroundColor: Colors.white,
                      color: theme.colorScheme.primary,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () =>
                          ElevatedButton(
                            onPressed: controller.isValid.value
                                ? controller.onValidateOtp
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 2,
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Valider'),
                          ).animate().scaleXY(
                            begin: 0.95,
                            end: 1.0,
                            duration: 200.ms,
                          ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Obx(
                      () => TextButton(
                        onPressed: controller.canResend.value
                            ? controller.onResendOtp
                            : null,
                        child: controller.canResend.value
                            ? const Text('Renvoyer le code')
                            : Text(
                                'Renvoyer dans ${controller.resendSeconds.value}s',
                              ),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: controller.onHelp,
                      child: const Text('Besoin d\'aide ?'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
