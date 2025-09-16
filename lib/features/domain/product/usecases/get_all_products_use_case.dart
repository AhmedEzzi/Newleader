import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository productRepository;

  GetAllProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page, {String? name, bool needUpdate = false}) async {
    return await productRepository.getAllProducts(page, name: name, needUpdate: needUpdate);
  }
}