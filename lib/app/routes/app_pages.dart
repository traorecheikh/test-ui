import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/auth/bindings/auth_binding.dart';
import 'package:snt_ui_test/app/modules/auth/views/login_screen.dart';
import 'package:snt_ui_test/app/modules/auth/views/otp_screen.dart';
import 'package:snt_ui_test/app/modules/auth/views/register_step_screen.dart';
import 'package:snt_ui_test/app/modules/tontines/views/my_tontines_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/onboarding_screen.dart';
import '../modules/join/bindings/join_scanner_binding.dart';
import '../modules/join/views/join_scanner_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_screen.dart';
import '../modules/tontine/bindings/create_tontine_binding.dart';
import '../modules/tontine/bindings/join_tontine_binding.dart';
import '../modules/tontine/bindings/tontine_detail_binding.dart';
import '../modules/tontine/views/create_tontine_screen.dart';
import '../modules/tontine/views/join_tontine_screen.dart';
import '../modules/tontine/views/tontine_detail_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: Routes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.create,
      page: () => const CreateTontineScreen(),
      binding: CreateTontineBinding(),
    ),
    GetPage(
      name: Routes.join,
      page: () => const JoinTontineScreen(),
      binding: JoinTontineBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.detail,
      page: () => TontineDetailScreen(tontineId: Get.arguments),
      binding: TontineDetailBinding(),
    ),
    GetPage(
      name: Routes.myTontine,
      page: () => MyTontinesView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.joinScanner,
      page: () => const JoinScannerScreen(),
      binding: JoinScannerBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterStepScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
