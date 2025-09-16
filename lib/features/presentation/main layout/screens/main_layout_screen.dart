import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../controller/layout_provider.dart';
import '../widgets/drawer_widget.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => MainLayoutScreenState();
}

class MainLayoutScreenState extends State<MainLayoutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double _maxSlideAmount = 0.8;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  List<TabItem> _getTabItems(BuildContext context) {
    return [
      TabItem(
        icon: Icons.home_outlined,
        title: 'home'.tr(context),
      ),
      TabItem(
        icon: Icons.category_outlined,
        title: 'category'.tr(context),
      ),
      TabItem(
        icon: Icons.favorite_border,
        title: 'wishlist'.tr(context),
      ),
      TabItem(
        icon: Icons.shopping_cart_outlined,
        title: 'cart'.tr(context),
      ),
      TabItem(
        icon: Icons.person_outline,
        title: 'profile'.tr(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<LayoutProvider>(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideAmount = screenWidth * _maxSlideAmount * _animationController.value;
        final contentScale = 1.0 - (0.2 * _animationController.value);
        final cornerRadius = 20.0 * _animationController.value;

        return Stack(
          children: [
            // Drawer
             DrawerWidget(animationController: _animationController,),

            // Main content with animation
            Transform(
              transform: Matrix4.identity()
                ..translate(slideAmount)
                ..scale(contentScale),
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cornerRadius),
                child: GestureDetector(
                  onTap: _animationController.isCompleted ? () => toggleDrawer() : null,
                  child: _buildMainContent(context, provider),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build the main content
  Widget _buildMainContent(BuildContext context, LayoutProvider provider) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppTheme.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: provider.currentIndex,
        children: provider.mainScreens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomBarInspiredInside(
          items: _getTabItems(context),
          backgroundColor: Colors.white,
          color: Colors.grey.shade600,
          colorSelected: Colors.white,
          indexSelected: provider.currentIndex,
          onTap: (int index) {
            if (index == 2 && AppStrings.token == null) {
              AppRoutes.navigateTo(context, AppRoutes.login);
            } else {
              provider.setCurrentIndex(index);
            }
          },
          animated: true,
          itemStyle: ItemStyle.hexagon,
          chipStyle: const ChipStyle(
            isHexagon: true,
            convexBridge: true,
            background: AppTheme.primaryColor,
          ),
          titleStyle: context.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          iconSize: 22,
          height: 45,
        ),
      ),
    );
  }
}