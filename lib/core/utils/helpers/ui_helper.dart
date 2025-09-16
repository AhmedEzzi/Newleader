import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class for UI-related utilities
class UIHelper {
  /// Set the status bar to be transparent with dark icons
  /// This is useful for light-colored backgrounds
  static void setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  /// Set the status bar to be transparent with light icons
  /// This is useful for dark-colored backgrounds
  static void setTransparentStatusBarWithLightIcons() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  /// Wraps a widget with an AnnotatedRegion to ensure system UI overlay styles
  /// are properly applied throughout the widget's lifecycle
  static Widget wrapWithStatusBarConfig(
    Widget child, {
    bool useDarkIcons = true,
  }) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: useDarkIcons ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: useDarkIcons ? Brightness.dark : Brightness.light,
      ),
      child: child,
    );
  }
} 