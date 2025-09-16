
import '../entities/variant_product_price.dart';
import '../repositories/product_details_repository.dart';

class GetVariantPriceUseCase {
  final ProductDetailsRepository productDetailsRepository;

  GetVariantPriceUseCase(this.productDetailsRepository);

  Future<VariantPrice> call(String slug, String color, String variants, int quantity) async {
    final variantPriceModel = await productDetailsRepository.getVariantPrice(slug, color, variants, quantity);
    return variantPriceModel.toEntity();
  }
}