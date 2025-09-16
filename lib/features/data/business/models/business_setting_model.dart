import 'dart:convert';
import '../../../domain/business/entities/business_setting.dart';

class BusinessSettingModel extends BusinessSetting {
  BusinessSettingModel({
    required String type,
    required dynamic value,
  }) : super(type: type, value: value);

  factory BusinessSettingModel.fromJson(Map<String, dynamic> json) {
    return BusinessSettingModel(
      type: json['type'] ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  factory BusinessSettingModel.fromEntity(BusinessSetting entity) {
    return BusinessSettingModel(
      type: entity.type,
      value: entity.value,
    );
  }
} 