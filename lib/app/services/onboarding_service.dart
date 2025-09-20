import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingService {
  static const String _onboardingDoneKey = 'onboarding_done';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Returns true if onboarding is completed
  static Future<bool> isOnboardingDone() async {
    final value = await _secureStorage.read(key: _onboardingDoneKey);
    return value == 'true';
  }

  /// Sets onboarding as completed
  static Future<void> setOnboardingDone(bool done) async {
    await _secureStorage.write(
      key: _onboardingDoneKey,
      value: done ? 'true' : 'false',
    );
  }
}
