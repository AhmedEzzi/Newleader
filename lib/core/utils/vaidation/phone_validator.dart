import 'package:flutter/material.dart';

abstract class PhoneValidation {
  static String? validateMobileNumber(String? value, BuildContext context) {
    // Check if language is Arabic
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    if (value == null || value.isEmpty) {
      return isArabic 
          ? "الرجاء إدخال رقم الهاتف المحمول" 
          : "Please enter a mobile number";
    }

    // Remove any whitespace
    value = value.trim();

    // Initialize variables
    String cleanedValue;
    int expectedLength;

    if (value.startsWith('+201')) {
      // Format: +201030390358 (13 digits)
      expectedLength = 13;
      if (value.length != expectedLength) {
        return isArabic 
            ? "يجب أن يتكون رقم الهاتف المحمول من 13 رقمًا (بما في ذلك +201)" 
            : "Mobile number must be 13 digits (including +201)";
      }
      cleanedValue = value.substring(4); // Remove "+201"
    } else if (value.startsWith('201')) {
      // Format: 201030390358 (12 digits)
      expectedLength = 12;
      if (value.length != expectedLength) {
        return isArabic 
            ? "يجب أن يتكون رقم الهاتف المحمول من 12 رقمًا (بما في ذلك 201)" 
            : "Mobile number must be 12 digits (including 201)";
      }
      cleanedValue = value.substring(3); // Remove "201"
    } else if (value.startsWith('01')) {
      // Format: 01030390358 (11 digits)
      expectedLength = 11;
      if (value.length != expectedLength) {
        return isArabic 
            ? "يجب أن يتكون رقم الهاتف المحمول من 11 رقمًا" 
            : "Mobile number must be 11 digits";
      }
      cleanedValue = value.substring(2); // Remove "01"
    } else {
      return isArabic 
          ? "يجب أن يبدأ الرقم بـ +201 أو 201 أو 01" 
          : "Number must start with +201, 201, or 01";
    }

    // Check if the cleaned value is numeric
    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return isArabic 
          ? "يجب أن يحتوي رقم الهاتف المحمول على أرقام فقط" 
          : "Mobile number must contain only digits";
    }

    // Check for valid Mobile prefixes (0, 1, 2, or 5 after 01)
    if (!cleanedValue.startsWith('0') &&
        !cleanedValue.startsWith('1') &&
        !cleanedValue.startsWith('2') &&
        !cleanedValue.startsWith('5')) {
      return isArabic 
          ? "الرقم غير صالح" 
          : "Number not valid";
    }

    return null;
  }
}