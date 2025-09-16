import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPInput extends StatelessWidget {
  final TextEditingController controller;
  final int otpLength;
  final bool hasError;
  final Function(String) onChanged;
  final bool isTablet;

  const OTPInput({
    super.key,
    required this.controller,
    required this.otpLength,
    required this.hasError,
    required this.onChanged,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 16),
          child: PinCodeTextField(
            appContext: context,
            length: otpLength,
            controller: controller,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: isTablet ? 64 : 56,
              fieldWidth: isTablet ? 64 : 56,
              activeFillColor:
                  hasError ? Colors.red.shade100 : theme.colorScheme.surface,
              inactiveFillColor: theme.colorScheme.surface,
              selectedFillColor: theme.colorScheme.surface,
              activeColor: hasError ? Colors.red : theme.primaryColor,
              inactiveColor: theme.dividerColor,
              selectedColor: theme.primaryColor,
            ),
            cursorColor: theme.primaryColor,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: hasError ? 1 : 0,
          child: Text(
            'please_enter_valid_code'.tr(context),
            style: TextStyle(color: Colors.red, fontSize: isTablet ? 14 : 12),
          ),
        ),
      ],
    );
  }
}
