import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/flash_deal_response_model.dart';
import '../models/product_model.dart';
import '../models/product_response_model.dart';

abstract class ProductRemoteDataSource {

  Future<ProductResponseModel> getAllProducts(int page, {String? name});

  Future<ProductResponseModel> getFeaturedProducts(int page);

  Future<ProductResponseModel> getBestSellingProducts(int page);

  Future<ProductResponseModel> getNewAddedProducts(int page);

  Future<ProductResponseModel> getTodaysDealProducts();

  Future<FlashDealResponseModel> getFlashDealProducts();

  Future<ProductResponseModel> getCategoryProducts(
    int id,
    int page, {
    String? name,
  });

  Future<ProductResponseModel> getSubCategoryProducts(
      int id,
      int page, {
        String? name,
      });

  Future<ProductResponseModel> getShopProducts(
    int id,
    int page, {
    String? name,
  });

  Future<ProductResponseModel> getBrandProducts(
    String slug,
    int page, {
    String? name,
  });


  Future<ProductResponseModel> getDigitalProducts(int page);

  Future<ProductModel> getDigitalProductDetails(int id);

  Future<ProductResponseModel> getRelatedProducts(int id);

  Future<ProductResponseModel> getTopFromThisSellerProducts(int id);

}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiProvider apiProvider;

  ProductRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<ProductResponseModel> getAllProducts(int page, {String? name}) async {
    String url = '${LaravelApiEndPoint.allProducts}?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getFeaturedProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.featuredProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getBestSellingProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.bestSellerProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getNewAddedProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.newAddedProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getTodaysDealProducts() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.todaysDealProducts,
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<FlashDealResponseModel> getFlashDealProducts() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.flashDealProducts,
    );
    return FlashDealResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getCategoryProducts(
    int id,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.categoryProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getSubCategoryProducts(
      int id,
      int page, {
        String? name,
      }) async {
    String url = '${LaravelApiEndPoint.subCategoryProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getShopProducts(
    int id,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.shopProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getBrandProducts(
      String slug,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.brandProducts}$slug?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }



  @override
  Future<ProductResponseModel> getDigitalProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.digitalProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }


  @override
  Future<ProductModel> getDigitalProductDetails(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.productDetails}$id/digital',
    );
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getRelatedProducts(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.relatedProducts}$id',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getTopFromThisSellerProducts(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.topFromSellerProducts}$id',
    );
    return ProductResponseModel.fromJson(response.data);
  }

}
