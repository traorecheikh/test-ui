import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_done') ?? false;
  }
}
