import 'package:get/get.dart';
import '../controllers/pot_visual_controller.dart';

class PotVisualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PotVisualController>(
      () => PotVisualController(),
    );
  }
}