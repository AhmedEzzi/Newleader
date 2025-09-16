import '../../../data/search/models/search_suggestion_model.dart';
import '../../product/entities/product.dart';

abstract class SearchRepository {
  Future<List<SearchSuggestion>> getSearchSuggestions(String query);
  Future<ProductsResponse> getFilteredProducts(int page, {String? name, String? sortKey, String? brands, String? categories, double? min, double? max});

}