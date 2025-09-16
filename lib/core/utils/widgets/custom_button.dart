import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../config/themes.dart/theme.dart';
import 'custom_loading.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final String? icon;
  final Color? splashColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final double? loadingIndicatorSize;
  final bool isOutlined;
  final bool fullWidth; // Added parameter for full width
  final List<Color>? gradientColors; // Allow custom gradient colors
  final double? height; // New parameter for custom height

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.splashColor,
    this.borderColor=AppTheme.accentColor,
    this.padding,
    this.elevation,
    this.onPressed,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.loadingIndicatorSize = 24.0,
    this.icon,
    this.isOutlined = false,
    this.fullWidth = false,
    this.gradientColors,
    this.height,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? AppTheme.primaryColor;
    final effectiveTextColor = isOutlined
        ? textColor ?? buttonColor
        : textColor ?? AppTheme.white;

    // Default gradient colors if not provided
    final colors = gradientColors ?? [
       AppTheme.primaryColor, // Darker reddish color
      AppTheme.secondaryColor, // Lighter pinkish color
    ];

    // Return original button style if not gradient
    return Material(
      color: isOutlined ? Colors.transparent : buttonColor,
      elevation: isOutlined ? 0 : (elevation ?? 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
        side: BorderSide(color: this.borderColor!, width: 0.5),
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        splashColor: splashColor ?? AppTheme.primaryColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: height??44,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            gradient: isOutlined
                ? null
                : LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
          ),
          child: isLoading
              ? const Center(
                  child: CustomLoadingWidget(),
                )
              : _buildContent(context, effectiveTextColor),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor) {
    if (child != null) {
      return child!;
    }

    return Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min, // Adjust mainAxisSize based on fullWidth
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          CustomImage(
            assetPath: icon!,
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text!,
          style: textStyle ??
              context.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}