import '../entities/wishlist_details.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<WishlistCheck> checkWishlist(String slug);
  Future<WishlistCheck> addToWishlist(String slug);
  Future<WishlistCheck> removeFromWishlist(String slug);
}