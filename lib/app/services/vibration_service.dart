import 'package:vibration/vibration.dart';

class VibrationService {
  static Future<void> softVibrate() async {
    // Ensure the device has a vibrator
    if (!(await Vibration.hasVibrator() ?? false)) return;

    final bool canControlAmp = await Vibration.hasAmplitudeControl() ?? false;

    if (canControlAmp) {
      // Short vibration with low amplitude for a soft feel
      await Vibration.vibrate(duration: 50, amplitude: 80);
    } else {
      // Fallback for devices without amplitude control: short duration, default amplitude
      await Vibration.vibrate(duration: 50);
    }
  }

  static Future<void> mediumVibrate() async {
    // Ensure the device has a vibrator
    if (!(await Vibration.hasVibrator() ?? false)) return;

    final bool canControlAmp = await Vibration.hasAmplitudeControl() ?? false;
    final bool hasCustomSupport =
        await Vibration.hasCustomVibrationsSupport() ?? false;

    if (hasCustomSupport) {
      // Use a simple pattern for a distinct medium vibration if custom support is available
      final List<int> pattern = [
        0,
        120,
        60,
        120,
      ]; // pattern: wait, vibrate, wait, vibrate
      // Intensities for the two vibration segments (120ms, 120ms)
      final List<int> intensities = canControlAmp ? [128, 160] : [];

      await Vibration.vibrate(
        pattern: pattern,
        intensities: intensities,
        // Pass empty if amplitude can't be controlled; library uses defaults
        amplitude: canControlAmp
            ? 160
            : -1, // Medium amplitude or platform default
      );
    } else {
      // Fallback for devices without custom pattern support:
      // Rely on `duration` being honored as best as possible.
      if (canControlAmp) {
        await Vibration.vibrate(
          duration: 200,
          amplitude: 128,
        ); // Medium duration and amplitude
      } else {
        await Vibration.vibrate(
          duration: 200,
        ); // Medium duration, default amplitude
      }
    }
  }

  static Future<void> godlyVibrate() async {
    // Ensure the device has a vibrator
    if (!(await Vibration.hasVibrator() ?? false)) return;

    final bool canControlAmp = await Vibration.hasAmplitudeControl() ?? false;
    final bool hasCustomSupport =
        await Vibration.hasCustomVibrationsSupport() ?? false;

    if (hasCustomSupport) {
      // A more complex and strong pattern for "godly" feedback
      // Pattern: wait, short-pulse, wait, medium-strong-pulse, wait, long-strongest-pulse
      final List<int> pattern = [0, 60, 40, 120, 40, 250];
      // Intensities for the three vibration segments (60ms, 120ms, 250ms)
      final List<int> intensities = canControlAmp ? [150, 200, 255] : [];

      await Vibration.vibrate(
        pattern: pattern,
        intensities: intensities,
        amplitude: canControlAmp
            ? 255
            : -1, // Max amplitude or platform default
      );
    } else {
      // Fallback for devices without custom pattern/intensity support (e.g., older iOS):
      // A long and strong single vibration.
      if (canControlAmp) {
        await Vibration.vibrate(
          duration: 800,
          amplitude: 255,
        ); // Long duration, max amplitude
      } else {
        await Vibration.vibrate(
          duration: 800,
        ); // Long duration, default amplitude
      }
    }
  }
}
