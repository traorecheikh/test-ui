import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:snt_ui_test/hive_registrar.g.dart';

import 'app/modules/settings/controllers/settings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/tontine_service.dart';
import 'app/theme.dart';
import 'app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.deleteFromDisk();
  await Hive.deleteBoxFromDisk('user_box');
  print('Deleted user_box');
  await Hive.deleteBoxFromDisk('tontines_box');
  print('Deleted tontines_box');
  await Hive.deleteBoxFromDisk('contributions_box');
  print('Deleted contributions_box');
  await initializeDateFormatting('fr_FR', null);
  Hive.registerAdapters();
  await TontineService.init();
  Get.put(SettingsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    return ScreenUtilInit(
      designSize: kDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsController.themeMode,
            initialRoute: Routes.home,
            getPages: AppPages.routes,
            builder: (context, child) {
              // Ensure text scaling and accessibility
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
