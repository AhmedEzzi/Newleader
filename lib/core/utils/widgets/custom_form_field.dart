import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';

import '../vaidation/phone_validator.dart';


class CustomTextFormField extends StatefulWidget {

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final bool isMobileNumber;
  final bool isReadOnly;
  final bool autoFocus;
  final bool isBorderAvailable;  // New parameter to control border visibility
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.isPassword = false,
    this.isMobileNumber = false,
    this.isReadOnly = false,
    this.autoFocus = false,
    this.isBorderAvailable = true,  // Default to having borders
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textStyle,
    this.borderRadius = 25.0,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? _errorText;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
    _obscureText = widget.isPassword;
  }

  String? _validateInput(String? value, BuildContext context) {
    // Check for mobile number validation
    if (widget.isMobileNumber) {
      final mobileError = PhoneValidation.validateMobileNumber(value, context);
      if (mobileError != null) {
        setState(() {
          _errorText = mobileError;
        });
        return mobileError;
      }
    }

    // Apply custom validator if provided
    if (widget.validator != null) {
      final customError = widget.validator!(value);
      if (customError != null) {
        setState(() {
          _errorText = customError;
        });
        return customError;
      }
    }

    // If we reach here, there are no validation errors
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
    
    // Return null when valid (this is what Flutter form validation expects)
    return null;
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create password visibility toggle icon if it's a password field
    Widget? passwordSuffixIcon = widget.isPassword
        ? IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: AppTheme.darkDividerColor,
      ),
      onPressed: _togglePasswordVisibility,
    )
        : widget.suffixIcon;

    // Determine fill color based on isBorderAvailable
    Color fillColor = widget.isBorderAvailable
        ? Colors.white
        : AppTheme.darkTextColor;
        
    // Get the directionality from context for RTL support
    final textDirection = Directionality.of(context);
    final isRTL = textDirection == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,  // Use the _obscureText state
        readOnly: widget.isReadOnly,
        autofocus: widget.autoFocus,
        keyboardType: widget.isMobileNumber ? TextInputType.phone : widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        style: widget.textStyle ?? context.titleMedium,
        textDirection: textDirection, // Apply text direction based on locale
        textAlign: isRTL ? TextAlign.right : TextAlign.left, // Align text based on direction
        inputFormatters: widget.isMobileNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: _errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: passwordSuffixIcon,  // Use our custom suffix icon for password fields
          labelStyle: context.bodyMedium?.copyWith(color: AppTheme.lightSecondaryTextColor),
          hintStyle: context.titleMedium?.copyWith(color: AppTheme.lightSecondaryTextColor),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          // Apply alignment and direction to hint text as well
          alignLabelWithHint: true,
          hintTextDirection: textDirection,
          enabledBorder: widget.isBorderAvailable
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: AppTheme.darkDividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
          )
              : OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,  // No border
          ),
          focusedBorder: widget.isBorderAvailable
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 1.5,
            ),
          )
              : OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,  // No border
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: (value) {
          // This ensures we're using the most recent context during validation
          return _validateInput(value, context);
        },
      ),
    );
  }
}