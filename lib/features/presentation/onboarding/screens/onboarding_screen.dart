import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/local_storage/local_storage_keys.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/di/injection_container.dart';
import 'package:leader_company/core/utils/local_storage/secure_storage.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/providers/localization/app_localizations.dart';
import 'package:leader_company/core/providers/localization/language_provider.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'onboarding_title_1',
      'description': 'onboarding_description_1',
      'image': AppImages.onboardingBg1,
    },
    {
      'title': 'onboarding_title_2',
      'description': 'onboarding_description_2',
      'image': AppImages.onboardingBg2,
    },
    {
      'title': 'onboarding_title_3',
      'description': 'onboarding_description_3',
      'image': AppImages.onboardingBg3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNextPressed() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed in secure storage
    await sl<SecureStorage>().save(LocalStorageKey.hasCompletedOnboarding, true);
    if (mounted) {
      AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context);
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            actions: [
              if (_currentPage < onboardingData.length - 1)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      localizations.translate('onboarding_skip'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontFamily: GoogleFonts.cairo().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 40),
              // Main content area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];
                    return _buildOnboardingPage(
                      context,
                      localizations,
                      item['image'],
                      item['title'],
                      item['description'],
                    );
                  },
                ),
              ),
              
              // Bottom section with page indicator and button
              Container(
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 40,
                  top: 20,
                ),
                child: Column(
                  children: [
                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: onboardingData.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: _currentPage == onboardingData.length - 1 
                            ? AppTheme.secondaryColor // Green for last page
                            : AppTheme.primaryColor, // Red for other pages
                        dotColor: Colors.grey.withOpacity(0.3),
                        spacing: 8,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Next/Start button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentPage == onboardingData.length - 1
                              ? AppTheme.secondaryColor // Green for last page
                              : AppTheme.primaryColor, // Red for other pages
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == onboardingData.length - 1 
                              ? localizations.translate('onboarding_start_now')
                              : localizations.translate('onboarding_next'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.cairo().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    AppLocalizations localizations,
    String image,
    String titleKey,
    String descriptionKey,
  ) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 80), // Space for status bar and app bar
          
          // Image with rounded corners
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Text content
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Title
                Text(
                  localizations.translate(titleKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.cairo().fontFamily,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  localizations.translate(descriptionKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontFamily: GoogleFonts.cairo().fontFamily,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}