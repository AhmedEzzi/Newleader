import 'package:flutter/material.dart';
import '../../../../core/utils/extension/translate_extension.dart';

class OTPTimer extends StatelessWidget {
  final int timerSeconds;
  final VoidCallback onResend;
  final bool isTablet;

  const OTPTimer({
    super.key,
    required this.timerSeconds,
    required this.onResend,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'didnt_receive_code'.tr(context),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        if (timerSeconds > 0)
          Row(
            children: [
              Text(
                'resend_in'.tr(context),
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                'timer_seconds_remaining'
                    .tr(context)
                    .replaceAll('{seconds}', timerSeconds.toString()),
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          )
        else
          TextButton(
            onPressed: onResend,
            child: Text(
              'resend'.tr(context),
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
