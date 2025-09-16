import '../../../domain/cart/entities/cart.dart';
import '../../../domain/cart/entities/shipping_update_response.dart';
import '../../../domain/cart/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CartItem>> getCartItems() async {
    final models = await remoteDataSource.getCartItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<int> getCartCount() async {
    final model = await remoteDataSource.getCartCount();
    return model.count;
  }

  @override
  Future<void> deleteCartItem(int cartId) async {
    await remoteDataSource.deleteCartItem(cartId);
  }

  @override
  Future<void> clearCart() async {
    await remoteDataSource.clearCart();
  }

  @override
  Future<void> updateCartQuantities(String cartIds, String quantities) async {
    await remoteDataSource.updateCartQuantities(cartIds, quantities);
  }

  @override
  Future<Map<String, dynamic>> addToCart(int productId, String variant, int quantity, String color) async {
    return await remoteDataSource.addToCart(productId, variant, quantity, color);
  }

  @override
  Future<CartSummary> getCartSummary() async {
    final model = await remoteDataSource.getCartSummary();
    return model.toEntity();
  }

}