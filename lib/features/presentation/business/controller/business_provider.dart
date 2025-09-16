import 'package:flutter/foundation.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/business/entities/business_setting.dart';
import '../../../domain/business/usecases/get_business_settings_usecase.dart';

class BusinessProvider extends ChangeNotifier {
  final GetBusinessSettingsUseCase getBusinessSettingsUseCase;

  BusinessProvider({required this.getBusinessSettingsUseCase});

  // State variables
  LoadingState _businessSettingsState = LoadingState.initial;
  List<BusinessSetting> _businessSettings = [];
  String _errorMessage = '';

  // Getters
  LoadingState get businessSettingsState => _businessSettingsState;
  List<BusinessSetting> get businessSettings => _businessSettings;
  String get errorMessage => _errorMessage;

  // Cache for frequently accessed settings
  String? _contactPhone;
  String? _contactEmail;
  String? _facebookLink;
  String? _youtubeLink;
  String? _baseColor;
  String? _websiteName;
  String? _headerLogo;
  String? _footerLogo;
  bool? _guestCheckoutActive;
  bool? _walletSystem;
  bool? _couponSystem;

  // Getters for frequently accessed settings
  String get contactPhone => _contactPhone ?? getSetting('contact_phone').getStringValue();
  String get contactEmail => _contactEmail ?? getSetting('contact_email').getStringValue();
  String get facebookLink => _facebookLink ?? getSetting('facebook_link').getStringValue();
  String get youtubeLink => _youtubeLink ?? getSetting('youtube_link').getStringValue();
  String get baseColor => _baseColor ?? getSetting('base_color').getStringValue();
  String get websiteName => _websiteName ?? getSetting('website_name').getStringValue();
  String get headerLogo => _headerLogo ?? getSetting('header_logo').getStringValue();
  String get footerLogo => _footerLogo ?? getSetting('footer_logo').getStringValue();
  bool get guestCheckoutActive => _guestCheckoutActive ?? getSetting('guest_checkout_active').getBoolValue();
  bool get walletSystem => _walletSystem ?? getSetting('wallet_system').getBoolValue();
  bool get couponSystem => _couponSystem ?? getSetting('coupon_system').getBoolValue();

  // Method to fetch business settings
  Future<void> fetchBusinessSettings() async {
    try {
      _businessSettingsState = LoadingState.loading;
      notifyListeners();

      _businessSettings = await getBusinessSettingsUseCase();
      
      // Cache frequently accessed settings
      _updateCache();
      
      _businessSettingsState = LoadingState.loaded;
    } catch (e) {
      _businessSettingsState = LoadingState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Helper method to get a setting by type
  BusinessSetting getSetting(String type) {
    return _businessSettings.firstWhere(
      (setting) => setting.type == type,
      orElse: () => BusinessSetting(type: type, value: null),
    );
  }

  // Helper method to check if a feature is enabled
  bool isFeatureEnabled(String featureType) {
    final setting = getSetting(featureType);
    return setting.getBoolValue();
  }

  // Update cached values
  void _updateCache() {
    _contactPhone = getSetting('contact_phone').getStringValue();
    _contactEmail = getSetting('contact_email').getStringValue();
    _facebookLink = getSetting('facebook_link').getStringValue();
    _youtubeLink = getSetting('youtube_link').getStringValue();
    _baseColor = getSetting('base_color').getStringValue();
    _websiteName = getSetting('website_name').getStringValue();
    _headerLogo = getSetting('header_logo').getStringValue();
    _footerLogo = getSetting('footer_logo').getStringValue();
    _guestCheckoutActive = getSetting('guest_checkout_active').getBoolValue();
    _walletSystem = getSetting('wallet_system').getBoolValue();
    _couponSystem = getSetting('coupon_system').getBoolValue();
  }

  // Helper method for getting home slider images
  List<String> getHomeSliderImages() {
    try {
      for (var setting in _businessSettings) {
        if (setting.type == 'home_slider_images_small') {
          if (setting.value is List) {
            return List<String>.from(setting.value);
          } else {
            print('Home slider images value is not a list: ${setting.value.runtimeType} - ${setting.value}');
          }
        }
      }
    } catch (e) {
      print('Error getting home slider images: $e');
    }
    return [];
  }
} 