import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetSubCategoryProductsUseCase {
  final ProductRepository productRepository;

  GetSubCategoryProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id, int page, {String? name, bool needUpdate = false}) async {
    return await productRepository.getSubCategoryProducts(id, page, name: name,needUpdate: needUpdate);
  }
}