import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';

class SecondHomeImageWidget extends StatelessWidget {
  const SecondHomeImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: Stack(
              children: [
                // Original image/video
                Image.asset(
                  AppImages.second_home_banner_gif,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Color overlay
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
                // Elegant text overlay
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'welcome_to_excellence'.tr(context), // Replace with your text or use .tr() for translation
                          style: context.displayLarge!.copyWith(color: AppTheme.white,fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'discover_premium_quality_and_service'.tr(context), // Replace with your subtitle
                          style: context.headlineMedium!.copyWith(color: AppTheme.white.withValues(alpha: 0.5),fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}