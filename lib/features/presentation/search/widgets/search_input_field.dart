import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback? onClear;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      textInputAction: TextInputAction.search,
      suffixIcon: InkWell(
          onTap: (){
            controller.clear();
            onChanged('');
            if (onClear != null) {
              onClear!();
            }
          },
          child: const Icon(Icons.close,color: AppTheme.accentColor)),
      hint: 'search_products'.tr(context),
      onChanged: onChanged,
      isBorderAvailable: false,
      onFieldSubmitted: onSubmitted,
    );
  }
}