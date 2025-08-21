import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_step_controller.dart';

// Note: This screen reuses widgets from the new Create Tontine UI for consistency.
// You might want to move them to a common 'widgets' directory.

class RegisterStepScreen extends GetView<RegisterStepController> {
  const RegisterStepScreen({super.key});

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
            CupertinoIcons.xmark,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          onPressed: () => Get.back(),
          tooltip: 'Annuler',
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => _ProgressIndicator(
              currentStep: controller.currentStep.value,
              totalSteps: controller.totalSteps,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.totalSteps,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildStep(context, index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => _NavigationControls(
          isFirstStep: controller.currentStep.value == 0,
          isLastStep: controller.currentStep.value == controller.totalSteps - 1,
          isStepValid: controller.isStepValid.value,
          onBackPressed: controller.onBack,
          onNextPressed: controller.onNext,
          onFinishPressed: controller.onNext, // onNext handles finish logic
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int stepIndex) {
    final List<Widget> steps = [
      _Step1BasicInfo(),
      _Step2Location(),
      _Step3Preview(),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: steps[stepIndex],
    );
  }
}

// --- STEP WIDGETS ---

class _Step1BasicInfo extends GetView<RegisterStepController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: CupertinoIcons.person_crop_circle_fill,
          title: 'Créez votre profil',
          subtitle: 'Pour commencer, entrez vos informations de base.',
        ),
        const SizedBox(height: 32),
        _FluffyTextField(
          controller: controller.nameController,
          label: 'Nom complet',
          hint: 'Ex: Mariama Diallo',
          icon: CupertinoIcons.person_fill,
          validator: (val) => controller.nameError.value,
          onChanged: controller.onNameChanged,
        ),
        const SizedBox(height: 24),
        _FluffyTextField(
          controller: controller.emailController,
          label: 'Adresse email (optionnel)',
          hint: 'mariama@exemple.com',
          icon: CupertinoIcons.mail_solid,
          keyboardType: TextInputType.emailAddress,
          validator: (val) => controller.emailError.value,
          onChanged: controller.onEmailChanged,
        ),
        const SizedBox(height: 24),
        _ImagePickerButton(),
      ],
    );
  }
}

class _Step2Location extends GetView<RegisterStepController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: CupertinoIcons.location_solid,
          title: 'Où êtes-vous ?',
          subtitle: 'Ces informations nous aident à personnaliser votre expérience.',
        ),
        const SizedBox(height: 32),
        _FluffyTextField(
          controller: controller.cityController,
          label: 'Ville',
          hint: 'Ex: Dakar',
          icon: CupertinoIcons.building_2_fill,
          onChanged: controller.onCityChanged,
          validator: (val) => controller.cityError.value,
        ),
        const SizedBox(height: 24),
        _FluffyTextField(
          controller: controller.regionController,
          label: 'Région',
          hint: 'Ex: Dakar',
          icon: CupertinoIcons.map_fill,
          onChanged: controller.onRegionChanged,
          validator: (val) => controller.regionError.value,
        ),
        const SizedBox(height: 24),
        _CountryPickerField(),
      ],
    );
  }
}

class _Step3Preview extends GetView<RegisterStepController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: CupertinoIcons.checkmark_seal_fill,
          title: 'Tout est bon ?',
          subtitle: 'Vérifiez vos informations une dernière fois.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Obx(
                () => _buildPreviewRow(
                  theme,
                  'Nom complet',
                  controller.nameController.text,
                  CupertinoIcons.person_fill,
                ),
              ),
              Obx(
                () => _buildPreviewRow(
                  theme,
                  'Email',
                  controller.emailController.text.isNotEmpty
                      ? controller.emailController.text
                      : 'Non fourni',
                  CupertinoIcons.mail_solid,
                ),
              ),
              Obx(
                () => _buildPreviewRow(
                  theme,
                  'Localisation',
                  '${controller.cityController.text}, ${controller.countryController.text}',
                  CupertinoIcons.location_solid,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRow(
      ThemeData theme, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- UI Building Blocks ---

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (currentStep + 1) / totalSteps;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'Étape ${currentStep + 1} sur $totalSteps',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(percentage * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lottie Fallback
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FluffyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;

  const _FluffyTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Obx(
          () => TextFormField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            validator: (val) => validator?.call(val),
            decoration: InputDecoration(
              hintText: hint,
              errorText: validator?.call(null) == '' ? null : validator?.call(null),
              prefixIcon:
                  Icon(icon, color: theme.colorScheme.primary.withOpacity(0.6)),
              filled: true,
              fillColor: theme.colorScheme.primary.withOpacity(0.05),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePickerButton extends GetView<RegisterStepController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: controller.onPickProfilePicture,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.camera_fill,
                color: theme.colorScheme.primary.withOpacity(0.8)),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => Text(
                  controller.profilePicturePath.value.isEmpty
                      ? 'Ajouter une photo (optionnel)'
                      : 'Photo sélectionnée !',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Obx(() {
              if (controller.profilePicturePath.value.isNotEmpty) {
                return const Icon(CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green);
              }
              return const Icon(CupertinoIcons.add_circled);
            })
          ],
        ),
      ),
    );
  }
}

class _CountryPickerField extends GetView<RegisterStepController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          onSelect: (country) {
            controller.countryController.text = country.name;
            controller.onCountryChanged(country.name);
          },
          countryListTheme: CountryListThemeData(
            borderRadius: BorderRadius.circular(18),
            backgroundColor: theme.colorScheme.background,
            inputDecoration: InputDecoration(
              labelText: 'Rechercher un pays',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
            ),
          ),
        );
      },
      child: AbsorbPointer(
        child: _FluffyTextField(
          controller: controller.countryController,
          label: 'Pays',
          hint: 'Sélectionnez votre pays',
          icon: CupertinoIcons.flag_fill,
          onChanged: controller.onCountryChanged,
          validator: (val) => controller.countryError.value,
        ),
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  final bool isFirstStep;
  final bool isLastStep;
  final bool isStepValid;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onFinishPressed;

  const _NavigationControls({
    required this.isFirstStep,
    required this.isLastStep,
    required this.isStepValid,
    required this.onBackPressed,
    required this.onNextPressed,
    required this.onFinishPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            TextButton.icon(
              onPressed: onBackPressed,
              icon: const Icon(CupertinoIcons.arrow_left),
              label: const Text('Retour'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: isStepValid
                ? (isLastStep ? onFinishPressed : onNextPressed)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  theme.colorScheme.primary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              elevation: 5,
              shadowColor: theme.colorScheme.primary.withOpacity(0.3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLastStep ? 'Terminer' : 'Suivant',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Icon(
                  isLastStep
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.arrow_right,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}