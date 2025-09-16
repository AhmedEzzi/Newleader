import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetDigitalProductsUseCase {
  final ProductRepository productRepository;

  GetDigitalProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page,{bool needUpdate = false}) async {
    return await productRepository.getDigitalProducts(page,needUpdate: needUpdate);
  }
}