import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../controllers/auth_controller.dart';

/// Screen for setting up a new PIN
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final controller = Get.put(AuthController());
  final TextEditingController pinController = TextEditingController();
  final FocusNode pinFocusNode = FocusNode();
  String firstPin = '';
  String secondPin = '';
  bool isConfirming = false;

  @override
  void dispose() {
    pinController.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Configuration du PIN',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // Instructions
              Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      isConfirming ? Icons.lock_reset : Icons.lock_outline,
                      color: theme.colorScheme.primary,
                      size: 40.sp,
                    ),
                  ).animate().scale(delay: 200.ms),

                  SizedBox(height: 24.h),

                  Text(
                    isConfirming ? 'Confirmez votre PIN' : 'Créez un PIN',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  SizedBox(height: 8.h),

                  Text(
                    isConfirming
                        ? 'Saisissez à nouveau votre PIN pour le confirmer'
                        : 'Choisissez un PIN à 4 chiffres pour sécuriser votre application',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),

              SizedBox(height: 60.h),

              // Modern PIN Input
              Pinput(
                length: 4,
                autofocus: true,
                obscureText: true,
                controller: pinController,
                focusNode: pinFocusNode,
                defaultPinTheme: PinTheme(
                  width: 56.w,
                  height: 56.h,
                  textStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: controller.showError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    if (isConfirming) {
                      secondPin = value;
                    } else {
                      firstPin = value;
                    }
                    if (controller.showError.value)
                      controller.showError.value = false;
                  });
                },
                onCompleted: (pin) async {
                  if (!isConfirming) {
                    setState(() {
                      isConfirming = true;
                      pinController.clear();
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      pinFocusNode.requestFocus();
                    });
                  } else {
                    final success = await controller.setupPin(
                      firstPin,
                      secondPin,
                    );
                    if (success) {
                      pinController.clear();
                      Get.back(result: true);
                      Get.snackbar(
                        'Succès',
                        'PIN configuré avec succès',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    } else {
                      setState(() {
                        secondPin = '';
                        pinController.clear();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        pinFocusNode.requestFocus();
                      });
                    }
                  }
                },
              ).animate().fadeIn(delay: 500.ms),

              SizedBox(height: 24.h),

              // Error Message
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.showError.value ? 40.h : 0,
                  child: controller.showError.value
                      ? Text(
                          controller.errorMessage.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().shake(duration: 500.ms)
                      : const SizedBox.shrink(),
                ),
              ),

              const Spacer(),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
