import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_service.dart';

/// Middleware to handle authentication checks for protected routes
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    // If authentication is required and user is not authenticated
    if (authService.needsAuthentication) {
      return RouteSettings(name: Routes.PIN_AUTH);
    }

    return null;
  }
}
