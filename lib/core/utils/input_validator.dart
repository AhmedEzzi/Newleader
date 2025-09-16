
class InputValidator {
  // Email validation
  // static bool isValidEmail(String email) {
  //   return EmailValidator.validate(email);
  // }

  // Password validation (8+ chars, at least 1 uppercase, 1 lowercase, 1 number)
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigit;
  }

  // Phone number validation (simple pattern)
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }

  // Name validation (minimum 2 characters, letters only)
  static bool isValidName(String name) {
    return name.length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }

  // Address validation (minimum 5 characters)
  static bool isValidAddress(String address) {
    return address.length >= 5;
  }

  // Credit card validation
  static bool isValidCreditCard(String cardNumber) {
    // Strip any non-digits
    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Apply Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // ZipCode/Postal code validation (US format)
  static bool isValidZipCode(String zipCode) {
    return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode);
  }

  // Product quantity validation
  static bool isValidQuantity(String quantity) {
    try {
      int qty = int.parse(quantity);
      return qty > 0;
    } catch (_) {
      return false;
    }
  }
}

