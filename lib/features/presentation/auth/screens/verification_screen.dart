import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/di/injection_container.dart';
import 'package:leader_company/core/utils/local_storage/local_storage_keys.dart';
import 'package:leader_company/core/utils/local_storage/secure_storage.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';
import '../widgets/otp_input.dart';
import '../widgets/otp_timer.dart';

class VerificationScreen extends StatefulWidget {
  final bool isEmail;
  final String contactInfo;
  final int otpLength;

  const VerificationScreen({
    super.key,
    this.isEmail = true,
    required this.contactInfo,
    this.otpLength = 4,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();
  bool hasError = false;
  bool isLoading = false;
  bool isButtonEnabled = false;
  int timerSeconds = 30;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _handleVerification() async {
    if (otpController.text.length != widget.otpLength) {
      setState(() => hasError = true);
      return;
    }

    setState(() => isLoading = true);
    // Simulate verification
    await Future.delayed(const Duration(seconds: 1));
    
    // Save the login status in secure storage
    await sl<SecureStorage>().save(LocalStorageKey.isLoggedIn, true);
    await sl<SecureStorage>().save(LocalStorageKey.hasCompletedOnboarding, true);
    
    setState(() => isLoading = false);

    if (mounted) {
      CustomSnackbar.show(
        context,
        message: 'verification_success'.tr(context),
        isError: false,
      );
      
      // Navigate to main screen after verification
      AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
    }
  }

  void _handleResend() {
    setState(() => timerSeconds = 30);
    startTimer();
    CustomSnackbar.show(
      context,
      message: 'otp_resent_success'.tr(context),
      isError: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 64 : 24,
              vertical: 32,
            ),
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: isTablet ? 100 : 80,
                      width: isTablet ? 100 : 80,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: isTablet ? 50 : 40,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 48 : 32),
                  Text(
                    'verification'.tr(context),
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'verification_sent_to'
                        .tr(context)
                        .replaceAll(
                          '{type}',
                          widget.isEmail
                              ? 'email'.tr(context)
                              : 'phone'.tr(context),
                        )
                        .replaceAll('{contact}', widget.contactInfo),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha:
                        0.7,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 48 : 32),
                  OTPInput(
                        controller: otpController,
                        otpLength: widget.otpLength,
                        hasError: hasError,
                        isTablet: isTablet,
                        onChanged: (value) {
                          setState(() {
                            hasError = false;
                            isButtonEnabled = value.length == widget.otpLength;
                          });
                        },
                      ),
                  SizedBox(height: isTablet ? 48 : 32),
                  CustomButton(
                    text: 'verify'.tr(context),
                    onPressed: isButtonEnabled ? _handleVerification : null,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),
                  OTPTimer(
                    timerSeconds: timerSeconds,
                    onResend: _handleResend,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
