import '../../../domain/brand/entities/brand.dart';
import '../../../domain/brand/repositories/brand_repository.dart';
import '../datasources/brand_remote_datasource.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;

  BrandRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Brand>> getFilterPageBrands() async {
    final response = await remoteDataSource.getFilterPageBrands();
    return response.toEntities();
  }

  @override
  Future<List<Brand>> getBrands({String name = '', int page = 1}) async {
    final response = await remoteDataSource.getBrands(name: name, page: page);
    return response.toEntities();
  }

  @override
  Future<int> getTotalBrandPages({String name = ''}) async {
    final response = await remoteDataSource.getBrands(name: name);
    return response.totalPages;
  }
}