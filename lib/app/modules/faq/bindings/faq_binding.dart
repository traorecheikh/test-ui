import 'package:get/get.dart';

import '../../../services/faq_service.dart';
import '../controllers/faq_controller.dart';

/// FAQ module binding for dependency injection
/// Follows the established pattern in your existing bindings
class FaqBinding extends Bindings {
  @override
  void dependencies() {
    // Register FAQ service as lazy singleton if not already registered
    if (!Get.isRegistered<FaqService>()) {
      Get.put<FaqService>(FaqService(), permanent: true);
    }

    // Register FAQ controller
    Get.lazyPut<FaqController>(
      () => FaqController(),
      fenix: true, // Allow recreation if needed
    );
  }
}