import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import '../../../../core/config/themes.dart/theme.dart';

class BrandHeaderWidget extends StatelessWidget {
  const BrandHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Brand Logo Icon (optional)
            const CustomImage(assetPath: AppImages.appLogo,height: 60,width: 60,),
            const SizedBox(width: 8),
            
            // Brand Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'app_name'.tr(context),
                  style: context.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'subtitle_app_name'.tr(context),
                  style: context.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
                onTap: (){
                  AppRoutes.navigateTo(context, AppRoutes.searchScreen);
                },
                child: const Icon(Icons.search,size: 26,color: AppTheme.primaryColor))
          ],
        ),
      ),
    );
  }
} 