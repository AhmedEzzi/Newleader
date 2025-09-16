import '../../../data/slider/model/slider_model.dart';
import '../repositories/slider_repository.dart';

class GetSlidersUseCase {
  final SliderRepository sliderRepository;

  GetSlidersUseCase(this.sliderRepository);

  Future<SliderResponseModel> call({bool refresh = false}) async {
    return await sliderRepository.getSliders(refresh: refresh);
  }
}