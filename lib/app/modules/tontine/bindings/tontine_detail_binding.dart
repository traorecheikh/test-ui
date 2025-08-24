import 'package:get/get.dart';

import '../controllers/tontine_detail_controller.dart';

class TontineDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TontineDetailController>(() => TontineDetailController());
  }
}
