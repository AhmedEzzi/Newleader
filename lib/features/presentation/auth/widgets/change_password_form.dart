import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import 'password_strength_indicator.dart';

class ChangePasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ChangePasswordForm({
    super.key,
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: widget.currentPasswordController,
            hint: 'current_password'.tr(context),
            prefixIcon: const Icon(Icons.lock_outline),
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_current_password'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: widget.newPasswordController,
            hint: 'new_password'.tr(context),
            prefixIcon: const Icon(Icons.lock_outline),
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_new_password'.tr(context);
              } else if (value.length < 8) {
                return 'password_min_length'.tr(context);
              } else if (value == widget.currentPasswordController.text) {
                return 'new_password_must_be_different'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PasswordStrengthIndicator(
            password: widget.newPasswordController.text,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: widget.confirmPasswordController,
            hint: 'confirm_password'.tr(context),
            prefixIcon: const Icon(Icons.lock_outline),
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_confirm_password'.tr(context);
              } else if (value != widget.newPasswordController.text) {
                return 'passwords_not_match'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'change_password'.tr(context),
            onPressed: widget.onSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
