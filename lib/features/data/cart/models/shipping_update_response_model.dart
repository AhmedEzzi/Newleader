import '../../../domain/cart/entities/shipping_update_response.dart';

class ShippingUpdateResponseModel {
  final bool result;
  final String message;

  ShippingUpdateResponseModel({
    required this.result,
    required this.message,
  });

  factory ShippingUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ShippingUpdateResponseModel(
      result: json['result'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
    };
  }
  
  ShippingUpdateResponse toEntity() {
    return ShippingUpdateResponse(
      result: result,
      message: message,
    );
  }
}
