import '../repositories/payment_repository.dart';

class UpdateShippingTypeUseCase {
  final PaymentRepository repository;

  UpdateShippingTypeUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int stateId,
    required String address,
  }) async {
    return await repository.updateShippingTypeInCart(
      stateId: stateId,
      address: address,
    );
  }
}