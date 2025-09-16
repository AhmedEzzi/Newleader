import 'package:flutter/material.dart';
import '../../../../core/utils/extension/translate_extension.dart';

enum PasswordStrength { weak, moderate, strong, veryStrong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  PasswordStrength _calculateStrength() {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.moderate;
    if (score <= 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  Color _getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.moderate:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.veryStrong:
        return Colors.green.shade700;
    }
  }

  String _getLabel(BuildContext context, PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'weak'.tr(context);
      case PasswordStrength.moderate:
        return 'moderate'.tr(context);
      case PasswordStrength.strong:
        return 'strong'.tr(context);
      case PasswordStrength.veryStrong:
        return 'very_strong'.tr(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();
    final color = _getColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${'password_strength'.tr(context)} ',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              _getLabel(context, strength),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: (strength.index + 1) / 4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
        if (strength == PasswordStrength.weak) ...[
          const SizedBox(height: 4),
          Text(
            'password_requirements'.tr(context),
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ],
    );
  }
}
