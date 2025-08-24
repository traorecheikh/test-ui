import 'package:get/get.dart';

import '../controllers/join_tontine_controller.dart';

class JoinTontineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinTontineController>(() => JoinTontineController());
  }
}
