import 'package:flutter/material.dart';

import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_cached_image.dart';

class TopHomeWidget extends StatefulWidget {
  final VoidCallback? onShopNowTapped;
  const TopHomeWidget({super.key, this.onShopNowTapped});

  @override
  State<TopHomeWidget> createState() => _TopHomeWidgetState();
}

class _TopHomeWidgetState extends State<TopHomeWidget> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: screenSize.height * 0.25, // Increase height to 45% of screen
              width: double.infinity,
              child: Stack(
                children: [
                  // Image with color filter
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const CustomImage(
                      assetPath: AppImages.home_banner,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Bottom gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: screenSize.height * 0.45,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'limited_time_offers'.tr(context),
                style: context.displaySmall!.copyWith(
                    color: AppTheme.white
                ),
              ),
              Text(
                'elevate_your_kitchen'.tr(context),
                style: context.titleLarge!.copyWith(
                    color: AppTheme.white
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
