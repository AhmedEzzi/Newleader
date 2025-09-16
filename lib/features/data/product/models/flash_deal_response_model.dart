import 'package:leader_company/features/data/product/models/flash_deal_model.dart';

class FlashDealResponseModel {
  final List<FlashDealModel> data;
  final bool success;
  final int status;

  FlashDealResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory FlashDealResponseModel.fromJson(Map<String, dynamic> json) {
    return FlashDealResponseModel(
      data: json['data'] == null
          ? []
          : List<FlashDealModel>.from(
              json['data'].map((x) => FlashDealModel.fromJson(x))),
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
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