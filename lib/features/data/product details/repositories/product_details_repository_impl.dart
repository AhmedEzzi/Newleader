import '../../../domain/product details/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_datasource.dart';
import '../models/product_details_model.dart';
import '../models/variant_product_price_model.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductDetailsModel> getProductDetails(String slug) async {
    return await remoteDataSource.getProductDetails(slug);
  }

  @override
  Future<VariantPriceModel> getVariantPrice(String slug, String color, String variants, int quantity) async {
    return await remoteDataSource.getVariantPrice(slug, color, variants, quantity);
  }
}