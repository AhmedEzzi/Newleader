import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/language_switcher.dart';
import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/extension/text_theme_extension.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../auth/controller/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../club_point/controller/club_point_provider.dart';
import '../controller/profile_provider.dart';
import '../../../../core/utils/widgets/premium_language_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final bool isActive;
  const ProfileScreen({super.key, this.isActive = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    _shouldAnimate = widget.isActive;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      profileProvider.getUserProfile();
      profileProvider.getProfileCounters();

      if (AppStrings.token != null) {
        context.read<ClubPointProvider>().fetchClubPoints();
      }
    });
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      setState(() {
        _shouldAnimate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppStrings.token != null;
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: isLoggedIn 
            ? _buildLoggedInLayout(context, profileProvider) 
            : _buildGuestLayout(context),
      ),
    );
  }

  // تصميم جديد للمستخدم غير المسجل
  Widget _buildGuestLayout(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAFAFA),
            Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Hero Section with Brand Logo
            _shouldAnimate
                ? FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: _buildHeroSection(context),
                  )
                : _buildHeroSection(context),

            const SizedBox(height: 60),

            // Auth Buttons
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: _buildAuthButtons(context),
                  )
                : _buildAuthButtons(context),

            const SizedBox(height: 32),

            // Menu Items
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 600),
                    child: _buildGuestMenuSection(context),
                  )
                : _buildGuestMenuSection(context),

            const SizedBox(height: 32),

            // Social Media Section
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 600),
                    child: _buildSocialSection(context),
                  )
                : _buildSocialSection(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // تصميم جديد للمستخدم المسجل
  Widget _buildLoggedInLayout(BuildContext context, ProfileProvider profileProvider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAFAFA),
            Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Modern User Header with Gradient Background
            _shouldAnimate
                ? FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: _buildModernUserHeader(context, profileProvider),
                  )
                : _buildModernUserHeader(context, profileProvider),

            const SizedBox(height: 15),

            // Dashboard Cards
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: _buildDashboardCards(context),
                  )
                : _buildDashboardCards(context),

            const SizedBox(height: 24),

            // Account Management Section
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: _buildAccountManagement(context),
                  )
                : _buildAccountManagement(context),

            const SizedBox(height: 24),

            // Contact & Support Section
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 600),
                    child: _buildContactSupport(context),
                  )
                : _buildContactSupport(context),

            const SizedBox(height: 24),

            // Logout Button
            _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 600),
                    child: _buildModernLogoutButton(context),
                  )
                : _buildModernLogoutButton(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Hero Section for Guest Users
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CustomImage(assetPath: AppImages.appLogo,),
                ),
                const SizedBox(height: 16),
                Text(
                  'leader_company'.tr(context),
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAuthButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CustomButton(
              onPressed: () {
                AppRoutes.navigateTo(context, AppRoutes.login);
              },
              fullWidth: true,
              child: Text(
                'sign_in'.tr(context),
                textAlign: TextAlign.center,
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () {
              AppRoutes.navigateTo(context, AppRoutes.signUp);
            },
            fullWidth: true,
            isOutlined: true,
            child: Text(
              'create_account'.tr(context),
              textAlign: TextAlign.center,
              style: context.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // _buildMenuTile(
          //   context: context,
          //   icon: Icons.help_outline,
          //   title: 'help_support'.tr(context),
          //   onTap: () => _launchUrl('https://melaminefront.dokkan.design/pages/contact-us'),
          //   isFirst: true,
          // ),
          _buildMenuTile(
            context: context,
            icon: Icons.info_outline,
            title: 'about_us'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/pages/about-us'),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.web,
            title: 'visit_website'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/'),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.phone_outlined,
            title: 'contact_us'.tr(context),
            onTap: _makePhoneCall,
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.assignment_return,
            title: 'return_exchange_policy'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/pages/return-policy'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'follow_us_social'.tr(context),
            style: context.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(icon: AppSvgs.whatsapp, onTap: _openWhatsApp),
              _buildSocialButton(icon: AppSvgs.call, onTap: _makePhoneCall),
              _buildSocialButton(icon: AppSvgs.facebook, onTap: _openFacebook),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernUserHeader(BuildContext context, ProfileProvider profileProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Pattern
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: profileProvider.profileImageUrl != null
                        ? CustomImage(
                            imageUrl: profileProvider.profileImageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.userName ?? '',
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.userEmail ?? '',
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => AppRoutes.navigateTo(context, AppRoutes.editProfileScreen),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'edit_profile'.tr(context),
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profileCounters = profileProvider.profileCounters;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildDashboardCard(
            context: context,
            icon: Icons.shopping_bag_outlined,
            title: 'my_orders'.tr(context),
            subtitle: profileCounters?.orderCount != null
                ? '${profileCounters!.orderCount} ${'orders'.tr(context)}'
                : 'my_orders'.tr(context),
            gradient: [const Color(0xFF4CAF50), const Color(0xFF4CAF50).withValues(alpha: 0.8)],
            onTap: () => AppRoutes.navigateTo(context, AppRoutes.allOrdersListScreen),
          ),
          _buildDashboardCard(
            context: context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'my_wallet'.tr(context),
            subtitle: ''.tr(context),
            gradient: [const Color(0xFF2196F3), const Color(0xFF2196F3).withValues(alpha: 0.8)],
            onTap: () => AppRoutes.navigateTo(context, AppRoutes.walletScreen),
          ),
          _buildDashboardCard(
            context: context,
            icon: Icons.location_on_outlined,
            title: 'shipping_address'.tr(context),
            subtitle: ''.tr(context),
            gradient: [const Color(0xFFFF9800), const Color(0xFFFF9800).withValues(alpha: 0.8)],
            onTap: () => AppRoutes.navigateTo(context, AppRoutes.addressListScreen),
          ),
          _buildDashboardCard(
            context: context,
            icon: Icons.favorite_outline,
            title: 'saved_items'.tr(context),
            subtitle: profileCounters?.wishlistItemCount != null
                ? '${profileCounters!.wishlistItemCount} ${'item'.tr(context)}'
                : 'saved_items'.tr(context),
            gradient: [const Color(0xFFE91E63), const Color(0xFFE91E63).withValues(alpha: 0.8)],
            onTap: () => Provider.of<LayoutProvider>(context, listen: false).currentIndex = 2,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagement(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context: context,
            icon: Icons.language,
            title: 'change_language'.tr(context),
            onTap: () => LanguageDialog.show(context),
            isFirst: true,
          ),
          // _buildMenuTile(
          //   context: context,
          //   icon: Icons.help_outline,
          //   title: 'help_support'.tr(context),
          //   onTap: () => _launchUrl('https://melaminefront.dokkan.design/pages/contact-us'),
          // ),
          _buildMenuTile(
            context: context,
            icon: Icons.info_outline,
            title: 'about_us'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/pages/about-us'),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.web,
            title: 'visit_website'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/'),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.assignment_return,
            title: 'return_exchange_policy'.tr(context),
            onTap: () => _launchUrl('https://leadercompany-eg.com/pages/return-policy'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'contact_and_follow'.tr(context),
            style: context.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildContactButton(
                context: context,
                icon: AppSvgs.whatsapp,
                title: 'whatsapp_contact'.tr(context),
                onTap: _openWhatsApp,
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildContactButton(
                context: context,
                icon: AppSvgs.call,
                title: 'phone_contact'.tr(context),
                onTap: _makePhoneCall,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildContactButton(
                context: context,
                icon: AppSvgs.facebook,
                title: 'facebook_contact'.tr(context),
                onTap: _openFacebook,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color:  AppTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _showLogoutConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'logout'.tr(context),
                  style: context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 20 : 0),
        topRight: Radius.circular(isFirst ? 20 : 0),
        bottomLeft: Radius.circular(isLast ? 20 : 0),
        bottomRight: Radius.circular(isLast ? 20 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(icon, width: 28, height: 28),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(height: 10),
            Text(
              title,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  void _showLogoutConfirmation(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      title: 'logout'.tr(context),
      message: 'confirm_logout'.tr(context),
      confirmText: 'logout'.tr(context),
      cancelText: 'cancel'.tr(context),
      confirmButtonColor: AppTheme.primaryColor,
      icon: Icons.logout,
      onConfirm: () async {
        await context.read<AuthProvider>().logout();
        AppStrings.userId = null;
        AppStrings.token = null;
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('could_not_launch_website'.tr(context))),
        );
      }
    }
  }

  Future<void> _launchYouTube() async {
    await _launchUrl('https://www.youtube.com/watch?v=aQSHPRcZdrA');
  }

  Future<void> _openFacebook() async {
    await _launchUrl('https://www.facebook.com/skyeg.egypt');
  }

  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse('tel:01114719245');
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('could_not_make_call'.tr(context))),
        );
      }
    }
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '201114719245';
    final url = Uri.parse('https://wa.me/$phoneNumber');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('could_not_open_whatsapp'.tr(context))),
        );
      }
    }
  }
}
