import '../repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  Future<void> call(int cartId) async {
    await repository.deleteCartItem(cartId);
  }
}