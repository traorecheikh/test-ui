import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class JoinScannerController extends GetxController {
  late final MobileScannerController scannerController;
  final RxBool cameraGranted = false.obs;
  final RxBool permissionChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(facing: CameraFacing.back);
    checkCameraPermission();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  /// Checks and requests camera permission, updates state accordingly.
  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.request();
    cameraGranted.value = status.isGranted;
    permissionChecked.value = true;
  }

  /// Handles barcode detection and join logic.
  void onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      Get.back(result: barcode.rawValue);
    }
  }
}
