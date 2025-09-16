import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';

class CustomBackButton extends StatelessWidget {
  final bool respectDirection;
  
  const CustomBackButton({
    super.key,
    this.respectDirection = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: respectDirection && isRtl
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14159), // Flip horizontally (pi radians)
                child: Icon( !respectDirection?Icons.arrow_back_ios:Icons.arrow_forward_ios,color: AppTheme.primaryColor,size: 22),
              )
            : const Icon(Icons.arrow_back_ios,color: AppTheme.primaryColor,size: 22),
    );
  }
}
