import '../../../domain/category/repositories/category_repository.dart';
import '../datasources/category_cach_managment.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;

  CategoryRepositoryImpl(this.categoryRemoteDataSource);

  @override
  Future<CategoryResponseModel> getCategories({String? parentId, bool needRefresh = false}) async {
    // Try to get from cache if refresh is not needed
    if (!needRefresh) {
      final cachedData = await CategoryCacheManager.getCategories(parentId: parentId);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from API
    final response = await categoryRemoteDataSource.getCategories(parentId: parentId);

    // Save to cache
    await CategoryCacheManager.saveCategories(response, parentId: parentId);

    return response;
  }

  @override
  Future<CategoryResponseModel> getFeaturedCategories({bool needRefresh = false}) async {
    // Try to get from cache if refresh is not needed
    if (!needRefresh) {
      final cachedData = await CategoryCacheManager.getFeaturedCategories();
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from API
    final response = await categoryRemoteDataSource.getFeaturedCategories();

    // Save to cache
    await CategoryCacheManager.saveFeaturedCategories(response);

    return response;
  }

  @override
  Future<CategoryResponseModel> getTopCategories({bool needRefresh = false}) async {
    // Try to get from cache if refresh is not needed
    if (!needRefresh) {
      final cachedData = await CategoryCacheManager.getTopCategories();
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from API
    final response = await categoryRemoteDataSource.getTopCategories();

    // Save to cache
    await CategoryCacheManager.saveTopCategories(response);

    return response;
  }

  @override
  Future<CategoryResponseModel> getFilterPageCategories({bool needRefresh = false}) async {
    // Try to get from cache if refresh is not needed
    if (!needRefresh) {
      final cachedData = await CategoryCacheManager.getFilterPageCategories();
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from API
    final response = await categoryRemoteDataSource.getFilterPageCategories();

    // Save to cache
    await CategoryCacheManager.saveFilterPageCategories(response);

    return response;
  }

  @override
  Future<CategoryResponseModel> getSubCategories({required String mainCategoryId, bool needRefresh = false}) async {
    // Try to get from cache if refresh is not needed
    if (!needRefresh) {
      final cachedData = await CategoryCacheManager.getSubCategories(mainCategoryId);
      if (cachedData != null) {
        return cachedData;
      }
    }

    // Fetch from API
    final response = await categoryRemoteDataSource.getSubCategories(mainCategoryId: mainCategoryId);

    // Save to cache
    await CategoryCacheManager.saveSubCategories(mainCategoryId, response);

    return response;
  }
}