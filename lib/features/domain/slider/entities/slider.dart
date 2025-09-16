import 'package:equatable/equatable.dart';

class Slider extends Equatable {
  final String? photo;
  final String? url;

  const Slider({
    required this.photo,
    required this.url,
  });

  @override
  List<Object?> get props => [
    photo,
    url,
  ];
}

class SliderResponse extends Equatable {
  final List<Slider> data;
  final bool? success;
  final int? status;

  const SliderResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  @override
  List<Object?> get props => [
    data,
    success,
    status,
  ];
}