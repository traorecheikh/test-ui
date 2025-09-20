import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            AppSpacing.extraBitLargeHeightSpacer,
            _buildPhoneInput(context, theme),
            AppSpacing.extraLargeHeightSpacer,
            _buildLoginButton(theme),
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
        Image.asset(
          'assets/images/auth/auth.png',
          height: 320.h,
          width: double.infinity,
          fit: BoxFit.cover,
          semanticLabel: 'login_illustration'.tr,
        ),
        Text(
          'welcome'.tr,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        AppSpacing.smallHeightSpacerWidget,
        Text(
          'login_subtitle'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            height: 1.5.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(BuildContext context, ThemeData theme) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'phone_label'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.mediumHeightSpacerWidget,
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              PhoneInputFormatter(
                defaultCountryCode:
                    controller.selectedCountry.value.countryCode,
              ),
            ],
            onChanged: controller.onPhoneChanged,
            autofillHints: const [AutofillHints.telephoneNumber],
            textInputAction: TextInputAction.done,
            style: const TextStyle(fontSize: 18, letterSpacing: 1.5),
            decoration: InputDecoration(
              hintText: 'phone_hint'.tr,
              errorText: controller.phoneError.value.isEmpty
                  ? null
                  : controller.phoneError.value,
              filled: true,
              fillColor: theme.colorScheme.primary.withOpacity(0.05),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              prefixIcon: Obx(
                () => Container(
                  margin: EdgeInsets.only(left: 12.w, right: 8.w),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Country>(
                      value: controller.selectedCountry.value,
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: theme.colorScheme.background,
                      borderRadius: BorderRadius.circular(18),
                      items: controller.countries.map((country) {
                        return DropdownMenuItem<Country>(
                          value: country,
                          child: Row(
                            children: [
                              Text(
                                country.flagEmoji,
                                style: TextStyle(
                                  fontSize: AppFontSize.headlineMedium,
                                ),
                              ),
                              AppSpacing.smallWidthSpacerWidget,
                              Text(
                                '+${country.phoneCode}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (country) {
                        if (country != null)
                          controller.onCountrySelected(country);
                      },
                    ),
                  ),
                ),
              ),
            ),
            onTap: () => {
              Scrollable.ensureVisible(
                context,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isValid.value ? controller.onRequestOtp : null,
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
                    strokeWidth: 3.sp,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'login_button'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.mediumWidthSpacer,
                    Icon(CupertinoIcons.arrow_right, size: AppIconSizes.medium),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Center(
      child: TextButton(
        onPressed: controller.onHelp,
        child: Text('help'.tr),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
          textStyle: TextStyle(
            fontSize: AppFontSize.bodyLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
