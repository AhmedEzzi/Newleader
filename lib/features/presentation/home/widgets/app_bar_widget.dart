import 'package:flutter/material.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import '../../main layout/controller/layout_provider.dart';
import '../../../presentation/cart/controller/cart_provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {

  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leadingWidth: double.infinity,
      scrolledUnderElevation: 0,
      leading: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 15),
          CustomImage(
            assetPath: AppImages.linearAppLogo,
            width: 130,
            height: 100,
            fit: BoxFit.contain,
          ),

        ],
      ),
      actions: [
        InkWell(
          child: const CustomImage(
            assetPath: AppSvgs.search_icon,
          ),
          onTap: () {
            AppRoutes.navigateTo(context, AppRoutes.searchScreen);
          },
        ),
        const SizedBox(width: 15),
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Badge(
              label: Text(cart.cartCount.toString()),
              isLabelVisible: cart.cartCount > 0,
              child: InkWell(
                child: const CustomImage(
                  assetPath: AppSvgs.cart_icon,
                ),
                onTap: () {
                  Provider.of<LayoutProvider>(context, listen: false).currentIndex = 3;
                },
              ),
            );
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}