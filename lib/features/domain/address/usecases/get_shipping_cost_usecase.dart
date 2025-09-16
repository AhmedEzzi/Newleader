import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetShippingCostUseCase {
  final AddressRepository repository;
  GetShippingCostUseCase(this.repository);
  Future<ShippingCost> call(String shippingType) async {
    return await repository.getShippingCost(shippingType);
  }
}