import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/di/injection_container.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/helpers/ui_helper.dart';
import 'package:leader_company/core/utils/local_storage/local_storage_keys.dart';
import 'package:leader_company/core/utils/local_storage/secure_storage.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_loading.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';
import '../../../../core/utils/widgets/cutsom_toast.dart';
import '../../../../local_notification_and_token.dart';
import '../controller/auth_provider.dart';
import '../widgets/social_login_widget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? devicetoken;
  final GlobalMethods globalMethods = GlobalMethods();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Force the status bar to be transparent at startup using our helper
    UIHelper.setTransparentStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final textDirection = Directionality.of(context);

    // Define text styles with Tajawal font
    final tajawalBold = GoogleFonts.cairo(fontWeight: FontWeight.bold);
    final tajawalNormal = GoogleFonts.cairo();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFAFAFA),
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Container(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    // Welcome Back Title
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'welcome_back'.tr(context),
                        textAlign: TextAlign.center,
                        style: tajawalBold.copyWith(
                          fontSize: 28,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'sign_in_continue'.tr(context),
                        textAlign: TextAlign.center,
                        style: tajawalNormal.copyWith(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email/Phone Field
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 400),
                      child: _buildTextField(
                        context: context,
                        label: 'email_or_phone'.tr(context),
                        controller: emailController,
                        hint: 'enter_your_email_or_phone'.tr(context),
                        icon: Icons.phone_android,
                        textDirection: textDirection,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 500),
                      child: _buildTextField(
                        context: context,
                        label: 'password'.tr(context),
                        controller: passwordController,
                        hint: 'enter_password'.tr(context),
                        isPassword: true,
                        textDirection: textDirection,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Forgot Password
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 600),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () {
                            AppRoutes.navigateTo(context, AppRoutes.forgetPassword);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            'forgot_password'.tr(context),
                            style: context.titleLarge.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 700),
                      child: authProvider.isLoading
                          ? const CustomLoadingWidget()
                          : Container(
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
                                onPressed: () async {
                                  _handleLogin(context, authProvider);
                                  devicetoken = await globalMethods.registerNotification(context);
                                  debugPrint('FCM Token received: $devicetoken');
                                  },

                                child: Text(
                                  'login'.tr(context),
                                  textAlign: TextAlign.center,
                                  style: context.headlineSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Continue as Guest Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 750),
                      child: CustomButton(
                        onPressed: () => _continueAsGuest(context),
                        isOutlined: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'continue_as_guest'.tr(context),
                              style: context.titleLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // "Or" Divider
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.black26)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or'.tr(context),
                              style: tajawalNormal.copyWith(
                                  color: Colors.grey[600]),
                            ),
                          ),
                          const Expanded(child: Divider(color: Colors.black26)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social Login
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 900),
                      child: const SocialLoginWidget(isLoginScreen: true)),
                    const SizedBox(height: 32),

                    // Sign Up Link
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 1000),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'dont_have_an_account?'.tr(context),
                            style: tajawalNormal.copyWith(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              AppRoutes.navigateTo(context, AppRoutes.signUp);
                            },
                            child: Text(
                              'sign_up_now'.tr(context),
                              style: context.titleLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hint,
    required TextDirection textDirection,
    IconData? icon,
    bool isPassword = false,
  }) {
    final tajawalNormal = GoogleFonts.cairo();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tajawalNormal.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            textAlign: textDirection == TextDirection.rtl
                ? TextAlign.right
                : TextAlign.left,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: tajawalNormal.copyWith(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              prefixIcon: icon != null
                  ? Icon(icon, color: AppTheme.primaryColor, size: 22)
                  : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty'; // Replace with translation
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _handleLogin(BuildContext context, AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      bool isSuccess = await authProvider.login(
        emailController.text,
        passwordController.text,
        emailController.text.contains('@') ? 'email' : 'phone',
        context,
      );
      if (isSuccess && mounted) {
        await sl<SecureStorage>().save(LocalStorageKey.isLoggedIn, true);
        AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
        CustomToast.showToast(
          message: 'login_successfully'.tr(context),
          type: ToastType.success,
        );
      } else {
        CustomSnackbar.show(
          context,
          message: authProvider.errorMessage ?? 'login_failed'.tr(context),
          isError: true,
        );
      }
    }
  }

  void _continueAsGuest(BuildContext context) {
    // Navigate to main screen without authentication
    AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
    CustomToast.showToast(
      message: 'welcome_guest'.tr(context),
      type: ToastType.success,
    );
  }
}
