import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:provider/provider.dart';
import '../../main layout/controller/layout_provider.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'my_cart'.tr(context),
          style: context.displaySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Illustration
            FadeIn(
              duration: const Duration(milliseconds: 800),
              child: SizedBox(
                width: 200,
                height: 200,
                child: SvgPicture.asset(
                  'assets/svgs/empty_cart.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Main Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'empty_cart_title'.tr(context),
                  style: context.displaySmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'empty_cart_subtitle'.tr(context),
                  style: context.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Start Shopping Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  onPressed: () {
                    Provider.of<LayoutProvider>(context, listen: false).currentIndex = 0;
                  },
                  fullWidth: true,
                  child: Text(
                    'start_shopping'.tr(context),
                    textAlign: TextAlign.center,
                    style: context.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

