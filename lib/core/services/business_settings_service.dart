import 'package:leader_company/features/presentation/business/controller/business_provider.dart';
import '../di/injection_container.dart';

/// A utility service to access business settings from anywhere in the app
/// without needing to inject or use the provider directly.
///
/// This is a singleton service that wraps the BusinessProvider.
class BusinessSettingsService {
  static final BusinessSettingsService _instance = BusinessSettingsService._internal();
  late final BusinessProvider _businessProvider;
  bool _initialized = false;

  factory BusinessSettingsService() {
    return _instance;
  }

  BusinessSettingsService._internal() {
    _businessProvider = sl<BusinessProvider>();
  }

  /// Initialize the service by fetching the business settings if they haven't been fetched yet
  Future<void> init() async {
    if (!_initialized) {
      await _businessProvider.fetchBusinessSettings();
      _initialized = true;
    }
  }

  /// Check if a feature is enabled by its type
  bool isFeatureEnabled(String featureType) {
    return _businessProvider.isFeatureEnabled(featureType);
  }

  /// Get a setting value as a string
  String getString(String settingType) {
    return _businessProvider.getSetting(settingType).getStringValue();
  }

  /// Get a setting value as a boolean
  bool getBool(String settingType) {
    return _businessProvider.getSetting(settingType).getBoolValue();
  }

  /// Get a setting value as an integer
  int getInt(String settingType) {
    return _businessProvider.getSetting(settingType).getIntValue();
  }

  /// Get a setting value as a double
  double getDouble(String settingType) {
    return _businessProvider.getSetting(settingType).getDoubleValue();
  }

  /// Get a setting value as a list
  List<dynamic> getList(String settingType) {
    return _businessProvider.getSetting(settingType).getListValue();
  }

  /// Get a setting value as a map
  Map<String, dynamic> getMap(String settingType) {
    return _businessProvider.getSetting(settingType).getMapValue();
  }
  
  /// Get the home banner images specifically
  List<String> getHomeBannerImages() {
    try {
      return _businessProvider.getHomeSliderImages();
    } catch (e) {
      print('Error getting home banner images: $e');
      return [];
    }
  }

  // Commonly used settings
  String get websiteName => _businessProvider.websiteName;
  String get contactPhone => _businessProvider.contactPhone;
  String get contactEmail => _businessProvider.contactEmail;
  String get facebookLink => _businessProvider.facebookLink;
  String get youtubeLink => _businessProvider.youtubeLink;
  String get baseColor => _businessProvider.baseColor;
  String get headerLogo => _businessProvider.headerLogo;
  String get footerLogo => _businessProvider.footerLogo;
  bool get guestCheckoutActive => _businessProvider.guestCheckoutActive;
  bool get walletSystem => _businessProvider.walletSystem;
  bool get couponSystem => _businessProvider.couponSystem;
} 