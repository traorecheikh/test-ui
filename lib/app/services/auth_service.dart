import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

/// Service for handling PIN and biometric authentication
class AuthService extends GetxService {
  static const String _pinKey = 'user_pin';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _pinEnabledKey = 'pin_enabled';
  static const String _isAuthenticatedKey = 'is_authenticated';

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Reactive variables
  final RxBool isPinEnabled = false.obs;
  final RxBool isBiometricEnabled = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isBiometricAvailable = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadSettings();
    await _checkBiometricAvailability();
  }

  /// Initialize the auth service
  static Future<AuthService> init() async {
    final service = AuthService();
    await service.onInit();
    return service;
  }

  /// Load authentication settings from secure storage
  Future<void> _loadSettings() async {
    isPinEnabled.value =
        (await _secureStorage.read(key: _pinEnabledKey)) == 'true';
    isBiometricEnabled.value =
        (await _secureStorage.read(key: _biometricEnabledKey)) == 'true';
    isAuthenticated.value =
        (await _secureStorage.read(key: _isAuthenticatedKey)) == 'true';
  }

  /// Set a boolean value in secure storage
  Future<void> _setBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value ? 'true' : 'false');
  }

  /// Check if biometric authentication is available on the device
  Future<void> _checkBiometricAvailability() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      isBiometricAvailable.value = isAvailable && isDeviceSupported;
    } catch (e) {
      isBiometricAvailable.value = false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Set up PIN authentication
  Future<bool> setupPin(String pin) async {
    try {
      if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
        throw Exception('PIN must be exactly 4 digits');
      }
      await _secureStorage.write(key: _pinKey, value: pin);
      await _setBool(_pinEnabledKey, true);
      isPinEnabled.value = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    try {
      final storedPin = await _secureStorage.read(key: _pinKey);
      return storedPin == pin;
    } catch (e) {
      return false;
    }
  }

  /// Enable/disable PIN authentication
  Future<bool> togglePinAuth(bool enabled) async {
    try {
      if (!enabled) {
        await _secureStorage.delete(key: _pinKey);
      }
      await _setBool(_pinEnabledKey, enabled);
      isPinEnabled.value = enabled;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Enable/disable biometric authentication
  Future<bool> toggleBiometricAuth(bool enabled) async {
    try {
      if (enabled && !isBiometricAvailable.value) {
        return false;
      }
      await _setBool(_biometricEnabledKey, enabled);
      isBiometricEnabled.value = enabled;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!isBiometricEnabled.value || !isBiometricAvailable.value) {
        return false;
      }

      final availableBiometrics = await getAvailableBiometrics();
      String reason = 'Authentifiez-vous pour accéder à l\'application';

      if (availableBiometrics.contains(BiometricType.face)) {
        reason = 'Utilisez Face ID pour vous authentifier';
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        reason = 'Utilisez votre empreinte digitale pour vous authentifier';
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error during biometric authentication: $e');
      return false;
    }
  }

  /// Check if any authentication method is enabled
  bool get isAuthRequired => isPinEnabled.value || isBiometricEnabled.value;

  /// Set authentication status
  Future<void> setAuthenticated(bool authenticated) async {
    await _setBool(_isAuthenticatedKey, authenticated);
    isAuthenticated.value = authenticated;
  }

  /// Reset authentication (logout)
  Future<void> logout() async {
    await setAuthenticated(false);
  }

  /// Check if user needs to authenticate
  bool get needsAuthentication => isAuthRequired && !isAuthenticated.value;

  /// Change PIN
  Future<bool> changePin(String oldPin, String newPin) async {
    try {
      if (!await verifyPin(oldPin)) {
        return false;
      }
      return await setupPin(newPin);
    } catch (e) {
      return false;
    }
  }

  /// Delete all authentication data
  Future<void> clearAllAuthData() async {
    await _secureStorage.delete(key: _pinKey);
    await _setBool(_pinEnabledKey, false);
    await _setBool(_biometricEnabledKey, false);
    await _setBool(_isAuthenticatedKey, false);
    isPinEnabled.value = false;
    isBiometricEnabled.value = false;
    isAuthenticated.value = false;
  }
}
