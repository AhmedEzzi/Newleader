import 'package:flutter/material.dart';

class ProductTheme {
  static const Color primaryColor = Color(0xFF6B4EFF);
  static const Color errorColor = Colors.red;
  static const Color favoriteColor = Colors.red;
  static const Color backgroundColor = Colors.white;

  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge ?? const TextStyle();

  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium ?? const TextStyle();

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    minimumSize: const Size(double.infinity, 50),
  );
}