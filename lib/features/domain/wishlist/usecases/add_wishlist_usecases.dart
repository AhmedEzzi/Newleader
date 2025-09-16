import '../entities/wishlist_details.dart';
import '../repositories/wishlist_details_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<WishlistCheck> call(String slug) async {
    return await repository.addToWishlist(slug);
  }
}