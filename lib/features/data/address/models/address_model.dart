import '../../../domain/address/entities/address.dart';

class AddressModel {
  final int id;
  final String title;
  final String address;
  final int countryId;
  final int stateId;
  final int cityId;
  final String countryName;
  final String stateName;
  final String cityName;
  final String postalCode;
  final String phone;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final bool locationAvailable;

  AddressModel({
    required this.id,
    this.title = '',
    required this.address,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.countryName,
    required this.stateName,
    required this.cityName,
    required this.postalCode,
    required this.phone,
    this.latitude,
    this.longitude,
    required this.isDefault,
    required this.locationAvailable,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      countryId: json['country_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      cityId: json['city_id'] ?? 0,
      countryName: json['country_name'] ?? '',
      stateName: json['state_name'] ?? '',
      cityName: json['city_name'] ?? '',
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'] ?? '',
      latitude: json['lat']?.toDouble(),
      longitude: json['lang']?.toDouble(),
      isDefault: json['set_default'] == 1,
      locationAvailable: json['location_available'] ?? false,
    );
  }

  Address toEntity() {
    return Address(
      id: id,
      title: title,
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityId: cityId,
      countryName: countryName,
      stateName: stateName,
      cityName: cityName,
      postalCode: postalCode,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
      locationAvailable: locationAvailable,
    );
  }
}

class LocationModel {
  final int id;
  final String name;
  final double? cost;
  final String? code;
  final int? status;
  final int? stateId;

  LocationModel({
    required this.id,
    required this.name,
    this.cost,
    this.code,
    this.status,
    this.stateId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cost: json['cost']?.toDouble(),
      code: json['code'],
      status: json['status'],
      stateId: json['state_id'],
    );
  }

  Location toEntity() {
    return Location(
      id: id,
      name: name,
      cost: cost,
      code: code,
      status: status,
      stateId: stateId,
    );
  }
}

class ShippingCostModel {
  final double cost;
  final String currencySymbol;

  ShippingCostModel({
    required this.cost,
    required this.currencySymbol,
  });

  factory ShippingCostModel.fromJson(Map<String, dynamic> json) {
    return ShippingCostModel(
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol'] ?? '',
    );
  }

  ShippingCost toEntity() {
    return ShippingCost(cost: cost, currencySymbol: currencySymbol);
  }
}