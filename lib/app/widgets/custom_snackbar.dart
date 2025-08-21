import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String message,
    String? title,
    bool success = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 18,
      duration: duration,
      messageText: Row(
        children: [
          // Lottie.asset(
          //   success ? 'assets/lottie/success.json' : 'assets/lottie/error.json',
          //   width: 44,
          //   height: 44,
          //   repeat: false,
          // ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      padding: const EdgeInsets.all(12),
      isDismissible: true,
    );
  }
}
