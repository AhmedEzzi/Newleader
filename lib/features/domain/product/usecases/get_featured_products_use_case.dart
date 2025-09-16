import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFeaturedProductsUseCase {
  final ProductRepository productRepository;

  GetFeaturedProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page,{bool needUpdate = false}) async {
    return await productRepository.getFeaturedProducts(page,needUpdate: needUpdate);
  }
}