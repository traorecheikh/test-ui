
import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/tontine/controllers/create_cagnotte_controller.dart';

class CreateCagnotteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCagnotteController>(() => CreateCagnotteController());
  }
}
