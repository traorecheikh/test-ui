import 'package:get/get.dart';
import '../controllers/create_tontine_controller.dart';

class CreateTontineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTontineController>(() => CreateTontineController());
  }
}
