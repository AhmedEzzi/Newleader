import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetBestSellingProductsUseCase {
  final ProductRepository productRepository;

  GetBestSellingProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page,{ bool needUpdate = false}) async {
    return await productRepository.getBestSellingProducts(page,needUpdate: needUpdate);
  }
}