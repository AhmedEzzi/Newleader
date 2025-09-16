import '../../../domain/product/entities/product.dart';
import '../../../domain/search/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_suggestion_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    return await remoteDataSource.getSearchSuggestions(query);
  }

  @override
  Future<ProductsResponse> getFilteredProducts(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      }) async {
    return await remoteDataSource.getFilteredProducts(
      page,
      name: name,
      sortKey: sortKey,
      brands: brands,
      categories: categories,
      min: min,
      max: max,
    );
  }

}