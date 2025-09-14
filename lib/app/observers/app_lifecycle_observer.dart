import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_service.dart';

/// App lifecycle observer to handle authentication state changes
class AppLifecycleObserver extends WidgetsBindingObserver {
  final AuthService _authService = Get.find<AuthService>();
  DateTime? _backgroundTime;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App is going to background
        _backgroundTime = DateTime.now();
        break;

      case AppLifecycleState.resumed:
        // App is coming back to foreground
        _handleAppResumed();
        break;

      case AppLifecycleState.detached:
        // App is being terminated
        _authService.logout();
        break;

      case AppLifecycleState.hidden:
        // App is hidden (iOS specific)
        break;
    }
  }

  void _handleAppResumed() {
    // If authentication is required and app was in background
    if (_authService.isAuthRequired && _backgroundTime != null) {
      final timeDifference = DateTime.now().difference(_backgroundTime!);

      // If app was in background for more than 30 seconds, require re-authentication
      if (timeDifference.inSeconds > 30) {
        _authService.logout();

        // Navigate to PIN auth screen if not already there
        if (Get.currentRoute != Routes.PIN_AUTH) {
          Get.offAllNamed(Routes.PIN_AUTH);
        }
      }
    }

    _backgroundTime = null;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
