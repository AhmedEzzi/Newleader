import '../repositories/cart_repository.dart';

class UpdateCartQuantitiesUseCase {
  final CartRepository repository;

  UpdateCartQuantitiesUseCase(this.repository);

  Future<void> call(String cartIds, String quantities) async {
    await repository.updateCartQuantities(cartIds, quantities);
  }
}