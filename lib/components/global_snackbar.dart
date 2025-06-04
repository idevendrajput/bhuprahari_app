import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/responsive.dart' as $appUtils; // For $styles, $appUtils, $strings

class GlobalSnackbarHelper {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(String title, String message) {
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          // Using standard Text widget
          content: Text(
            message,
            style: TextStyle(
              color: $styles.colors.white,
              fontSize: $appUtils.sizing(14.0, scaffoldMessengerKey.currentContext!), // Use $appUtils.sizing
            ),
          ),
          backgroundColor: $styles.colors.primary, // Or adjust color based on title (success/error)
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all($appUtils.sizing(10.0, scaffoldMessengerKey.currentContext!)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      print("Snackbar requested but ScaffoldMessengerState not available: $message");
    }
  }
}
