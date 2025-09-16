import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Creates a new color with the same RGB values but a modified alpha value
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.opacity,
    );
  }
} 