import '../entities/address.dart';
import '../repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);
  Future<Address> call({
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    return await repository.addAddress(
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityName: cityName,
      phone: phone,
    );
  }
}