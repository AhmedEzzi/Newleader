import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetTopFromThisSellerProductsUseCase {
  final ProductRepository productRepository;

  GetTopFromThisSellerProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id,{bool needUpdate = false}) async {
    return await productRepository.getTopFromThisSellerProducts(id,needUpdate: needUpdate);
  }
}