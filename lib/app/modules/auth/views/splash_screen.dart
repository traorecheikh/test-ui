import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

/// Splash screen that handles authentication checks
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for a minimum splash duration for better UX
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final authService = Get.find<AuthService>();

      // If authentication is required, show PIN auth screen
      if (authService.needsAuthentication) {
        Get.offAllNamed(Routes.PIN_AUTH);
      } else {
        // Try biometric authentication if enabled
        if (authService.isBiometricEnabled.value &&
            authService.isBiometricAvailable.value) {
          final success = await authService.authenticateWithBiometrics();
          if (success) {
            await authService.setAuthenticated(true);
            Get.offAllNamed(Routes.home);
          } else {
            // Fallback to PIN if biometric fails
            Get.offAllNamed(Routes.PIN_AUTH);
          }
        } else {
          Get.offAllNamed(Routes.home);
        }
      }
    } catch (e) {
      // On error, go to home screen
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 60.sp,
                    color: theme.colorScheme.primary,
                  ),
                )
                .animate()
                .scale(
                  delay: 200.ms,
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .then()
                .shimmer(duration: 1000.ms),

            SizedBox(height: 40.h),

            // App Name
            Text(
                  'TontineFlow',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),

            SizedBox(height: 16.h),

            // Loading indicator
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
