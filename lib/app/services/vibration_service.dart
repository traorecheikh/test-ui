import 'package:vibration/vibration.dart';

class VibrationService {
  static Future<void> godlyVibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Strong, long, and patterned vibration for "orgasmic" feedback
      await Vibration.vibrate(
        pattern: [0, 60, 30, 120, 30, 60],
        intensities: [128, 255, 128, 255, 128, 255],
        amplitude: 255,
      );
    }
  }

  static Future<void> softVibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 30, amplitude: 80);
    }
  }
}
