import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/providers/localization/language_provider.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LanguageDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _CustomLanguageDialog(),
        );
      },
    );
  }
}

class _CustomLanguageDialog extends StatefulWidget {
  @override
  _CustomLanguageDialogState createState() => _CustomLanguageDialogState();
}

class _CustomLanguageDialogState extends State<_CustomLanguageDialog> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    _selectedLanguage = provider.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
               Text(
                '文',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'change_lang_title'.tr(context),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Description text
          Text(
            'change_lang_subtitle'.tr(context),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Language options
          _buildLanguageOption('English', 'en'),
          const SizedBox(height: 20),
          _buildLanguageOption('العربية', 'ar'),


          const SizedBox(height: 40),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () => Navigator.pop(context),
                  isOutlined: true,
                  child: Text(
                    'cancel'.tr(context),
                    textAlign: TextAlign.center,
                    style: context.titleLarge,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  onPressed: _changeLanguage,
                  child: Text(
                    textAlign: TextAlign.center,
                    'confirm'.tr(context),
                    style: context.titleLarge!.copyWith(color: AppTheme.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    final isSelected = _selectedLanguage == code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                width: isSelected ? 0 : 1,
              ),
              color: isSelected ? Colors.transparent : Colors.transparent,
            ),
            child: isSelected
                ? Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor ,
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            language,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage() {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguageCode = provider.locale.languageCode;

    if (_selectedLanguage != currentLanguageCode) {
      // Check if the selected language is one of the supported languages
      final supportedLanguages = provider.languages.map((lang) => lang.languageCode).toList();

      if (!supportedLanguages.contains(_selectedLanguage)) {
        // Show a message for unsupported languages
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This language is not supported yet. Coming soon!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
        return;
      }

      // Get the country code from the provider's language models
      final languageModel = provider.languages.firstWhere(
            (lang) => lang.languageCode == _selectedLanguage,
      );

      // Change language using the provider's method
      provider.changeLanguage(_selectedLanguage, languageModel.countryCode ?? 'US');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('language_changed_successfully'.tr(context))),
      );
    }
    Navigator.pop(context);
  }
}