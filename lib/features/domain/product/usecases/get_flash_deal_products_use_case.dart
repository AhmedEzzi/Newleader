import '../../../data/product/models/flash_deal_response_model.dart';
import '../repositories/product_repository.dart';

class GetFlashDealProductsUseCase {
  final ProductRepository productRepository;

  GetFlashDealProductsUseCase(this.productRepository);

  Future<FlashDealResponseModel> call({bool needUpdate = false}) async {
    return await productRepository.getFlashDealProducts(needUpdate: true);
  }
}
