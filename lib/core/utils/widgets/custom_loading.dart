import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';

class CustomLoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const CustomLoadingWidget({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitSquareCircle(
      color: color ?? AppTheme.primaryColor,
      size: width ?? 30.0, // Default size if width is not provided
    );
  }
}
