import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_service.dart';

/// Middleware to handle authentication checks
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    // If user needs authentication and trying to access protected routes
    if (authService.needsAuthentication && route != Routes.PIN_AUTH) {
      return const RouteSettings(name: Routes.PIN_AUTH);
    }

    return null;
  }
}

/// Auth guard for protecting routes
class AuthGuard {
  static bool isAuthenticated() {
    try {
      final authService = Get.find<AuthService>();
      return !authService.needsAuthentication;
    } catch (e) {
      return false;
    }
  }

  static void checkAuth() {
    if (!isAuthenticated()) {
      Get.offAllNamed(Routes.PIN_AUTH);
    }
  }
}
