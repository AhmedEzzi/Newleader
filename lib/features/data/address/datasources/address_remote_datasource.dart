import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/address_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> getHomeDeliveryAddress();
  Future<AddressModel> addAddress({
    required String address,
    required int countryId,
    required int stateId,
    required int cityId,
    required String phone,
    String? cityName,
  });
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required int cityId,
    required String phone,
    String? title,
    String? cityName,
  });
  Future<void> updateAddressLocation(int id, double latitude, double longitude);
  Future<void> makeAddressDefault(int id);
  Future<void> deleteAddress(int id);
  Future<List<LocationModel>> getCitiesByState(int stateId, {String name = ''});
  Future<List<LocationModel>> getStatesByCountry(int countryId, {String name = ''});
  Future<List<LocationModel>> getCountries({String name = ''});
  Future<ShippingCostModel> getShippingCost(String shippingType);
  Future<void> updateAddressInCart(int addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  AddressRemoteDataSourceImpl(this.apiProvider, this.secureStorage);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.userShippingAddress,
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => AddressModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid address response');
  }

  @override
  Future<AddressModel> getHomeDeliveryAddress() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.getHomeDeliveryAddress,
    );
    if (response.data != null && response.data['data'] is Map) {
      return AddressModel.fromJson(response.data['data']);
    }
    throw Exception('Invalid home delivery address response');
  }

  @override
  Future<AddressModel> addAddress({
    required String address,
    required int countryId,
    required int stateId,
    required int cityId,
    required String phone,
    String? cityName,
  }) async {
    final Map<String, String> data = {
      'address': address,
      'country_id': countryId.toString(),
      'state_id': stateId.toString(),
      'phone': phone,
    };
    
    // Use city_name instead of city_id if provided
    if (cityName != null && cityName.isNotEmpty) {
      data['city_name'] = cityName;
    } else {
      data['city_id'] = cityId.toString();
    }

    final response = await apiProvider.post(
      LaravelApiEndPoint.userShippingCreate,
      data: data,
    );

    // Since the API doesn't return the created address object, we need to fetch addresses again
    // and find the newly created one, or create a temporary one
    if (response.data != null && response.data['result'] == true) {
      try {
        // Try to fetch the updated list
        final addresses = await getAddresses();
        // Return the last one assuming it's the newly created one
        // A better approach would be to compare with existing addresses before adding
        if (addresses.isNotEmpty) {
          return addresses.last;
        }
      } catch (e) {
        // If fetching fails, return a temporary address model
      }

      // Temporary address model with provided data
      return AddressModel(
        id: 0,  // Temporary ID
        address: address,
        countryId: countryId,
        stateId: stateId,
        cityId: cityId,
        countryName: '',  // We don't have this info
        stateName: '',    // We don't have this info
        cityName: cityName ?? '',  // Use provided cityName if available
        phone: phone,
        isDefault: false,
        locationAvailable: false, postalCode: '',
      );
    }
    throw Exception('Failed to add address');
  }

  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required int cityId,
    required String phone,
    String? title,
    String? cityName,
  }) async {
    final Map<String, String> data = {
      'id': id.toString(),
      'address': address,
      'country_id': countryId.toString(),
      'state_id': stateId.toString(),
      'phone': phone,
    };
    
    // Use city_name instead of city_id if provided
    if (cityName != null && cityName.isNotEmpty) {
      data['city_name'] = cityName;
    } else {
      data['city_id'] = cityId.toString();
    }
    
    if (title != null) {
      data['title'] = title;
    }

    final response = await apiProvider.post(
      LaravelApiEndPoint.userShippingUpdate,
      data: data,
    );

    if (response.data != null && response.data['result'] == true) {
      try {
        // Try to fetch the updated list
        final addresses = await getAddresses();
        // Find the updated address
        final updatedAddress = addresses.firstWhere(
              (addr) => addr.id == id,
          orElse: () => throw Exception('Updated address not found'),
        );
        return updatedAddress;
      } catch (e) {
        // If fetching fails, return a temporary address model
      }

      // Temporary address model with provided data
      return AddressModel(
        id: id,
        address: address,
        countryId: countryId,
        stateId: stateId,
        cityId: cityId,
        countryName: '',  // We don't have this info
        stateName: '',    // We don't have this info
        cityName: cityName ?? '',  // Use provided cityName if available
        phone: phone,
        isDefault: false, // We don't know
        locationAvailable: false, postalCode: '', // We don't know
      );
    }
    throw Exception('Failed to update address');
  }

  @override
  Future<void> updateAddressLocation(int id, double latitude, double longitude) async {
    await apiProvider.post(
      LaravelApiEndPoint.userShippingUpdateLocation,
      data: {
        'id': id.toString(),
        'lat': latitude.toString(),
        'lang': longitude.toString(),
      },
    );
  }

  @override
  Future<void> makeAddressDefault(int id) async {
    await apiProvider.post(
      LaravelApiEndPoint.userShippingMakeDefault,
      data: {'id': id.toString()},
    );
  }

  @override
  Future<void> deleteAddress(int id) async {
    await apiProvider.get(
      '${LaravelApiEndPoint.userShippingDelete}/$id',
    );
  }

  @override
  Future<List<LocationModel>> getCitiesByState(int stateId, {String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.citiesByState}/$stateId?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid cities response');
  }

  @override
  Future<List<LocationModel>> getStatesByCountry(int countryId, {String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.statesByCountry}/$countryId?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid states response');
  }

  @override
  Future<List<LocationModel>> getCountries({String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.countries}?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid countries response');
  }

  @override
  Future<ShippingCostModel> getShippingCost(String shippingType) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.shippingCost,
      data: {'seller_list': shippingType},
    );
    if (response.data != null && response.data['data'] is Map) {
      return ShippingCostModel.fromJson(response.data['data']);
    }
    throw Exception('Invalid shipping cost response');
  }

  @override
  Future<void> updateAddressInCart(int addressId) async {
    await apiProvider.post(
      LaravelApiEndPoint.updateAddressInCart,
      data: {
        'user_id': AppStrings.userId,
        'address_id': addressId,
      },
    );
  }
}