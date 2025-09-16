import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/address/entities/address.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/address/usecases/add_address_usecases.dart';
import '../../../domain/address/usecases/delete_address_usecase.dart';
import '../../../domain/address/usecases/get_address_usecases.dart';
import '../../../domain/address/usecases/get_cities_by_state_usecase.dart';
import '../../../domain/address/usecases/get_countries_usecase.dart';
import '../../../domain/address/usecases/get_home_delivery_usecases.dart';
import '../../../domain/address/usecases/get_shipping_cost_usecase.dart';
import '../../../domain/address/usecases/get_states_by_country_usecase.dart';
import '../../../domain/address/usecases/make_address_default_usecase.dart';
import '../../../domain/address/usecases/update_address_in_cart_usecase.dart';
import '../../../domain/address/usecases/update_address_location_usecases.dart';
import '../../../domain/address/usecases/update_address_usecases.dart';
import '../../checkout/controller/payment_provider.dart';

class AddressProvider extends ChangeNotifier {
  final GetAddressesUseCase getAddressesUseCase;
  final GetHomeDeliveryAddressUseCase getHomeDeliveryAddressUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final UpdateAddressLocationUseCase updateAddressLocationUseCase;
  final MakeAddressDefaultUseCase makeAddressDefaultUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final GetCitiesByStateUseCase getCitiesByStateUseCase;
  final GetStatesByCountryUseCase getStatesByCountryUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final GetShippingCostUseCase getShippingCostUseCase;
  final UpdateAddressInCartUseCase updateAddressInCartUseCase;

  AddressProvider({
    required this.getAddressesUseCase,
    required this.getHomeDeliveryAddressUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.updateAddressLocationUseCase,
    required this.makeAddressDefaultUseCase,
    required this.deleteAddressUseCase,
    required this.getCitiesByStateUseCase,
    required this.getStatesByCountryUseCase,
    required this.getCountriesUseCase,
    required this.getShippingCostUseCase,
    required this.updateAddressInCartUseCase,
  });

  LoadingState addressState = LoadingState.loading;
  List<Address> addresses = [];
  Address? homeDeliveryAddress;
  List<Location> countries = [];
  List<Location> states = [];
  List<Location> cities = [];
  ShippingCost? shippingCost;
  String addressError = '';

  Future<void> fetchAddresses() async {
    try {
      addressState = LoadingState.loading;
      notifyListeners();
      addresses = await getAddressesUseCase();
      addressState = LoadingState.loaded;
    } catch (e) {
      addressState = LoadingState.error;
      addressError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchHomeDeliveryAddress() async {
    try {
      homeDeliveryAddress = await getHomeDeliveryAddressUseCase();
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> addAddress({
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    try {
      final newAddress = await addAddressUseCase(
        address: address,
        countryId: countryId,
        stateId: stateId,
        cityName: cityName,
        phone: phone,
      );
      addresses.add(newAddress);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAddress({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    try {
      final updatedAddress = await updateAddressUseCase(
        id: id,
        address: address,
        countryId: countryId,
        stateId: stateId,
        cityName: cityName,
        phone: phone,
      );
      final index = addresses.indexWhere((addr) => addr.id == id);
      if (index != -1) {
        addresses[index] = updatedAddress;
        notifyListeners();
      }
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAddressLocation(int id, double latitude, double longitude) async {
    try {
      await updateAddressLocationUseCase(id, latitude, longitude);
      final index = addresses.indexWhere((addr) => addr.id == id);
      if (index != -1) {
        addresses[index] = addresses[index].copyWith(latitude: latitude, longitude: longitude);
        notifyListeners();
      }
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> makeAddressDefault(int id) async {
    try {
      await makeAddressDefaultUseCase(id);
      addresses = addresses.map((addr) => addr.copyWith(isDefault: addr.id == id)).toList();
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await deleteAddressUseCase(id);
      addresses.removeWhere((addr) => addr.id == id);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchCountries({String name = ''}) async {
    try {
      countries = await getCountriesUseCase(name: name);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchStatesByCountry(int countryId, {String name = ''}) async {
    try {
      states = await getStatesByCountryUseCase(countryId, name: name);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchCitiesByState(int stateId, {String name = ''}) async {
    try {
      cities = await getCitiesByStateUseCase(stateId, name: name);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchShippingCost(String shippingType) async {
    try {
      shippingCost = await getShippingCostUseCase(shippingType);
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAddressInCart(int addressId, {BuildContext? context}) async {
    try {
      await updateAddressInCartUseCase(addressId);
      
      // Find the address by ID to get state and address details for shipping update
      final address = addresses.firstWhere((addr) => addr.id == addressId);
      
      // If context is provided, also update shipping type
      if (context != null) {
        // Get the PaymentProvider instance
        final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
        
        // Call updateShippingTypeForGuest with the address details
        await paymentProvider.updateShippingTypeForGuest(
          stateId: address.stateId,
          address: address.address,
        );
      }
      
      notifyListeners();
    } catch (e) {
      addressError = e.toString();
      notifyListeners();
    }
  }

}

// Extension to support copyWith
extension AddressCopy on Address {
  Address copyWith({
    int? id,
    String? title,
    String? address,
    int? countryId,
    int? stateId,
    int? cityId,
    String? countryName,
    String? stateName,
    String? cityName,
    String? postalCode,
    String? phone,
    double? latitude,
    double? longitude,
    bool? isDefault,
    bool? locationAvailable,
  }) {
    return Address(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      countryName: countryName ?? this.countryName,
      stateName: stateName ?? this.stateName,
      cityName: cityName ?? this.cityName,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      locationAvailable: locationAvailable ?? this.locationAvailable,
    );
  }
}