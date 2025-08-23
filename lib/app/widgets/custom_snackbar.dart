import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomSnackbar {
  static void show({
    required String message,
    String? title,
    bool success = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(Get.context!);
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 18,
      duration: duration,
      messageText: Row(
        children: [
          Lottie.asset(
            success
                ? 'assets/lottie/success.json'
                : 'assets/lottie/error.json',
            width: 44,
            height: 44,
            repeat: false,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
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