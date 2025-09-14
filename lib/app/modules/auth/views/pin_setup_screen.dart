import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// Screen for setting up a new PIN
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final controller = Get.put(AuthController());
  String firstPin = '';
  String secondPin = '';
  bool isConfirming = false;

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
                      color: theme.colorScheme.primary.withOpacity(0.1),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),

              SizedBox(height: 60.h),

              // PIN Dots Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final currentPin = isConfirming ? secondPin : firstPin;
                  final isFilled = index < currentPin.length;
                  return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.3),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                      )
                      .animate(target: isFilled ? 1 : 0)
                      .scale(duration: 200.ms, curve: Curves.elasticOut);
                }),
              ).animate().slideX(delay: 500.ms),

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

              // PIN Keypad
              _buildKeypad(context),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Numbers 1-3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton(context, '1'),
            _buildKeypadButton(context, '2'),
            _buildKeypadButton(context, '3'),
          ],
        ),
        SizedBox(height: 20.h),

        // Numbers 4-6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton(context, '4'),
            _buildKeypadButton(context, '5'),
            _buildKeypadButton(context, '6'),
          ],
        ),
        SizedBox(height: 20.h),

        // Numbers 7-9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton(context, '7'),
            _buildKeypadButton(context, '8'),
            _buildKeypadButton(context, '9'),
          ],
        ),
        SizedBox(height: 20.h),

        // Bottom row: empty, 0, backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 70.w), // Empty space
            _buildKeypadButton(context, '0'),
            _buildBackspaceButton(context),
          ],
        ),
      ],
    ).animate().slideY(delay: 600.ms, begin: 1);
  }

  Widget _buildKeypadButton(BuildContext context, String number) {
    final theme = Theme.of(context);

    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : () => _onNumberPressed(number),
        child: Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value ? null : _onBackspacePressed,
        child: Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (isConfirming) {
        if (secondPin.length < 4) {
          secondPin += number;
          controller.clearError();
        }
      } else {
        if (firstPin.length < 4) {
          firstPin += number;
          controller.clearError();
        }
      }
    });

    // Check if PIN is complete
    if (isConfirming && secondPin.length == 4) {
      _setupPin();
    } else if (!isConfirming && firstPin.length == 4) {
      setState(() {
        isConfirming = true;
      });
    }
  }

  void _onBackspacePressed() {
    setState(() {
      if (isConfirming) {
        if (secondPin.isNotEmpty) {
          secondPin = secondPin.substring(0, secondPin.length - 1);
          controller.clearError();
        }
      } else {
        if (firstPin.isNotEmpty) {
          firstPin = firstPin.substring(0, firstPin.length - 1);
          controller.clearError();
        }
      }
    });
  }

  Future<void> _setupPin() async {
    final success = await controller.setupPin(firstPin, secondPin);
    if (success) {
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
      });
    }
  }
}
