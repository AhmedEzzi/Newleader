import '../repositories/cart_repository.dart';

class GetCartCountUseCase {
  final CartRepository repository;

  GetCartCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getCartCount();
  }
}