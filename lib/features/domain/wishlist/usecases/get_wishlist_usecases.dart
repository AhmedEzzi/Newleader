import '../entities/wishlist_details.dart';
import '../repositories/wishlist_details_repository.dart';

class GetWishlistUseCase {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  Future<List<WishlistItem>> call() async {
    return await repository.getWishlist();
  }
}