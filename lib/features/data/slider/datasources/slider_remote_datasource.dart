import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../model/slider_model.dart';

abstract class SliderRemoteDataSource {
  Future<SliderResponseModel> getSliders();
}

class SliderRemoteDataSourceImpl implements SliderRemoteDataSource {
  final ApiProvider apiProvider;

  SliderRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<SliderResponseModel> getSliders() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.sliders,
    );
    return SliderResponseModel.fromJson(response.data);
  }
}