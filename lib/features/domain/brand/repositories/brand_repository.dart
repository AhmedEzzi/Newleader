import '../entities/brand.dart';

abstract class BrandRepository {
  Future<List<Brand>> getFilterPageBrands();
  Future<List<Brand>> getBrands({String name = '', int page = 1});
  Future<int> getTotalBrandPages({String name = ''});
}