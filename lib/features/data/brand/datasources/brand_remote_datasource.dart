import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/brand_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class BrandRemoteDataSource {
  Future<BrandResponseModel> getFilterPageBrands();
  Future<BrandResponseModel> getBrands({String name = '', int page = 1});
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  BrandRemoteDataSourceImpl(this.apiProvider, this.secureStorage);


  @override
  Future<BrandResponseModel> getFilterPageBrands() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.filterBrands,
    );
    if (response.data != null) {
      return BrandResponseModel.fromJson(response.data);
    }
    throw Exception('Invalid filter brands response');
  }

  @override
  Future<BrandResponseModel> getBrands({String name = '', int page = 1}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.brands}?page=$page&name=$name',
    );
    if (response.data != null) {
      return BrandResponseModel.fromJson(response.data);
    }
    throw Exception('Invalid brands response');
  }
}