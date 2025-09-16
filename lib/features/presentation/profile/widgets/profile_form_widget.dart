import 'package:flutter/material.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';

class ProfileFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ProfileFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('name'.tr(context), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: nameController,
            hint: 'enter_name'.tr(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_name'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('new_password'.tr(context), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: passwordController,
            hint: 'enter_new_password'.tr(context),
            isPassword: true,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 6) {
                return 'password_length_error'.tr(context);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('confirm_password'.tr(context), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: confirmPasswordController,
            hint: 'reenter_password'.tr(context),
            isPassword: true,
            validator: (value) {
              if (passwordController.text.isNotEmpty && value != passwordController.text) {
                return 'passwords_not_match'.tr(context);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}