import '../repositories/address_repository.dart';

class UpdateAddressLocationUseCase {
  final AddressRepository repository;
  UpdateAddressLocationUseCase(this.repository);
  Future<void> call(int id, double latitude, double longitude) async {
    await repository.updateAddressLocation(id, latitude, longitude);
  }
}