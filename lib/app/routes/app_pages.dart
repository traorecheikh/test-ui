import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/onboarding_screen.dart';
import '../modules/home/views/splash_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_screen.dart';
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
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
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
    ),
    GetPage(
      name: Routes.detail,
      page: () => TontineDetailScreen(tontineId: Get.arguments),
      binding: TontineDetailBinding(),
    ),
  ];
}
