import 'package:get/get.dart';

import '../controllers/join_scanner_controller.dart';

class JoinScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinScannerController>(() => JoinScannerController());
  }
}
