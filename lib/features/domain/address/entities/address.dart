// lib/features/domain/address/entities/address.dart
enum AddressType { home, company, other }

class Address {
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

  Address({
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
}

class Location {
  final int id;
  final String name;
  final double? cost;
  final String? code;
  final int? status;
  final int? stateId;

  Location({
    required this.id,
    required this.name,
    this.cost,
    this.code,
    this.status,
    this.stateId,
  });
}

class ShippingCost {
  final double cost;
  final String currencySymbol;

  ShippingCost({
    required this.cost,
    required this.currencySymbol,
  });
}