import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/helpers/ui_helper.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:leader_company/core/utils/widgets/cutsom_toast.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_loading.dart';
import '../../../../core/utils/widgets/custom_quick_alart_widget.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';
import '../../../../core/utils/widgets/language_switcher.dart';
import '../controller/auth_provider.dart';
import '../widgets/social_login_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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


    final tajawalBold = GoogleFonts.cairo(fontWeight: FontWeight.bold);
    final tajawalNormal = GoogleFonts.cairo();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
                    ),
                  ),
      body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
                    child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                              onPressed: () => Navigator.of(context).pop(),
                    ),
                            ),
                  const SizedBox(height: 60),
                        
                  // Title
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                          child: Text(
                            'create_new_account'.tr(context),
                      textAlign: TextAlign.center,
                      style: tajawalBold.copyWith(
                        fontSize: 26,
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
                      'create_account_subtitle'.tr(context),
                      textAlign: TextAlign.center,
                      style: tajawalNormal.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form Fields
                  FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 400),
                      child: _buildTextField(
                          label: 'full_name'.tr(context),
                          controller: _nameController,
                          hint: 'enter_your_full_name'.tr(context),
                          icon: Icons.person_outline,
                          textDirection: textDirection)),
                  const SizedBox(height: 24),
                  FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 500),
                      child: _buildTextField(
                          label: 'email_or_phone'.tr(context),
                          controller: _emailController,
                          hint: 'enter_your_email_or_phone'.tr(context),
                          icon: Icons.phone_android,
                          textDirection: textDirection)),
                  const SizedBox(height: 24),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                    child: _buildTextField(
                      label: 'password'.tr(context),
                          controller: _passwordController,
                      hint: 'enter_password'.tr(context),
                          isPassword: true,
                      textDirection: textDirection,
                        ),
                  ),
                  const SizedBox(height: 32),
                        
                  // Sign Up Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 700),
                    child: authProvider.isLoading
                        ? const CustomLoadingWidget()
                        : CustomButton(
                            onPressed: () => _handleSignUp(context, authProvider),
                            child: Text(
                              'sign_up'.tr(context),
                              textAlign: TextAlign.center,
                              style: context.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                  // Divider
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 800),
                    child: Row(children: [
                      const Expanded(child: Divider(color: Colors.black26)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or'.tr(context),
                              style: tajawalNormal.copyWith(
                                  color: Colors.grey[600]))),
                      const Expanded(child: Divider(color: Colors.black26)),
                    ]),
                        ),
                        const SizedBox(height: 16),
                        
                  // Social Login
                  FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 900),
                      child: const SocialLoginWidget(isLoginScreen: false)),
                  const SizedBox(height: 24),

                  // Login Link
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 1000),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('already_have_account'.tr(context),
                              style: tajawalNormal.copyWith(
                                  fontSize: 15, color: Colors.grey[600])),
                          const SizedBox(width: 4),
                          InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text('login'.tr(context),
                                  style: tajawalBold.copyWith(
                                      fontSize: 15, color: AppTheme.primaryColor)))
                        ]),
                  ),
                  const SizedBox(height: 20),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
        TextFormField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          textAlign: textDirection == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tajawalNormal.copyWith(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:
                  BorderSide(color: const Color(0xFFD32F2F).withOpacity(0.5)),
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[500], size: 22)
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
      ],
    );
  }

  void _handleSignUp(BuildContext context, AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        "name": _nameController.text,
        "password": _passwordController.text,
        "email_or_phone": _emailController.text,
        "password_confirmation": _passwordController.text,
        "register_by": _emailController.text.contains('@') ? 'email' : 'phone',
      };

      final isSuccess = await authProvider.signup(userData, context);

      if (isSuccess && mounted) {
        CustomQuickAlert.showSuccess(
          context,
          title: 'success!'.tr(context),
          subTitleText: 'create_account_successfully'.tr(context),
          titleStyle:
              GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
          subtitleStyle: GoogleFonts.cairo(fontSize: 16),
          confirmBtnTextStyle: GoogleFonts.cairo(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          confirmBtnText: 'sign_in'.tr(context),
          onConfirmBtnTap: () {
            AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.login);
          },
        );
      } else {
        CustomSnackbar.show(
          context,
          message: authProvider.errorMessage ?? 'Failed to sign up',
          isError: true,
        );
      }
    }
  }
}
