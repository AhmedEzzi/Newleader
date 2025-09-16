import '../../product/entities/product.dart';
import '../repositories/search_repository.dart';

class GetFilteredProductsUseCase {
  final SearchRepository searchRepository;

  GetFilteredProductsUseCase(this.searchRepository);

  Future<ProductsResponse> call(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      }) async {
    return await searchRepository.getFilteredProducts(
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