import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isSendingEmail = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      CustomSnackbar.show(
        context,
        message: _isSendingEmail
            ? 'reset_link_sent'.tr(context)
            : 'otp_sent'.tr(context),
        isError: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tajawalBold = GoogleFonts.cairo(fontWeight: FontWeight.bold);
    final tajawalNormal = GoogleFonts.cairo();
    final textDirection = Directionality.of(context);

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
                      'forgot_password_title'.tr(context),
                      textAlign: TextAlign.center,
                      style: context.displaySmall.copyWith(
                           color: Colors.black87,fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      _isSendingEmail
                          ? 'forgot_password_email_desc'.tr(context)
                          : 'forgot_password_phone_desc'.tr(context),
                      textAlign: TextAlign.center,
                      style: context.headlineSmall.copyWith(
                           color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Field
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: _buildTextField(
                        controller: _controller,
                        hint: _isSendingEmail
                            ? 'enter_your_email'.tr(context)
                            : 'enter_your_phone_number'.tr(context),
                        isEmail: _isSendingEmail,
                        textDirection: textDirection),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Method
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: () =>
                            setState(() => _isSendingEmail = !_isSendingEmail),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                            _isSendingEmail
                                ? 'use_phone_number_instead'.tr(context)
                                : 'use_email_address_instead'.tr(context),
                            style: context.titleLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                    child: _isLoading
                        ? const CustomLoadingWidget()
                        : CustomButton(
                      onPressed: _handleResetPassword,
                      child: Text(
                          _isSendingEmail
                              ? 'send_reset_link'.tr(context)
                              : 'send_otp'.tr(context),
                          textAlign: TextAlign.center,
                          style: context.headlineSmall.copyWith(
                               color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Back to Login Link
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('remember_your_password'.tr(context),
                            style: tajawalNormal.copyWith(
                                fontSize: 15, color: Colors.grey[600])),
                        const SizedBox(width: 4),
                        InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text('login'.tr(context),
                                style: context.titleLarge.copyWith(
                                    color: AppTheme.primaryColor, fontWeight: FontWeight.w900)))
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isEmail,
    required TextDirection textDirection,
  }) {
    final tajawalNormal = GoogleFonts.cairo();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEmail ? 'email'.tr(context) : 'phone_number'.tr(context),
          style: tajawalNormal.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType:
          isEmail ? TextInputType.emailAddress : TextInputType.phone,
          textAlign:
          textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
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
            prefixIcon: Icon(
              isEmail ? Icons.email_outlined : Icons.phone_android,
              color: Colors.grey[500],
              size: 22,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            if (isEmail && !value.contains('@')) {
              return 'Invalid email';
            }
            return null;
          },
        ),
      ],
    );
  }
}