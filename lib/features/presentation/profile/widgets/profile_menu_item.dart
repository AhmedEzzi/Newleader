import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../../core/utils/extension/text_style_extension.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CustomImage(
              assetPath: icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.titleMedium.copyWith(
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            isRtl
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159), // Flip horizontally
                    child: const CustomImage(assetPath: AppSvgs.profile_back),
                  )
                : const CustomImage(assetPath: AppSvgs.profile_back),
          ],
        ),
      ),
    );
  }
} 