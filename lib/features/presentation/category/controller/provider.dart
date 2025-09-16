import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../features/domain/category/usecases/get_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_featured_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_top_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_filter_page_categories_use_case.dart';
import '../../../data/category/models/category_model.dart';
import '../../../domain/category/usecases/get_sub_category_usecase.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFeaturedCategoriesUseCase getFeaturedCategoriesUseCase;
  final GetTopCategoriesUseCase getTopCategoriesUseCase;
  final GetFilterPageCategoriesUseCase getFilterPageCategoriesUseCase;
  final GetSubCategoriesUseCase getSubCategoriesUseCase;

  LoadingState categoriesState = LoadingState.initial;
  LoadingState featuredCategoriesState = LoadingState.initial;
  LoadingState topCategoriesState = LoadingState.initial;
  LoadingState filterPageCategoriesState = LoadingState.initial;
  LoadingState subCategoriesState = LoadingState.initial;

  CategoryResponseModel? categoriesResponse;
  CategoryResponseModel? featuredCategoriesResponse;
  CategoryResponseModel? topCategoriesResponse;
  CategoryResponseModel? filterPageCategoriesResponse;
  CategoryResponseModel? subCategoriesResponse;

  String? errorMessage;

  CategoryProvider({
    required this.getCategoriesUseCase,
    required this.getFeaturedCategoriesUseCase,
    required this.getTopCategoriesUseCase,
    required this.getFilterPageCategoriesUseCase,
    required this.getSubCategoriesUseCase,
  });

  Future<void> getCategories({String? parentId, bool needRefresh = false}) async {
    categoriesState = LoadingState.loading;
    notifyListeners();

    try {
      categoriesResponse = await getCategoriesUseCase(
          parentId: parentId,
          needRefresh: needRefresh
      );
      categoriesState = LoadingState.loaded;
    } catch (e) {
      categoriesState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getFeaturedCategories({bool needRefresh = false}) async {
    featuredCategoriesState = LoadingState.loading;
    notifyListeners();

    try {
      featuredCategoriesResponse = await getFeaturedCategoriesUseCase(
          needRefresh: needRefresh
      );
      featuredCategoriesState = LoadingState.loaded;
    } catch (e) {
      featuredCategoriesState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getTopCategories({bool needRefresh = false}) async {
    topCategoriesState = LoadingState.loading;
    notifyListeners();

    try {
      topCategoriesResponse = await getTopCategoriesUseCase(
          needRefresh: needRefresh
      );
      topCategoriesState = LoadingState.loaded;
    } catch (e) {
      topCategoriesState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getFilterPageCategories({bool needRefresh = false}) async {
    filterPageCategoriesState = LoadingState.loading;
    notifyListeners();

    try {
      filterPageCategoriesResponse = await getFilterPageCategoriesUseCase(
          needRefresh: needRefresh
      );
      filterPageCategoriesState = LoadingState.loaded;
    } catch (e) {
      filterPageCategoriesState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getSubCategories({required String mainCategoryId, bool needRefresh = false}) async {
    subCategoriesState = LoadingState.loading;
    notifyListeners();

    try {
      subCategoriesResponse = await getSubCategoriesUseCase(
          mainCategoryId: mainCategoryId,
          needRefresh: needRefresh
      );
      subCategoriesState = LoadingState.loaded;
    } catch (e) {
      subCategoriesState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Special method for language change - refresh all category data
  Future<void> refreshAfterLanguageChange() async {
    // Set all states to loading
    categoriesState = LoadingState.loading;
    featuredCategoriesState = LoadingState.loading;
    topCategoriesState = LoadingState.loading;
    filterPageCategoriesState = LoadingState.loading;
    notifyListeners();
    
    // Force refresh all category data
    try {
      await Future.wait([
        getCategories(needRefresh: true),
        getFeaturedCategories(needRefresh: true),
        getTopCategories(needRefresh: true),
        getFilterPageCategories(needRefresh: true),
      ]);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Error refreshing categories after language change: $e');
    }
    
    notifyListeners();
  }
}