import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger();

  void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARNING] $message');
    }
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) {
        debugPrint(error.toString());
      }
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }
}
