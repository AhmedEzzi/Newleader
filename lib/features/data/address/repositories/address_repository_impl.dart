import '../../../domain/address/entities/address.dart';
import '../../../domain/address/repositories/address_repository.dart';
import '../datasources/address_remote_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Address>> getAddresses() async {
    final models = await remoteDataSource.getAddresses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Address> getHomeDeliveryAddress() async {
    final model = await remoteDataSource.getHomeDeliveryAddress();
    return model.toEntity();
  }

  @override
  Future<Address> addAddress({
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    final model = await remoteDataSource.addAddress(
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityId: 0,
      phone: phone,
      cityName: cityName,
    );
    return model.toEntity();
  }

  @override
  Future<Address> updateAddress({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    final model = await remoteDataSource.updateAddress(
      id: id,
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityId: 0,
      phone: phone,
      cityName: cityName,
    );
    return model.toEntity();
  }

  @override
  Future<void> updateAddressLocation(int id, double latitude, double longitude) async {
    await remoteDataSource.updateAddressLocation(id, latitude, longitude);
  }

  @override
  Future<void> makeAddressDefault(int id) async {
    await remoteDataSource.makeAddressDefault(id);
  }

  @override
  Future<void> deleteAddress(int id) async {
    await remoteDataSource.deleteAddress(id);
  }

  @override
  Future<List<Location>> getCitiesByState(int stateId, {String name = ''}) async {
    final models = await remoteDataSource.getCitiesByState(stateId, name: name);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Location>> getStatesByCountry(int countryId, {String name = ''}) async {
    final models = await remoteDataSource.getStatesByCountry(countryId, name: name);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Location>> getCountries({String name = ''}) async {
    final models = await remoteDataSource.getCountries(name: name);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ShippingCost> getShippingCost(String shippingType) async {
    final model = await remoteDataSource.getShippingCost(shippingType);
    return model.toEntity();
  }

  @override
  Future<void> updateAddressInCart(int addressId) async {
    await remoteDataSource.updateAddressInCart(addressId);
  }


}