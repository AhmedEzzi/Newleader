import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/widgets/cutsom_toast.dart';
import '../../main layout/controller/layout_provider.dart';
import '../controller/auth_provider.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoginScreen;
  
  const SocialLoginWidget({
    Key? key,
    required this.isLoginScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google login button
        _buildSocialButton(
          context,
          icon: AppSvgs.google,
          label: 'continue_with_google'.tr(context),
          onTap: () {
            onPressedGoogleLogin(context);
          },
        ),

        const SizedBox(height: 20),

        // Apple login button
        _buildSocialButton(
          context,
          icon: AppSvgs.apple,
          label: 'continue_with_apple'.tr(context),
          onTap: () {
            onPressedAppleLogin(context);
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,style: context.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            CustomImage(
              assetPath: icon,
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> onPressedGoogleLogin(context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
      await googleUser.authentication;
      String? accessToken = googleSignInAuthentication.accessToken;

      var loginResponse = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).completeSocialLogin(
        provider: "google",
        socialProvider: "google",
        name: googleUser.displayName ?? "",
        email: googleUser.email,
        secret_token: googleUser.id,
        access_token: accessToken,
      );
      if (loginResponse == true) {
        Provider.of<LayoutProvider>(context,listen: false).currentIndex=0;
        AppRoutes.navigateTo(context, AppRoutes.mainLayoutScreen);
        CustomToast.showToast(
          message: 'login_successfully'.tr(context),
          type: ToastType.success,
        );
      }

      // Disconnect after completion
      await googleSignIn.disconnect();


    } on Exception catch (e) {


      // Show error message to user
      CustomToast.showToast(
          message: 'Failed to sign in with Google: ${e.toString()}',
          type: ToastType.success
      );
    }
  }


  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> onPressedAppleLogin(BuildContext context) async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final name = [
        appleCredential.givenName,
        appleCredential.familyName
      ].where((e) => e != null && e.isNotEmpty).join(" ");

      final loginResponse = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).completeSocialLogin(
        provider: "apple",
        socialProvider: "apple",
        name: name,
        email: appleCredential.email ?? "",
        secret_token: appleCredential.userIdentifier,
        access_token: appleCredential.identityToken,
      );

      if (loginResponse == true) {
        Provider.of<LayoutProvider>(context,listen: false).currentIndex=0;
        AppRoutes.navigateTo(context, AppRoutes.mainLayoutScreen);
        CustomToast.showToast(
          message: 'login_successfully'.tr(context),
          type: ToastType.success,
        );
      }

    } catch (e) {
      CustomToast.showToast(
        message: 'Failed to sign in with Apple: ${e.toString()}',
        type: ToastType.error,
      );
    }
  }


}
