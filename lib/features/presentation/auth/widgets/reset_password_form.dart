import 'package:flutter/material.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import 'password_strength_indicator.dart';

class ResetPasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ResetPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: widget.passwordController,
            hint: 'new_password'.tr(context),
            prefixIcon: const Icon(Icons.lock_outline),
            isPassword: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_new_password'.tr(context);
              } else if (value.length < 8) {
                return 'password_min_length'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PasswordStrengthIndicator(password: widget.passwordController.text),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: widget.confirmPasswordController,
            hint: 'confirm_password'.tr(context),
            prefixIcon: const Icon(Icons.lock_outline),
            isPassword: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_confirm_password'.tr(context);
              } else if (value != widget.passwordController.text) {
                return 'passwords_not_match'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'reset_password'.tr(context),
            onPressed: widget.onSubmit,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: 20),
          SecurityNotice(),
        ],
      ),
    );
  }
}

class SecurityNotice extends StatelessWidget {
  const SecurityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.indigo[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'password_security_notice'.tr(context),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
