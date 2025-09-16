import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartSummaryUseCase {
  final CartRepository repository;

  GetCartSummaryUseCase(this.repository);

  Future<CartSummary> call() async {
    return await repository.getCartSummary();
  }
}