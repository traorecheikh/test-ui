import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:snt_ui_test/hive_registrar.g.dart';

import 'app/localization/app_translations.dart';
import 'app/modules/settings/controllers/settings_controller.dart';
import 'app/observers/app_lifecycle_observer.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/faq_service.dart';
import 'app/services/storage_service.dart';
import 'app/services/tontine_service.dart';
import 'app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('fr_FR', null);
  Hive.registerAdapters();
  await StorageService.init();
  await TontineService.init();

  // Initialize authentication service
  final authService = await AuthService.init();
  Get.put(authService);

  // Initialize FAQ service
  final faqService = FaqService();
  Get.put(faqService, permanent: true);

  Get.put(SettingsController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final settingsController = Get.find<SettingsController>();
          return GetMaterialApp(
            title: 'Sunutontine',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsController.darkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
            translations: AppTranslations(),
            locale: const Locale('fr', 'FR'),
            // locale: const Locale('wo', 'SN'),
            // locale: const Locale('wo', 'SN'),
            fallbackLocale: const Locale('en', 'US'),
            debugShowCheckedModeBanner: false,
            getPages: AppPages.routes,
            initialRoute: _getInitialRoute(),
            routingCallback: (routing) {
              // Reset authentication when navigating away from auth screens
              if (routing?.current != Routes.PIN_AUTH &&
                  routing?.current != Routes.PIN_SETUP) {
                final authService = Get.find<AuthService>();
                if (authService.needsAuthentication) {
                  // If auth is required but user is not on auth screen, redirect
                  Future.delayed(Duration.zero, () {
                    Get.offAllNamed(Routes.PIN_AUTH);
                  });
                }
              }
            },
          );
        });
      },
    );
  }

  String _getInitialRoute() {
    final authService = Get.find<AuthService>();

    // Check if authentication is required
    if (authService.needsAuthentication) {
      return Routes.PIN_AUTH;
    }

    return Routes.SPLASH;
  }
}
