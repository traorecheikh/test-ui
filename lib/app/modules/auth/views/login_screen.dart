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
          semanticLabel: 'Illustration de connexion',
        ),
        Text(
          'Bienvenue !',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        AppSpacing.smallHeightSpacerWidget,
        Text(
          'Connectez-vous pour gérer vos tontines en toute simplicité.',
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
            'Numéro de téléphone',
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
              hintText: 'Votre numéro',
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
              prefixIcon: GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: controller.onCountrySelected,
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.circular(18),
                      backgroundColor: theme.colorScheme.background,
                      inputDecoration: InputDecoration(
                        labelText: 'Rechercher un pays',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Obx(
                  () => Container(
                    margin: EdgeInsets.only(left: 12.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectedCountry.value.flagEmoji,
                          style: TextStyle(
                            fontSize: AppFontSize.headlineMedium,
                          ),
                        ),
                        AppSpacing.smallWidthSpacerWidget,
                        Text(
                          '+${controller.selectedCountry.value.phoneCode}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                        AppSpacing.smallWidthSpacerWidget,
                      ],
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
                      'Se Connecter',
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
        child: const Text('Besoin d\'aide ?'),
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
