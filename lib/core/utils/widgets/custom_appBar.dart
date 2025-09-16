import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';

import '../../config/themes.dart/theme.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double toolbarHeight;
  final Color? statusBarColor;
  final Brightness? statusBarIcons;

  const CustomAppBar({super.key,
    this.isDark = false,
    this.title,
    this.leading,
    this.actions,
    this.toolbarHeight = 0.0,
    this.statusBarColor,
    this.statusBarIcons,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!,style: context.headlineSmall!.copyWith(fontWeight: FontWeight.w700)) : null,
      leading: leading,
      actions: actions,
      backgroundColor: isDark ? Colors.black : AppTheme.white,
      foregroundColor: isDark ? Colors.white : Colors.black,
      toolbarHeight: title != null || leading != null || actions != null
          ? toolbarHeight
          : 0.0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? (isDark ? Colors.black : AppTheme.white),
        statusBarIconBrightness: statusBarIcons ?? (isDark ? Brightness.light : Brightness.dark),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
