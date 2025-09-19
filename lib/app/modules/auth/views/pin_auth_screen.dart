import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

import '../../../services/auth_service.dart';
import '../controllers/auth_controller.dart';

/// PIN authentication screen with automatic biometric support
class PinAuthScreen extends StatelessWidget {
  const PinAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final authService = Get.find<AuthService>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),

              // App Icon and Title
              Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ).animate().scale(delay: 300.ms),

                  SizedBox(height: 24.h),

                  Text(
                    'Authentification',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  SizedBox(height: 8.h),

                  // Dynamic subtitle based on available authentication methods
                  Obx(
                    () => Text(
                      _getSubtitleText(authService),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 500.ms),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // Modern PIN Input
              Pinput(
                length: 4,
                autofocus: true,
                obscureText: true,
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
                  controller.enteredPin.value = value;
                  if (controller.showError.value)
                    controller.showError.value = false;
                },
                onCompleted: (pin) async {
                  final success = await controller.verifyPin();
                  if (success) {
                    Get.offAllNamed('/home');
                  } else {
                    controller.showErrorMessage(
                      'PIN incorrect. Veuillez réessayer.',
                    );
                    controller.clearPin();
                  }
                },
              ).animate().fadeIn(delay: 600.ms),

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

              // Biometric status indicator (only when biometric is enabled)
              Obx(
                () =>
                    authService.isBiometricEnabled.value &&
                        authService.isBiometricAvailable.value
                    ? _buildBiometricStatusIndicator(
                        theme,
                        authService,
                        controller,
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitleText(AuthService authService) {
    if (authService.isBiometricEnabled.value &&
        authService.isBiometricAvailable.value) {
      return 'Authentification automatique en cours...';
    }
    return 'Saisissez votre PIN pour continuer';
  }

  Widget _buildBiometricStatusIndicator(
    ThemeData theme,
    AuthService authService,
    AuthController controller,
  ) {
    return FutureBuilder<List<BiometricType>>(
      future: authService.getAvailableBiometrics(),
      builder: (context, snapshot) {
        final biometrics = snapshot.data ?? [];
        IconData icon = Icons.fingerprint;
        String text = 'Empreinte digitale';

        if (biometrics.contains(BiometricType.face)) {
          icon = Icons.face;
          text = 'Face ID';
        }

        return Obx(
          () => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isLoading.value)
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    else
                      Icon(icon, color: theme.colorScheme.primary, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      controller.isLoading.value
                          ? 'Authentification...'
                          : '$text activé',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Ou utilisez votre PIN ci-dessous',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
