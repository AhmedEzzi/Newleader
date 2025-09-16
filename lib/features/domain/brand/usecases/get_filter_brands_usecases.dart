import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class GetFilterPageBrandsUseCase {
  final BrandRepository repository;

  GetFilterPageBrandsUseCase(this.repository);

  Future<List<Brand>> call() async {
    return await repository.getFilterPageBrands();
  }
}