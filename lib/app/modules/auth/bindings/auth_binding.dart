import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/auth/controllers/login_controller.dart';

import '../controllers/otp_controller.dart';
import '../controllers/register_step_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
    Get.lazyPut<RegisterStepController>(
      () => RegisterStepController(),
      fenix: true,
    );
  }
}
