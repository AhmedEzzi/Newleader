class BusinessSetting {
  final String type;
  final dynamic value;

  BusinessSetting({
    required this.type,
    required this.value,
  });

  // Helper methods to safely get values of different types
  String getStringValue() {
    if (value == null) return '';
    return value.toString();
  }

  bool getBoolValue() {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true' || value.toLowerCase() == 'on';
    }
    if (value is num) return value != 0;
    return false;
  }

  int getIntValue() {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }

  double getDoubleValue() {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  List<dynamic> getListValue() {
    if (value == null) return [];
    if (value is List) return value;
    // For cases where the list might be serialized as a string
    if (value is String && value.startsWith('[') && value.endsWith(']')) {
      try {
        return List<dynamic>.from(value);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Map<String, dynamic> getMapValue() {
    if (value == null) return {};
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }
} 