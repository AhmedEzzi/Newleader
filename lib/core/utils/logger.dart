import 'package:flutter/foundation.dart';
import '../config/app_config.dart/app_config.dart';

/// A simple logging utility for the application
class Logger {
  static final AppConfig _appConfig = AppConfig();

  /// Log a debug message
  static void d(String tag, String message) {
    if (_appConfig.enableLogging && !kReleaseMode) {
      debugPrint('DEBUG: [$tag] $message');
    }
  }

  /// Log an info message
  static void i(String tag, String message) {
    if (_appConfig.enableLogging && !kReleaseMode) {
      debugPrint('INFO: [$tag] $message');
    }
  }

  /// Log a warning message
  static void w(String tag, String message) {
    if (_appConfig.enableLogging && !kReleaseMode) {
      debugPrint('WARN: [$tag] $message');
    }
  }

  /// Log an error message
  static void e(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (_appConfig.enableLogging) {
      debugPrint('ERROR: [$tag] $message');
      if (error != null) {
        debugPrint('ERROR DETAILS: $error');
      }
      if (stackTrace != null) {
        debugPrint('STACK TRACE: $stackTrace');
      }
    }
  }
}