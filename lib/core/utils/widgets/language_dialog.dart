import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/themes.dart/theme.dart';
import '../../providers/localization/app_localizations.dart';
import '../../providers/localization/language_provider.dart';
import 'custom_button.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final String currentLanguage;

  const LanguageSelectionDialog({super.key, required this.currentLanguage});

  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).translate('select_language'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildLanguageOption("English", "en"),
              const SizedBox(height: 10),
              _buildLanguageOption("العربية", "ar"),
              const SizedBox(height: 10),
              _buildLanguageOption("Русский", "ru"),
              const SizedBox(height: 10),
              _buildLanguageOption("Deutsch", "de"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).translate('cancel'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  CustomButton(
                    text: AppLocalizations.of(context).translate('ok'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    onPressed: () {
                      print(_selectedLanguage);
                      Provider.of<LanguageProvider>(
                        context,
                        listen: false,
                      ).setLocale(Locale(_selectedLanguage));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String title, String langCode) {
    bool isSelected = _selectedLanguage == langCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = langCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}
