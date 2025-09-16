import '../../../../core/database/timestamp_service.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/flash_deal_response_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final TimestampService timestampService;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.timestampService,
  });

  @override
  Future<ProductsResponse> getAllProducts(int page, {String? name, bool needUpdate = false}) async {
    // If searching by name or needUpdate is true, always go to remote
    if ((name != null && name.isNotEmpty) || needUpdate) {
      final response = await remoteDataSource.getAllProducts(page, name: name);
      if (needUpdate && (name == null || name.isEmpty)) {
        // Update cache when not searching by name
        await localDataSource.saveCollection('all_products', page, response);
      }
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('all_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('all_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getAllProducts(page);
    await localDataSource.saveCollection('all_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getFeaturedProducts(int page, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getFeaturedProducts(page);
      await localDataSource.saveCollection('featured_products', page, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('featured_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('featured_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getFeaturedProducts(page);
    await localDataSource.saveCollection('featured_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getBestSellingProducts(int page, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getBestSellingProducts(page);
      await localDataSource.saveCollection('best_selling_products', page, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('best_selling_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('best_selling_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getBestSellingProducts(page);
    await localDataSource.saveCollection('best_selling_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getNewAddedProducts(int page, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getNewAddedProducts(page);
      await localDataSource.saveCollection('new_added_products', page, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('new_added_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('new_added_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getNewAddedProducts(page);
    await localDataSource.saveCollection('new_added_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getTodaysDealProducts({bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getTodaysDealProducts();
      await localDataSource.saveCollection('todays_deal_products', 1, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('todays_deal_products', 1);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('todays_deal_products', 1);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getTodaysDealProducts();
    await localDataSource.saveCollection('todays_deal_products', 1, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<FlashDealResponseModel> getFlashDealProducts({bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getFlashDealProducts();
      await localDataSource.saveFlashDealCollection('flash_deal_products', 1, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('flash_deal_products', 1);

    if (isCacheValid) {
      final cachedData = await localDataSource.getFlashDealsFromCache('flash_deal_products', 1);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getFlashDealProducts();
    await localDataSource.saveFlashDealCollection('flash_deal_products', 1, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getCategoryProducts(int id, int page, {String? name, bool needUpdate = false}) async {
    // If searching by name or needUpdate is true, always go to remote
    if ((name != null && name.isNotEmpty) || needUpdate) {
      final response = await remoteDataSource.getCategoryProducts(id, page, name: name);
      if (needUpdate && (name == null || name.isEmpty)) {
        // Update cache when not searching by name
        await localDataSource.saveCollection('category_${id}_products', page, response);
      }
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('category_${id}_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('category_${id}_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getCategoryProducts(id, page);
    await localDataSource.saveCollection('category_${id}_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getSubCategoryProducts(int id, int page, {String? name, bool needUpdate = false}) async {
    // If searching by name or needUpdate is true, always go to remote
    if ((name != null && name.isNotEmpty) || needUpdate) {
      final response = await remoteDataSource.getSubCategoryProducts(id, page, name: name);
      if (needUpdate && (name == null || name.isEmpty)) {
        // Update cache when not searching by name
        await localDataSource.saveCollection('subcategory_${id}_products', page, response);
      }
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('subcategory_${id}_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('subcategory_${id}_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getSubCategoryProducts(id, page);
    await localDataSource.saveCollection('subcategory_${id}_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getShopProducts(int id, int page, {String? name, bool needUpdate = false}) async {
    // If searching by name or needUpdate is true, always go to remote
    if ((name != null && name.isNotEmpty) || needUpdate) {
      final response = await remoteDataSource.getShopProducts(id, page, name: name);
      if (needUpdate && (name == null || name.isEmpty)) {
        // Update cache when not searching by name
        await localDataSource.saveCollection('shop_${id}_products', page, response);
      }
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('shop_${id}_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('shop_${id}_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getShopProducts(id, page);
    await localDataSource.saveCollection('shop_${id}_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getBrandProducts(String slug, int page, {String? name, bool needUpdate = false}) async {
    // If searching by name or needUpdate is true, always go to remote
    if ((name != null && name.isNotEmpty) || needUpdate) {
      final response = await remoteDataSource.getBrandProducts(slug, page, name: name);
      if (needUpdate && (name == null || name.isEmpty)) {
        // Update cache when not searching by name
        await localDataSource.saveCollection('brand_${slug}_products', page, response);
      }
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('brand_${slug}_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('brand_${slug}_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getBrandProducts(slug, page);
    await localDataSource.saveCollection('brand_${slug}_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getDigitalProducts(int page, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getDigitalProducts(page);
      await localDataSource.saveCollection('digital_products', page, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('digital_products', page);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('digital_products', page);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getDigitalProducts(page);
    await localDataSource.saveCollection('digital_products', page, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<Product> getDigitalProductDetails(int id) async {
    // For details, we won't use cache since it might need to be fresh
    return await remoteDataSource.getDigitalProductDetails(id);
  }

  @override
  Future<ProductsResponse> getRelatedProducts(int id, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getRelatedProducts(id);
      await localDataSource.saveCollection('related_${id}_products', 1, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('related_${id}_products', 1);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('related_${id}_products', 1);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getRelatedProducts(id);
    await localDataSource.saveCollection('related_${id}_products', 1, remoteResponse);
    return remoteResponse;
  }

  @override
  Future<ProductsResponse> getTopFromThisSellerProducts(int id, {bool needUpdate = false}) async {
    // If needUpdate is true, always go to remote
    if (needUpdate) {
      final response = await remoteDataSource.getTopFromThisSellerProducts(id);
      await localDataSource.saveCollection('top_seller_${id}_products', 1, response);
      return response;
    }

    // Check if cache is valid
    final isCacheValid = await localDataSource.isCollectionCacheValid('top_seller_${id}_products', 1);

    if (isCacheValid) {
      final cachedData = await localDataSource.getCollectionFromCache('top_seller_${id}_products', 1);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Get data from remote and cache it
    final remoteResponse = await remoteDataSource.getTopFromThisSellerProducts(id);
    await localDataSource.saveCollection('top_seller_${id}_products', 1, remoteResponse);
    return remoteResponse;
  }
}