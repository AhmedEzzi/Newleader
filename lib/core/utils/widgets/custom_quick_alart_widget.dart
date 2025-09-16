import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:quickalert/quickalert.dart';

/// A custom widget that wraps the QuickAlert package to provide a more
/// convenient API for showing different types of alerts.
class CustomQuickAlert {
  /// Shows a success alert dialog
  static Future<void> showSuccess(
      BuildContext context, {
        String title = 'success!',
        String subTitleText = 'Operation completed successfully!',
        String confirmBtnText = 'OK',
        VoidCallback? onConfirmBtnTap,
        bool barrierDismissible = true,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        BoxDecoration? confirmBtnDecoration,
        TextStyle? confirmBtnTextStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
      }) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: subTitleText,
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: onConfirmBtnTap,
      barrierDismissible: barrierDismissible,
      widget: widget,
      confirmBtnTextStyle: confirmBtnTextStyle,
      width: width,
        confirmBtnColor:AppTheme.primaryColor
    );
  }

  /// Shows an error alert dialog
  static Future<void> showError(
      BuildContext context, {
        String title = 'Error!',
        String subTitleText = 'Something went wrong!',
        String confirmBtnText = 'OK',
        VoidCallback? onConfirmBtnTap,
        bool barrierDismissible = true,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        BoxDecoration? confirmBtnDecoration,
        TextStyle? confirmBtnTextStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
      }) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: subTitleText,
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: onConfirmBtnTap,
      barrierDismissible: barrierDismissible,
      widget: widget,
      confirmBtnTextStyle: confirmBtnTextStyle,

      width: width,
    );
  }

  /// Shows a warning alert dialog
  static Future<void> showWarning(
      BuildContext context, {
        String title = 'Warning!',
        String subTitleText = 'Please pay attention!',
        String confirmBtnText = 'OK',
        VoidCallback? onConfirmBtnTap,
        bool barrierDismissible = true,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        BoxDecoration? confirmBtnDecoration,
        TextStyle? confirmBtnTextStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
      }) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: subTitleText,
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: onConfirmBtnTap,
      barrierDismissible: barrierDismissible,
      widget: widget,
      confirmBtnTextStyle: confirmBtnTextStyle,

      width: width,
    );
  }

  /// Shows an info alert dialog
  static Future<void> showInfo(
      BuildContext context, {
        String title = 'Info',
        String subTitleText = 'Information message',
        String confirmBtnText = 'OK',
        VoidCallback? onConfirmBtnTap,
        bool barrierDismissible = true,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        BoxDecoration? confirmBtnDecoration,
        TextStyle? confirmBtnTextStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
      }) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title,
      text: subTitleText,
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: onConfirmBtnTap,
      barrierDismissible: barrierDismissible,
      widget: widget,
      confirmBtnTextStyle: confirmBtnTextStyle,

      width: width,
    );
  }

  /// Shows a confirmation alert dialog with both confirm and cancel buttons
  static Future<bool?> showConfirmation(
      BuildContext context, {
        String title = 'Confirmation',
        String subTitleText = 'Are you sure you want to proceed?',
        String confirmBtnText = 'Yes',
        String cancelBtnText = 'No',
        VoidCallback? onConfirmBtnTap,
        VoidCallback? onCancelBtnTap,
        bool barrierDismissible = true,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        BoxDecoration? confirmBtnDecoration,
        TextStyle? confirmBtnTextStyle,
        BoxDecoration? cancelBtnDecoration,
        TextStyle? cancelBtnTextStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
      }) async {
    bool? result;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: subTitleText,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      onConfirmBtnTap: () {
        result = true;
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap();
        } else {
          Navigator.pop(context);
        }
      },
      onCancelBtnTap: () {
        result = false;
        if (onCancelBtnTap != null) {
          onCancelBtnTap();
        } else {
          Navigator.pop(context);
        }
      },
      barrierDismissible: barrierDismissible,
      widget: widget,
      confirmBtnTextStyle: confirmBtnTextStyle,
      cancelBtnTextStyle: cancelBtnTextStyle,

      width: width,
    );
    return result;
  }

  /// Shows a loading alert dialog
  static Future<void> showLoading(
      BuildContext context, {
        String title = 'Loading',
        String subTitleText = 'Please wait...',
        bool barrierDismissible = false,
        Widget? widget,
        TextStyle? titleStyle,
        TextStyle? subtitleStyle,
        Color? backgroundColor,
        BorderRadius? borderRadius,
        double? width,
        Duration? autoCloseDuration,
      }) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: title,
      text: subTitleText,
      barrierDismissible: barrierDismissible,
      widget: widget,

      width: width,
      autoCloseDuration: autoCloseDuration,
    );
  }


  /// Closes any currently displayed QuickAlert dialog
  static void closeAlert(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}