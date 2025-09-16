import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetHomeDeliveryAddressUseCase {
  final AddressRepository repository;
  GetHomeDeliveryAddressUseCase(this.repository);
  Future<Address> call() async => await repository.getHomeDeliveryAddress();
}