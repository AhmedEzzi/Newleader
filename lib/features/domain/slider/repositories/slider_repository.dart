
import '../../../data/slider/model/slider_model.dart';

abstract class SliderRepository {
  Future<SliderResponseModel> getSliders({bool refresh = false});
}