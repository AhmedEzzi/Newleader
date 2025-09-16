import '../entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAddresses();
  Future<Address> getHomeDeliveryAddress();
  Future<Address> addAddress({
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  });
  Future<Address> updateAddress({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  });
  Future<void> updateAddressLocation(int id, double latitude, double longitude);
  Future<void> makeAddressDefault(int id);
  Future<void> deleteAddress(int id);
  Future<List<Location>> getCitiesByState(int stateId, {String name = ''});
  Future<List<Location>> getStatesByCountry(int countryId, {String name = ''});
  Future<List<Location>> getCountries({String name = ''});
  Future<ShippingCost> getShippingCost(String shippingType);
  Future<void> updateAddressInCart(int addressId);
}