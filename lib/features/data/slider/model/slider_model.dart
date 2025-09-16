import '../../../domain/slider/entities/slider.dart';

class SliderResponseModel {
  final List<SliderModel> data;
  final bool? success;
  final int? status;

  SliderResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory SliderResponseModel.fromJson(Map<String, dynamic> json) {
    return SliderResponseModel(
      data: json["data"] == null
          ? []
          : List<SliderModel>.from(json["data"]!.map((x) => SliderModel.fromJson(x))),
      success: json["success"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'success': success,
      'status': status,
    };
  }
}

class SliderModel extends Slider {
  const SliderModel({
    required super.photo,
    required super.url,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      photo: json["photo"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'url': url,
    };
  }
}