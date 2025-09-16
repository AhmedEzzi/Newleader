import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/features/presentation/auth/controller/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../profile/controller/profile_provider.dart';
import '../controller/layout_provider.dart';

class DrawerWidget extends StatelessWidget {
  final  AnimationController animationController;

  const DrawerWidget({super.key, required this.animationController});

  void toggleDrawer() {
    if (animationController.isDismissed) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
  @override
  Widget build(BuildContext context) {
    final layoutProvider = Provider.of<LayoutProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Material(
      color: const Color(0xFF1E88E5),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              Center(
                child: Column(
                  children: [
                    profileProvider.profileImageUrl != null
                        ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(
                            profileProvider.profileImageUrl!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage(AppImages.appLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.userName ?? 'guest_user'.tr(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Menu items
              _buildMenuItem(
                context,
                Icons.person_outline,
                'explore',
                onTap: () {
                  layoutProvider.setCurrentIndex(0);
                  toggleDrawer();
                },
              ),
              const SizedBox(height: 20),
              AppStrings.token!=null? _buildMenuItem(
                context,
                Icons.person_outline,
                'profile',
                onTap: () {
                  layoutProvider.setCurrentIndex(3);
                  toggleDrawer();
                },
              ):SizedBox.shrink(),
              const SizedBox(height: 20),

              _buildMenuItem(
                context,
                Icons.shopping_cart_outlined,
                'my_cart'.tr(context),
                onTap: () {
                  AppRoutes.navigateTo(context, AppRoutes.cartScreen);
                },
              ),
              const SizedBox(height: 20),

              AppStrings.token != null
                  ? _buildMenuItem(
                context,
                Icons.favorite_border,
                'my_wishlist',
                onTap: () {
                  layoutProvider.setCurrentIndex(2);
                  toggleDrawer();
                },
              )
                  : SizedBox.shrink(),
              const SizedBox(height: 20),

              AppStrings.token != null
                  ? _buildMenuItem(
                context,
                Icons.local_shipping_outlined,
                'orders',
                onTap: () {
                  AppRoutes.navigateTo(
                    context,
                    AppRoutes.allOrdersListScreen,
                  );
                },
              )
                  : SizedBox.shrink(),

              // Divider
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(color: Colors.white, thickness: 1),
              ),

              // Sign out at the bottom
              const Spacer(),
              AppStrings.token!=null? _buildMenuItem(
                context,
                Icons.logout,
                'sign_out',
                onTap: () async {
                 await Provider.of<AuthProvider>(context,listen: false).logout();
                 layoutProvider.setCurrentIndex(0);
                 toggleDrawer();
                },
              ):_buildMenuItem(
                context,
                Icons.login,
                'login',
                onTap: () async {
                  AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.tr(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
