import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../../core/config/themes.dart/theme.dart';

class SummerDealsWidgets extends StatelessWidget {
  const SummerDealsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha: 0.7),
                        AppTheme.primaryColor.withValues(alpha: 0.5),
                      ],
                      stops: const [0.4, 0.7, 0.99],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('summer_sale'.tr(context),
                        style: context.headlineMedium.copyWith(
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('up_to_40_off'.tr(context),
                        style: context.titleSmall.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImage(
                  assetPath: AppImages.summers_deals_image,
                  fit: BoxFit.cover,
                  height: 140,
                  borderRadius: BorderRadius.circular(15),
                ),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'new_arrival'.tr(context),
                        style: context.headlineMedium.copyWith(
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'shop_now'.tr(context),
                        style: context.titleMedium.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
