import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryResponseModel> getCategories({String? parentId, bool needRefresh = false});
  Future<CategoryResponseModel> getFeaturedCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getTopCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getFilterPageCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getSubCategories({required String mainCategoryId, bool needRefresh = false});
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiProvider apiProvider;

  CategoryRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<CategoryResponseModel> getCategories({String? parentId, bool needRefresh = false}) async {
    final Map<String, dynamic> queryParams = {};
    if (parentId != null) {
      queryParams['parent_id'] = parentId;
    }

    final response = await apiProvider.get(
      LaravelApiEndPoint.categories,
      queryParameters: queryParams,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getFeaturedCategories({bool needRefresh = false}) async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.featuredCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getTopCategories({bool needRefresh = false}) async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.topCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getFilterPageCategories({bool needRefresh = false}) async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.filterPageCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getSubCategories({required String mainCategoryId, bool needRefresh = false}) async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.subCategory+mainCategoryId,
    );
    return CategoryResponseModel.fromJson(response.data);
  }
}