import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_button.dart';

class EmptyAddressWidget extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressWidget({super.key, required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomImage(assetPath: AppSvgs.location_icon,height: 200,width: 200),
          const SizedBox(height: 16),
          Text(
            'no_addresses_found'.tr(context),
            style: context.headlineSmall
          ),
          const SizedBox(height: 8),
          Text(
            'add_address_to_continue'.tr(context),
            style: context.titleSmall?.copyWith(color: AppTheme.darkDividerColor)
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'add_new_address'.tr(context),
            onPressed: onAddAddress,
            textStyle: context.titleMedium?.copyWith(color: AppTheme.white),
          ),
        ],
      ),
    );
  }
}
