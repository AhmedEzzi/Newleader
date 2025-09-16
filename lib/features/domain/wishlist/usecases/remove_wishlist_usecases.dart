import '../entities/wishlist_details.dart';
import '../repositories/wishlist_details_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<WishlistCheck> call(String slug) async {
    return await repository.removeFromWishlist(slug);
  }
}