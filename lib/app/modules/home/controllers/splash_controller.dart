import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../../../routes/app_pages.dart';
import '../../../services/onboarding_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final done = await OnboardingService.isOnboardingDone();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30);
    }
    if (done) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }
}
