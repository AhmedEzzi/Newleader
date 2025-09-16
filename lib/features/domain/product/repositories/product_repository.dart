import '../../../data/product/models/flash_deal_response_model.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<ProductsResponse> getAllProducts(int page, {String? name, bool needUpdate = false});
  Future<ProductsResponse> getFeaturedProducts(int page, {bool needUpdate = false});
  Future<ProductsResponse> getBestSellingProducts(int page, {bool needUpdate = false});
  Future<ProductsResponse> getNewAddedProducts(int page, {bool needUpdate = false});
  Future<ProductsResponse> getTodaysDealProducts({bool needUpdate = false});
  Future<FlashDealResponseModel> getFlashDealProducts({bool needUpdate = false});
  Future<ProductsResponse> getCategoryProducts(int id, int page, {String? name, bool needUpdate = false});
  Future<ProductsResponse> getSubCategoryProducts(int id, int page, {String? name, bool needUpdate = false});
  Future<ProductsResponse> getShopProducts(int id, int page, {String? name, bool needUpdate = false});
  Future<ProductsResponse> getBrandProducts(String slug, int page, {String? name, bool needUpdate = false});
  Future<ProductsResponse> getDigitalProducts(int page, {bool needUpdate = false});
  Future<Product> getDigitalProductDetails(int id);
  Future<ProductsResponse> getRelatedProducts(int id, {bool needUpdate = false});
  Future<ProductsResponse> getTopFromThisSellerProducts(int id, {bool needUpdate = false});
}