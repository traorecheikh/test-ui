import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme.dart';
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
            size: 32.sp,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            AppSpacing.extraBitLargeHeightSpacer,
            _buildOtpInput(theme),
            AppSpacing.largeHeightSpacer,
            _buildValidateButton(theme),
            AppSpacing.largeHeightSpacer,
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
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(
            CupertinoIcons.lock_shield_fill,
            color: theme.colorScheme.primary,
            size: 40.sp,
          ),
        ),
        AppSpacing.largeHeightSpacer,
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
                  final isFocused = controller.otpValue.value.length == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52.w,
                    height: 64.h,
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
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
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
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            elevation: 5,
            shadowColor: theme.colorScheme.primary.withOpacity(0.3),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Valider le code',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.mediumHeightSpacer,
                    Icon(CupertinoIcons.check_mark_circled, size: 22.sp),
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
          style: TextButton.styleFrom(
            foregroundColor: controller.canResend.value
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
            textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          child: controller.canResend.value
              ? const Text('Renvoyer le code')
              : Text('Renvoyer dans ${controller.resendSeconds.value}s'),
        ),
      ),
    );
  }
}
