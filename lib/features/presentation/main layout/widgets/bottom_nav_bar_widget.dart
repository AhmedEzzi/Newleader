import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../controller/layout_provider.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, layoutProvider, _) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.white,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.lightSecondaryTextColor,
            currentIndex: layoutProvider.currentIndex,
            onTap: (int index) {
              if (index == 2 && AppStrings.token == null) {
                AppRoutes.navigateTo(context, AppRoutes.login);
                layoutProvider.setCurrentIndex(0);
                return;
              }
              layoutProvider.setCurrentIndex(index);
            },
            useLegacyColorScheme: false,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            enableFeedback: false,
            selectedFontSize: 12.0,
            unselectedFontSize: 10.0,
            selectedLabelStyle: context.titleSmall!.copyWith(fontWeight: FontWeight.w700,color: AppTheme.primaryColor),
            unselectedLabelStyle: context.bodySmall,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const CustomImage(assetPath: AppSvgs.home_icon),
                activeIcon: const CustomImage(assetPath: AppSvgs.active_home_icon),
                label: 'home'.tr(context).toUpperCase(),
              ),
              BottomNavigationBarItem(
                icon: const CustomImage(assetPath: AppSvgs.category_icon),
                activeIcon: const CustomImage(
                  assetPath: AppSvgs.active_category_icon,
                ),
                label: 'category'.tr(context).toUpperCase(),
              ),
              BottomNavigationBarItem(
                icon: const CustomImage(assetPath: AppSvgs.wishlist_icon),
                activeIcon: const CustomImage(
                  assetPath: AppSvgs.active_wishlist_icon,
                ),
                label: 'wishlist'.tr(context).toUpperCase(),
              ),
              BottomNavigationBarItem(
                icon: const CustomImage(assetPath: AppSvgs.cart_icon),
                activeIcon: const CustomImage(assetPath: AppSvgs.active_cart_icon),
                label: 'cart'.tr(context).toUpperCase(),
              ),
              BottomNavigationBarItem(
                icon: const CustomImage(assetPath: AppSvgs.profile_icon),
                activeIcon: const CustomImage(assetPath: AppSvgs.active_profile_icon),
                label: 'profile'.tr(context).toUpperCase(),
              ),
            ],
          ),
        );
      },
    );
  }
}
