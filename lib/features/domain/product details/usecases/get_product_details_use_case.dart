import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository productDetailsRepository;

  GetProductDetailsUseCase(this.productDetailsRepository);

  Future<ProductDetails> call(String slug) async {
    final productModel = await productDetailsRepository.getProductDetails(slug);
    return productModel.toEntity();
  }
}