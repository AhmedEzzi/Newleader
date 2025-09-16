import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';

class SeeAllWidget extends StatelessWidget {
  const SeeAllWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,

          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w700,letterSpacing: 1.2),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            'see_all'.tr(context).toUpperCase(),
            style: context.titleLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w800
            ),
          ),
        ),
      ],
    );
  }
}