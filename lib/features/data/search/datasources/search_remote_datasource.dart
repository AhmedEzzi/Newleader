import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../product/models/product_response_model.dart';
import '../models/search_suggestion_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchSuggestion>> getSearchSuggestions(String query);
  Future<ProductResponseModel> getFilteredProducts(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiProvider apiProvider;

  SearchRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.searchSuggestions,
      queryParameters: {'type': 'product', 'query': query},
    );

    return (response.data as List)
        .map((item) => SearchSuggestion.fromJson(item))
        .toList();
  }

  @override
  Future<ProductResponseModel> getFilteredProducts(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      }) async {
    Map<String, dynamic> queryParams = {'page': page.toString()};

    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (sortKey != null && sortKey.isNotEmpty) {
      queryParams['sort_key'] = sortKey;
    }
    if (brands != null && brands.isNotEmpty) queryParams['brands'] = brands;
    if (categories != null && categories.isNotEmpty) {
      queryParams['categories'] = categories;
    }
    if (min != null) queryParams['min'] = min.toString();
    if (max != null) queryParams['max'] = max.toString();

    final response = await apiProvider.get(
      LaravelApiEndPoint.filteredProducts,
      queryParameters: queryParams,
    );
    return ProductResponseModel.fromJson(response.data);
  }
}