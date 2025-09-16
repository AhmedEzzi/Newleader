import '../../../data/product details/models/product_details_model.dart';
import '../../../data/product details/models/variant_product_price_model.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetailsModel> getProductDetails(String slug);
  Future<VariantPriceModel> getVariantPrice(String slug, String color, String variants, int quantity);
}
