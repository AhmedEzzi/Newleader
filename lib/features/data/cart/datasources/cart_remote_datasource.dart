import 'package:leader_company/core/utils/constants/app_strings.dart';

import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/local_storage/local_storage_keys.dart';
import '../models/cart_model.dart';
import '../models/shipping_update_response_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<CartCountModel> getCartCount();

  Future<void> deleteCartItem(int cartId);

  Future<void> clearCart();

  Future<void> updateCartQuantities(String cartIds, String quantities);

  Future<Map<String, dynamic>> addToCart(int productId, String variant, int quantity, String color);

  Future<CartSummaryModel> getCartSummary();

}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  CartRemoteDataSourceImpl(this.apiProvider, this.secureStorage);

  Future<Map<String, dynamic>> _getUserParams() async {
    return {
      if (AppStrings.userId == null && AppStrings.tempUserId != null)
        'temp_user_id': AppStrings.tempUserId,
      if (AppStrings.userId != null) 'user_id': AppStrings.userId.toString(),
    };
  }


  @override
  Future<List<CartItemModel>> getCartItems() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cart,
      data: await _getUserParams(),
    );

    if (response.data != null && response.data['data'] is List) {
      // Extract all cart items from all groups
      List<CartItemModel> allItems = [];
      final groups = response.data['data'] as List;

      for (var group in groups) {
        if (group['cart_items'] is List) {
          final items = (group['cart_items'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList();
          allItems.addAll(items);
        }
      }

      return allItems;
    }

    throw Exception('Invalid cart response format');
  }

  @override
  Future<CartSummaryModel> getCartSummary() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartSummary,
      data: await _getUserParams(),
    );

    if (response.data != null) {
      return CartSummaryModel.fromJson(response.data);
    }

    throw Exception('Invalid cart summary response');
  }

  @override
  Future<CartCountModel> getCartCount() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartCount,
      data: await _getUserParams(),
    );

    if (response.data != null) {
      return CartCountModel.fromJson(response.data);
    }

    throw Exception('Invalid cart count response');
  }

  @override
  Future<void> deleteCartItem(int cartId) async {
    await apiProvider.delete('${LaravelApiEndPoint.cart}/$cartId');
  }

  @override
  Future<void> clearCart() async {
    await apiProvider.post(
      LaravelApiEndPoint.clearCart,
      data: await _getUserParams(),
    );
  }

  @override
  Future<void> updateCartQuantities(String cartIds, String quantities) async {
    await apiProvider.post(
      LaravelApiEndPoint.cartProcess,
      data: {'cart_ids': cartIds, 'cart_quantities': quantities},
    );
  }

  @override
  Future<Map<String, dynamic>> addToCart(
      int productId,
      String variant,
      int quantity,
      String color
      ) async {
    final userParams = await _getUserParams();
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartAdd,
      data: {
        'id': productId.toString(),
        'variant': variant,
        'color' : color,
        'quantity': quantity.toString(),
        ...userParams,
      },
    );

    // Check for temp_user_id and save it if provided
    if (response.data != null && response.data['temp_user_id'] != null) {
      await SecureStorage().save(
        LocalStorageKey.tempUserId,
        response.data['temp_user_id'],
      );
    }

    // Return the full response data
    return response.data;
  }

}
