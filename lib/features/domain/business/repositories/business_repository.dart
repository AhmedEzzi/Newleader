import '../entities/business_setting.dart';

abstract class BusinessRepository {
  Future<List<BusinessSetting>> getBusinessSettings();
} 