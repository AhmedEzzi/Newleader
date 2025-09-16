import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../core/config/routes.dart/routes.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/providers/localization/language_provider.dart';
import '../../../core/utils/local_storage/local_storage_keys.dart';
import '../../../core/utils/local_storage/secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkNavigationPath();
  }

  void _setupAnimations() {
    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define the Tween for the image size
    _sizeAnimation = Tween<double>(begin: 100.0, end: 240.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation with repeat and reverse
    _controller.repeat(reverse: true);
  }

  Future<void> _checkNavigationPath() async {
    // Delay to allow animations to complete
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final secureStorage = sl<SecureStorage>();
    final hasCompletedOnboarding = await secureStorage.get<bool>(LocalStorageKey.hasCompletedOnboarding) ?? false;

    if (!hasCompletedOnboarding) {
      // First time: Navigate to onboarding
      AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.onboarding);
    } else {
      // Already logged in: Navigate to home
      AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppTheme.white,
            statusBarIconBrightness: Brightness.dark
        ),
      ),
      backgroundColor: Colors.white,
      body: splashScreen(),
    );
  }

  Widget splashScreen() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Center logo with size animation
        Align(
          alignment: AlignmentDirectional.center,
          child: AnimatedBuilder(
            animation: _sizeAnimation,
            builder: (context, child) {
              return SizedBox(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                child: child,
              );
            },
            child: const CustomImage(
              assetPath: AppImages.logoSplash,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Bottom dokkan logo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                '2025_powered_by_dokkan_agency'.tr(context),
                textStyle: context.displaySmall.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                colors: [
                  Colors.grey[600]!,
                  AppTheme.primaryColor,
                  AppTheme.accentColor,
                  Colors.grey[600]!,
                ],
                textAlign: TextAlign.center,
                speed: const Duration(milliseconds: 300),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
      ],
    );
  }
}