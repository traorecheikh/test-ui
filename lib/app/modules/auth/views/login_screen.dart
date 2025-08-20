import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
                  // Lottie animation for friendly welcome
                  // Center(
                  //   child: Lottie.asset(
                  //     'assets/lottie/welcome.json',
                  //     width: 120,
                  //     height: 120,
                  //     repeat: true,
                  //   ).animate().fadeIn(duration: 600.ms),
                  // ),
                  const SizedBox(height: 12),
                  Text(
                    'Bienvenue 👋',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 32,
                    ),
                  ).animate().slideY(begin: -0.3, duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Connectez-vous avec votre numéro de téléphone',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  const SizedBox(height: 24),
                  // Trust badges row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.verified,
                            color: Colors.green, size: 20),
                        label: const Text('Sécurisé'),
                        backgroundColor: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        avatar: const Icon(Icons.lock,
                            color: Colors.blue, size: 20),
                        label: const Text('Confidentiel'),
                        backgroundColor: Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  const SizedBox(height: 24),
                  // Country picker + phone field
                  Obx(() => Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: controller.onCountrySelected,
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(controller.selectedCountry.value.flagEmoji,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 4),
                                  Text(
                                      '+${controller.selectedCountry.value.phoneCode}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => TextFormField(
                                  controller: controller.phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    PhoneInputFormatter(
                                      defaultCountryCode: controller
                                          .selectedCountry.value.countryCode,
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Numéro de téléphone',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    errorText: controller.phoneError.value,
                                    suffixIcon: controller
                                            .phoneController.text.isNotEmpty
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (controller.isValid.value)
                                                const Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 22)
                                              else if (controller
                                                  .phoneError.value.isNotEmpty)
                                                const Icon(Icons.error,
                                                    color: Colors.red,
                                                    size: 22),
                                              IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 20),
                                                onPressed: () {
                                                  controller.phoneController
                                                      .clear();
                                                  controller.onPhoneChanged('');
                                                },
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20, letterSpacing: 1),
                                  onChanged: controller.onPhoneChanged,
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber
                                  ],
                                  textInputAction: TextInputAction.done,
                                )),
                          ),
                        ],
                      )),
                  const SizedBox(height: 32),
                  // Animated button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.isValid.value
                              ? controller.onRequestOtp
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            elevation: 2,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Recevoir le code'),
                        )
                            .animate()
                            .scaleXY(begin: 0.95, end: 1.0, duration: 200.ms)),
                  ),
                  const SizedBox(height: 18),
                  // Motivational tip
                  Center(
                    child: Text(
                      '💡 Astuce: Votre numéro reste privé et sécurisé!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: controller.onHelp,
                      child: const Text('Besoin d\'aide ?'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
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
