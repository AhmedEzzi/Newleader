import '../repositories/brand_repository.dart';

class GetTotalBrandPagesUseCase {
  final BrandRepository repository;

  GetTotalBrandPagesUseCase(this.repository);

  Future<int> call({String name = ''}) async {
    return await repository.getTotalBrandPages(name: name);
  }
}