import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetTodaysDealProductsUseCase {
  final ProductRepository productRepository;

  GetTodaysDealProductsUseCase(this.productRepository);

  Future<ProductsResponse> call({bool needUpdate = false}) async {
    return await productRepository.getTodaysDealProducts(needUpdate: needUpdate);
  }
}