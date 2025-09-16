import '../entities/wishlist_details.dart';
import '../repositories/wishlist_details_repository.dart';

class CheckWishlistUseCase {
  final WishlistRepository repository;

  CheckWishlistUseCase(this.repository);

  Future<WishlistCheck> call(String slug) async {
    return await repository.checkWishlist(slug);
  }
}