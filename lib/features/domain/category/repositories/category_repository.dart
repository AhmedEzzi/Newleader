import '../../../data/category/models/category_model.dart';

abstract class CategoryRepository {
  Future<CategoryResponseModel> getCategories({String? parentId, bool needRefresh = false});
  Future<CategoryResponseModel> getFeaturedCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getTopCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getFilterPageCategories({bool needRefresh = false});
  Future<CategoryResponseModel> getSubCategories({required String mainCategoryId, bool needRefresh = false});
}