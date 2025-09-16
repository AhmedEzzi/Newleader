import '../entities/cart.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<int> getCartCount();
  Future<void> deleteCartItem(int cartId);
  Future<void> clearCart();
  Future<void> updateCartQuantities(String cartIds, String quantities);
  Future<Map<String, dynamic>> addToCart(int productId, String variant, int quantity, String color);
  Future<CartSummary> getCartSummary();
}