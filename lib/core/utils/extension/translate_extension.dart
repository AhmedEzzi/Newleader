import 'package:flutter/material.dart';

import '../../providers/localization/app_localizations.dart';

extension StringExtension on String {
  String tr(BuildContext context) {
    try {
      return AppLocalizations.of(context).translate(this);
    } catch (e) {
      // Fallback in case of error
      debugPrint('Translation error for key: $this - $e');
      return this;
    }
  }
}