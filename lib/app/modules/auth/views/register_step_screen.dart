import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';

import '../../../widgets/animated_validation_icon.dart';
import '../controllers/register_step_controller.dart';

class RegisterStepScreen extends GetView<RegisterStepController> {
  const RegisterStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: Lottie.asset(
                    //     'assets/lottie/register.json',
                    //     width: 100,
                    //     height: 100,
                    //     repeat: true,
                    //   ).animate().fadeIn(duration: 600.ms),
                    // ),
                    const SizedBox(height: 8),
                    _buildStepper(
                      theme,
                    ).animate().slideY(begin: -0.2, duration: 400.ms),
                    const SizedBox(height: 24),
                    Expanded(child: _buildStepContent(theme)),
                    const SizedBox(height: 24),
                    _buildStepButtons(theme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.totalSteps, (index) {
        final isActive = controller.currentStep.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 32 : 16,
          height: 12,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildStep1(theme);
      case 1:
        return _buildStep2(theme);
      case 2:
        return _buildStep3(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(ThemeData theme) {
    return ListView(
      children: [
        Text(
          'Informations de base',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 26,
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 24),
        Obx(
          () => TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              errorText: controller.nameError.value,
              suffixIcon: controller.nameController.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedValidationIcon(
                          isValid: controller.nameError.value.isEmpty,
                          isVisible: controller.nameController.text.isNotEmpty,
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            controller.nameController.clear();
                            controller.onNameChanged('');
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 20),
            onChanged: controller.onNameChanged,
            autofillHints: const [AutofillHints.name],
          ).animate().slideX(begin: -0.1, duration: 300.ms),
        ),
        const SizedBox(height: 18),
        Obx(
          () => TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [MaskedInputFormatter('@*')],
            decoration: InputDecoration(
              labelText: 'Email (optionnel)',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              errorText: controller.emailError.value,
              suffixIcon: controller.emailController.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedValidationIcon(
                          isValid: controller.emailError.value.isEmpty,
                          isVisible: controller.emailController.text.isNotEmpty,
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            controller.emailController.clear();
                            controller.onEmailChanged('');
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 20),
            onChanged: controller.onEmailChanged,
            autofillHints: const [AutofillHints.email],
          ).animate().slideX(begin: 0.1, duration: 300.ms),
        ),
        const SizedBox(height: 18),
        Obx(
          () => GestureDetector(
            onTap: controller.onPickProfilePicture,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    controller.profilePicturePath.value.isEmpty
                        ? 'Ajouter une photo de profil'
                        : 'Photo sélectionnée',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ),
      ],
    );
  }

  Widget _buildStep2(ThemeData theme) {
    return ListView(
      children: [
        Text(
          'Préférences et localisation',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 26,
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 24),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.language.value,
            items: const [
              DropdownMenuItem(value: 'FR', child: Text('Français')),
              DropdownMenuItem(value: 'WO', child: Text('Wolof')),
            ],
            onChanged: controller.onLanguageChanged,
            decoration: InputDecoration(
              labelText: 'Langue préférée',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ).animate().slideX(begin: -0.1, duration: 300.ms),
        ),
        const SizedBox(height: 18),
        Obx(
          () => TextFormField(
            controller: controller.cityController,
            decoration: InputDecoration(
              labelText: 'Ville',
              prefixIcon: const Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              errorText: controller.cityError.value,
              suffixIcon: controller.cityController.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedValidationIcon(
                          isValid: controller.cityError.value.isEmpty,
                          isVisible: controller.cityController.text.isNotEmpty,
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            controller.cityController.clear();
                            controller.onCityChanged('');
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 20),
            onChanged: controller.onCityChanged,
            autofillHints: const [AutofillHints.addressCity],
          ).animate().slideX(begin: 0.1, duration: 300.ms),
        ),
        const SizedBox(height: 18),
        Obx(
          () => TextFormField(
            controller: controller.regionController,
            decoration: InputDecoration(
              labelText: 'Région',
              prefixIcon: const Icon(Icons.map),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              errorText: controller.regionError.value,
              suffixIcon: controller.regionController.text.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedValidationIcon(
                          isValid: controller.regionError.value.isEmpty,
                          isVisible:
                              controller.regionController.text.isNotEmpty,
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            controller.regionController.clear();
                            controller.onRegionChanged('');
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 20),
            onChanged: controller.onRegionChanged,
            autofillHints: const [AutofillHints.addressState],
          ).animate().slideX(begin: -0.1, duration: 300.ms),
        ),
        const SizedBox(height: 18),
        // Country picker
        Obx(
          () => GestureDetector(
            onTap: () {
              showCountryPicker(
                context: Get.context!,
                showPhoneCode: false,
                onSelect: (country) {
                  controller.countryController.text = country.name;
                  controller.onCountryChanged(country.name);
                },
                countryListTheme: CountryListThemeData(
                  borderRadius: BorderRadius.circular(18),
                  backgroundColor: Colors.white,
                  inputDecoration: const InputDecoration(
                    labelText: 'Rechercher un pays',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              );
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller.countryController,
                decoration: InputDecoration(
                  labelText: 'Pays',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  errorText: controller.countryError.value,
                ),
                style: const TextStyle(fontSize: 20),
                onChanged: controller.onCountryChanged,
                autofillHints: const [AutofillHints.countryName],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ),
      ],
    );
  }

  Widget _buildStep3(ThemeData theme) {
    return ListView(
      children: [
        Text(
          'Vérification',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.person),
            title: Text(controller.nameController.text),
            subtitle: Text('Nom complet'),
          ),
        ),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.email),
            title: Text(
              controller.emailController.text.isEmpty
                  ? 'Non renseigné'
                  : controller.emailController.text,
            ),
            subtitle: const Text('Email'),
          ),
        ),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              controller.language.value == 'FR' ? 'Français' : 'Wolof',
            ),
            subtitle: const Text('Langue'),
          ),
        ),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(controller.cityController.text),
            subtitle: const Text('Ville'),
          ),
        ),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.map),
            title: Text(controller.regionController.text),
            subtitle: const Text('Région'),
          ),
        ),
        Obx(
          () => ListTile(
            leading: const Icon(Icons.flag),
            title: Text(controller.countryController.text),
            subtitle: const Text('Pays'),
          ),
        ),
        const SizedBox(height: 18),
        Obx(
          () => controller.profilePicturePath.value.isNotEmpty
              ? Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      controller.profilePicturePath.value,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStepButtons(ThemeData theme) {
    return Row(
      children: [
        if (controller.currentStep.value > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: controller.onBack,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Précédent'),
            ),
          ),
        if (controller.currentStep.value > 0) const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isStepValid.value
                  ? controller.onNext
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                controller.currentStep.value == controller.totalSteps - 1
                    ? 'Terminer'
                    : 'Suivant',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
