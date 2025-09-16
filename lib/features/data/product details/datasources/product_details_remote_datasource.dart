import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/product_details_model.dart';
import '../models/variant_product_price_model.dart';

// Update ProductDetailsRemoteDataSource
abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetails(String slug);
  Future<VariantPriceModel> getVariantPrice(String slug, String color, String variants, int quantity);
}

// Update ProductDetailsRemoteDataSourceImpl
class ProductDetailsRemoteDataSourceImpl implements ProductDetailsRemoteDataSource {
  final ApiProvider apiProvider;

  ProductDetailsRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<ProductDetailsModel> getProductDetails(String slug) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.productDetails}/$slug/${AppStrings.userId}',
    );

    if (response.data != null && response.data['data'] is List && response.data['data'].isNotEmpty) {
      return ProductDetailsModel.fromJson(response.data['data'][0]);
    } else {
      throw Exception('Product details not found or invalid response format');
    }
  }

  @override
  Future<VariantPriceModel> getVariantPrice(String slug, String color, String variants, int quantity) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.getVariantPrice,
      queryParameters: {
        'slug': slug,
        'color': color,
        'variants': variants,
        'quantity': quantity,
      },
    );

    if (response.data != null) {
      return VariantPriceModel.fromJson(response.data);
    } else {
      throw Exception('Variant price not found or invalid response format');
    }
  }
}