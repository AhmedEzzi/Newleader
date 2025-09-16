import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onExplorePressed;

  const CustomEmptyWidget({
    super.key,
    this.title = "no_products_available",
    this.subtitle = "we_are_curating_the_finest_selection",
    this.onExplorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shopping bag icon with neutral color
            const CustomImage(assetPath: AppSvgs.no_data,height: 80),
            const SizedBox(height: 32),
            
            // "No Products Available" title
            Text(
              title.tr(context),
             style: context.displayLarge?.copyWith(
               color: Colors.black,
               fontWeight: FontWeight.w100,
             ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Subtitle about curating collection
            Text(
              subtitle.tr(context),
              style: context.titleLarge?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 60),
            
            // "Explore Our Collection" button
            CustomButton(
              onPressed: onExplorePressed ?? () {
                Provider.of<LayoutProvider>(context,listen: false).currentIndex=0;
                AppRoutes.navigateTo(context, AppRoutes.mainLayoutScreen);
              },
              isOutlined: true,
              child: Text(
                'explore_our_collection'.tr(context),
                textAlign: TextAlign.center,
                style: context.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}