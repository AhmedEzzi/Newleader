import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class GetBrandsUseCase {
  final BrandRepository repository;

  GetBrandsUseCase(this.repository);

  Future<List<Brand>> call({String name = '', int page = 1}) async {
    return await repository.getBrands(name: name, page: page);
  }
}