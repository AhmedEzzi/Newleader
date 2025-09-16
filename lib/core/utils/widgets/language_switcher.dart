import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/themes.dart/theme.dart';
import '../../providers/localization/language_provider.dart';
import '../../utils/extension/text_style_extension.dart';
import '../../utils/helpers.dart';

/// Display mode for the language switcher
enum LanguageSwitcherMode {
  /// Show languages as simple text with dividers
  text,
  
  /// Show languages as text buttons
  buttons,
  
  /// Show languages as chips
  chips
}

/// A customizable language switcher widget that can be displayed in different modes
class LanguageSwitcher extends StatelessWidget {
  /// Optional custom text style to apply to the widget
  final TextStyle? textStyle;
  
  /// Optional divider text between language codes (default: " | ")
  final String divider;
  
  /// Whether to show language codes in uppercase (default: true)
  final bool uppercase;
  
  /// Display mode for the language switcher (default: text)
  final LanguageSwitcherMode mode;
  
  /// Background color for buttons/chips (default: transparent)
  final Color? backgroundColor;
  
  /// Selected background color for buttons/chips
  final Color? selectedBackgroundColor;
  
  /// Padding for the widget (default depends on mode)
  final EdgeInsetsGeometry? padding;
  
  /// Border radius for buttons/chips (default: 8)
  final double borderRadius;
  
  const LanguageSwitcher({
    super.key,
    this.textStyle,
    this.divider = " | ",
    this.uppercase = true,
    this.mode = LanguageSwitcherMode.text,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.padding,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        // Get the current language code
        final currentLang = languageProvider.locale.languageCode;
        
        // Choose which builder to use based on mode
        switch (mode) {
          case LanguageSwitcherMode.buttons:
            return _buildButtonSwitcher(context, languageProvider, currentLang);
          case LanguageSwitcherMode.chips:
            return _buildChipSwitcher(context, languageProvider, currentLang);
          case LanguageSwitcherMode.text:
          return _buildTextSwitcher(context, languageProvider, currentLang);
        }
      },
    );
  }
  
  /// Builds the text-based language switcher with RichText
  Widget _buildTextSwitcher(BuildContext context, LanguageProvider languageProvider, String currentLang) {
    // Default text style if none provided
    final defaultStyle = context.titleMedium.copyWith(
      color: Colors.black54,
      fontWeight: FontWeight.w400,
    );
    
    // The base style to use
    final baseStyle = textStyle ?? defaultStyle;
    
    // Create spans for each language with appropriate styling
    final List<TextSpan> languageSpans = [];
    
    // Add each language with appropriate styling and tap handlers
    for (int i = 0; i < languageProvider.languages.length; i++) {
      final lang = languageProvider.languages[i];
      
      // Determine if this language is the current one
      final isSelected = currentLang == lang.languageCode;
      
      // Format language code (uppercase if specified)
      final displayText = uppercase 
          ? lang.code.toUpperCase() 
          : lang.code;
      
      // Add this language with appropriate styling
      languageSpans.add(
        TextSpan(
          text: displayText,
          style: baseStyle.copyWith(
            color: isSelected ? AppTheme.primaryColor : Colors.black54,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w300,
            fontSize: isSelected ? 18 : 14,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Skip if already selected
              if (isSelected) return;
              
              // Switch to this language
              _switchToLanguage(context, lang.languageCode, lang.countryCode);
            },
        ),
      );
      
      // Add divider between languages (except for the last one)
      if (i < languageProvider.languages.length - 1) {
        languageSpans.add(TextSpan(
          text: divider,
          style: baseStyle,
        ));
      }
    }
    
    // Create the rich text with all spans
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: RichText(
        text: TextSpan(
          children: languageSpans,
        ),
      ),
    );
  }
  
  /// Builds the button-based language switcher
  Widget _buildButtonSwitcher(BuildContext context, LanguageProvider languageProvider, String currentLang) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildLanguageItems(
          context,
          languageProvider,
          currentLang,
          (context, lang, isSelected, displayText) {
            // The base style to use
            final defaultStyle = context.titleMedium.copyWith(
              fontWeight: FontWeight.w400,
            );
            final baseStyle = textStyle ?? defaultStyle;
            
            return TextButton(
              onPressed: isSelected ? null : () => _switchToLanguage(
                context, 
                lang.languageCode, 
                lang.countryCode
              ),
              style: TextButton.styleFrom(
                backgroundColor: isSelected 
                    ? selectedBackgroundColor ?? AppTheme.primaryColor.withOpacity(0.1)
                    : backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Text(
                displayText,
                style: baseStyle.copyWith(
                  color: isSelected ? AppTheme.primaryColor : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  /// Builds the chip-based language switcher
  Widget _buildChipSwitcher(BuildContext context, LanguageProvider languageProvider, String currentLang) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 8,
        children: _buildLanguageItems(
          context,
          languageProvider,
          currentLang,
          (context, lang, isSelected, displayText) {
            // The base style to use
            final defaultStyle = context.bodyMedium.copyWith(
              fontWeight: FontWeight.w400,
            );
            final baseStyle = textStyle ?? defaultStyle;
            
            return FilterChip(
              selected: isSelected,
              label: Text(displayText),
              labelStyle: baseStyle.copyWith(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              backgroundColor: backgroundColor,
              selectedColor: selectedBackgroundColor ?? AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              onSelected: (selected) {
                if (!isSelected) {
                  _switchToLanguage(context, lang.languageCode, lang.countryCode);
                }
              },
            );
          },
        ),
      ),
    );
  }
  
  /// Generic method to build language items with a custom item builder
  List<Widget> _buildLanguageItems<T>(
    BuildContext context,
    LanguageProvider languageProvider,
    String currentLang,
    Widget Function(BuildContext, dynamic, bool, String) itemBuilder,
  ) {
    final List<Widget> items = [];
    
    // Add each language with appropriate styling and tap handlers
    for (int i = 0; i < languageProvider.languages.length; i++) {
      final lang = languageProvider.languages[i];
      
      // Determine if this language is the current one
      final isSelected = currentLang == lang.languageCode;
      
      // Format language code (uppercase if specified)
      final displayText = uppercase 
          ? lang.code.toUpperCase() 
          : lang.code;
      
      // Add this language with the custom builder
      items.add(itemBuilder(context, lang, isSelected, displayText));
      
      // Add divider between items (except for the last one)
      if (i < languageProvider.languages.length - 1 && mode == LanguageSwitcherMode.buttons) {
        items.add(const SizedBox(width: 8));
      }
    }
    
    return items;
  }
  
  void _switchToLanguage(BuildContext context, String languageCode, String countryCode) async {
    // Use the helper function to change language and refresh data
    await AppFunctions.changeLanguage(context, languageCode, countryCode);
  }
} 