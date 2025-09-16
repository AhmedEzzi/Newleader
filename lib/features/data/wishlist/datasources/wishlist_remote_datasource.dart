import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/wishlist_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<WishlistCheckModel> checkWishlist(String slug);
  Future<WishlistCheckModel> addToWishlist(String slug);
  Future<WishlistCheckModel> removeFromWishlist(String slug);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiProvider apiProvider;

  WishlistRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await apiProvider.get(LaravelApiEndPoint.wishlist);
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => WishlistItemModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid wishlist response format');
  }

  @override
  Future<WishlistCheckModel> checkWishlist(String slug) async {
    final response = await apiProvider.get(
        '${LaravelApiEndPoint.wishlistCheck}$slug');
    if (response.data != null) {
      return WishlistCheckModel.fromJson(response.data);
    }
    throw Exception('Invalid wishlist check response');
  }

  @override
  Future<WishlistCheckModel> addToWishlist(String slug) async {
    final response = await apiProvider.get('${LaravelApiEndPoint.wishlistAdd}$slug');
    if (response.data != null) {
      return WishlistCheckModel.fromJson(response.data);
    }
    throw Exception('Invalid add to wishlist response');
  }

  @override
  Future<WishlistCheckModel> removeFromWishlist(String slug) async {
    final response = await apiProvider.get('${LaravelApiEndPoint.wishlistRemove}$slug');
    if (response.data != null) {
      return WishlistCheckModel.fromJson(response.data);
    }
    throw Exception('Invalid remove from wishlist response');
  }
}