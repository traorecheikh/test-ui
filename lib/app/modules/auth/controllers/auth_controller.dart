import 'package:get/get.dart';

import '../../../services/auth_service.dart';

/// Controller for managing authentication state and operations
class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Reactive variables
  final RxString enteredPin = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool showError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt attemptCount = 0.obs;

  // Constants
  static const int maxAttempts = 5;
  static const int lockoutDuration = 30; // seconds

  @override
  void onInit() {
    super.onInit();
    // Clear any previous authentication state when controller is initialized
    clearPin();
  }

  /// Add digit to PIN
  void addDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      clearError();
    }
  }

  /// Remove last digit from PIN
  void removeDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(
        0,
        enteredPin.value.length - 1,
      );
      clearError();
    }
  }

  /// Clear PIN
  void clearPin() {
    enteredPin.value = '';
    clearError();
  }

  /// Clear error state
  void clearError() {
    showError.value = false;
    errorMessage.value = '';
  }

  /// Show error message
  void showErrorMessage(String message) {
    errorMessage.value = message;
    showError.value = true;
  }

  /// Verify entered PIN
  Future<bool> verifyPin() async {
    if (enteredPin.value.length != 4) {
      showErrorMessage('Veuillez saisir un PIN à 4 chiffres');
      return false;
    }

    isLoading.value = true;
    try {
      final isValid = await _authService.verifyPin(enteredPin.value);

      if (isValid) {
        await _authService.setAuthenticated(true);
        attemptCount.value = 0;
        clearPin();
        return true;
      } else {
        attemptCount.value++;
        clearPin();

        if (attemptCount.value >= maxAttempts) {
          showErrorMessage(
            'Trop de tentatives incorrectes. Réessayez dans $lockoutDuration secondes.',
          );
          _startLockoutTimer();
        } else {
          final remaining = maxAttempts - attemptCount.value;
          showErrorMessage(
            'PIN incorrect. $remaining tentative${remaining > 1 ? 's' : ''} restante${remaining > 1 ? 's' : ''}',
          );
        }
        return false;
      }
    } catch (e) {
      showErrorMessage('Erreur lors de la vérification du PIN');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Setup new PIN
  Future<bool> setupPin(String pin, String confirmPin) async {
    if (pin != confirmPin) {
      showErrorMessage('Les PINs ne correspondent pas');
      return false;
    }

    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      showErrorMessage('Le PIN doit contenir exactement 4 chiffres');
      return false;
    }

    isLoading.value = true;
    try {
      final success = await _authService.setupPin(pin);
      if (success) {
        clearPin();
        return true;
      } else {
        showErrorMessage('Erreur lors de la configuration du PIN');
        return false;
      }
    } catch (e) {
      showErrorMessage('Erreur lors de la configuration du PIN');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Change PIN
  Future<bool> changePin(
    String oldPin,
    String newPin,
    String confirmPin,
  ) async {
    if (newPin != confirmPin) {
      showErrorMessage('Les nouveaux PINs ne correspondent pas');
      return false;
    }

    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) {
      showErrorMessage('Le nouveau PIN doit contenir exactement 4 chiffres');
      return false;
    }

    isLoading.value = true;
    try {
      final success = await _authService.changePin(oldPin, newPin);
      if (success) {
        clearPin();
        return true;
      } else {
        showErrorMessage('PIN actuel incorrect');
        return false;
      }
    } catch (e) {
      showErrorMessage('Erreur lors du changement du PIN');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    isLoading.value = true;
    try {
      final success = await _authService.authenticateWithBiometrics();
      if (success) {
        await _authService.setAuthenticated(true);
        return true;
      } else {
        showErrorMessage('Authentification biométrique échouée');
        return false;
      }
    } catch (e) {
      showErrorMessage('Erreur lors de l\'authentification biométrique');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle PIN authentication
  Future<bool> togglePinAuth(bool enabled) async {
    isLoading.value = true;
    try {
      final success = await _authService.togglePinAuth(enabled);
      if (!success) {
        showErrorMessage('Erreur lors de la modification du PIN');
      }
      return success;
    } catch (e) {
      showErrorMessage('Erreur lors de la modification du PIN');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle biometric authentication
  Future<bool> toggleBiometricAuth(bool enabled) async {
    isLoading.value = true;
    try {
      final success = await _authService.toggleBiometricAuth(enabled);
      if (!success) {
        showErrorMessage(
          'Erreur lors de la modification de l\'authentification biométrique',
        );
      }
      return success;
    } catch (e) {
      showErrorMessage(
        'Erreur lors de la modification de l\'authentification biométrique',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Start lockout timer
  void _startLockoutTimer() {
    Future.delayed(Duration(seconds: lockoutDuration), () {
      attemptCount.value = 0;
      clearError();
    });
  }

  /// Check if user is locked out
  bool get isLockedOut => attemptCount.value >= maxAttempts;

  /// Get remaining attempts
  int get remainingAttempts => maxAttempts - attemptCount.value;

  // Getters for auth service state
  bool get isPinEnabled => _authService.isPinEnabled.value;
  bool get isBiometricEnabled => _authService.isBiometricEnabled.value;
  bool get isBiometricAvailable => _authService.isBiometricAvailable.value;
  bool get isAuthenticated => _authService.isAuthenticated.value;
  bool get needsAuthentication => _authService.needsAuthentication;
}
