import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetBrandProductsUseCase {
  final ProductRepository productRepository;

  GetBrandProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(String slug, int page, {String? name, bool needUpdate = false}) async {
    return await productRepository.getBrandProducts(slug, page, name: name,needUpdate: needUpdate);
  }
}