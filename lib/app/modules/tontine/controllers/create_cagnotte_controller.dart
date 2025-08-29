
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/data/models/tontine.dart';
import 'package:snt_ui_test/app/services/storage_service.dart';
import 'package:snt_ui_test/app/services/tontine_service.dart';

class CreateCagnotteController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final maxParticipantsController = TextEditingController();

  void submitCagnotte() async {
    final user = StorageService.getCurrentUser();
    if (user == null) {
      // Handle user not found
      return;
    }

    await TontineService.createTontine(
      name: nameController.text,
      description: descriptionController.text,
      contributionAmount: double.tryParse(amountController.text) ?? 0,
      maxParticipants: int.tryParse(maxParticipantsController.text) ?? 0,
      organizerId: user.id,
      category: TontineCategory.cagnotte,
      // Provide default values for other required fields
      frequency: TontineFrequency.monthly, // Default value
      startDate: DateTime.now(), // Default value
      drawOrder: TontineDrawOrder.fixed, // Default value
      penaltyPercentage: 0, // Default value
    );

    Get.back(); // Go back after creation
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    maxParticipantsController.dispose();
    super.onClose();
  }
}
