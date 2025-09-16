import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Map<String, dynamic>> call(int productId, String variant, int quantity, String color) async {
    return await repository.addToCart(productId, variant, quantity, color);
  }
}