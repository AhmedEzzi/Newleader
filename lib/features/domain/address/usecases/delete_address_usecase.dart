import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);
  Future<void> call(int id) async => await repository.deleteAddress(id);
}