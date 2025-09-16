import '../repositories/address_repository.dart';

class MakeAddressDefaultUseCase {
  final AddressRepository repository;
  MakeAddressDefaultUseCase(this.repository);
  Future<void> call(int id) async => await repository.makeAddressDefault(id);
}