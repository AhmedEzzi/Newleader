import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  const CustomOutlinedButton({
    super.key,
    required this.child, // Accepts any widget
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.borderRadius = 20, // Default rounded corner
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
    this.borderWidth = 2, // Default border width
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor ?? Theme.of(context).primaryColor,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        foregroundColor: textColor ?? Theme.of(context).primaryColor,
      ),
      child: child, // Accepts any widget
    );
  }
}
