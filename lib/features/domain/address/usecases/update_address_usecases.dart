import '../entities/address.dart';
import '../repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);
  Future<Address> call({
    required int id,
    required String address,
    required int countryId,
    required int stateId,
    required String cityName,
    required String phone,
  }) async {
    return await repository.updateAddress(
      id: id,
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityName: cityName,
      phone: phone,
    );
  }
}