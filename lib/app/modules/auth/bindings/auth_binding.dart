import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/auth/controllers/login_controller.dart';
import 'package:snt_ui_test/app/modules/auth/controllers/otp_controller.dart';
import 'package:snt_ui_test/app/modules/auth/controllers/register_step_controller.dart';

import '../../../services/auth_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<RegisterStepController>(
      () => RegisterStepController(),
      fenix: true,
    );
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
  }
}
