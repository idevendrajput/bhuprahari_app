import 'package:flutter/foundation.dart';

class Logger {
  void printObj(dynamic obj) {
    if (kDebugMode) {
      print(obj.toString());
    }
  }

  void log(String message) {
    if (kDebugMode) {
      print("[LOG] $message");
    }
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print("[ERROR] $message");
      if (error != null) print("Error: $error");
      if (stackTrace != null) print("StackTrace: $stackTrace");
    }
  }

  // Add a debug method to match Log.debug usage
  static void debug(String message) {
    if (kDebugMode) {
      print("[DEBUG] $message");
    }
  }
}

// Global Log accessor
final Log = Logger();
