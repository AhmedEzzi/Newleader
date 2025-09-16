import '../../../../core/utils/types/meta_response.dart';
import '../../../domain/club_point/entities/club_point.dart';

class ClubPointResponse {
  final List<ClubPointModel> data;
  final Meta meta;
  final bool success;
  final int status;

  ClubPointResponse({
    required this.data,
    required this.meta,
    required this.success,
    required this.status,
  });

  factory ClubPointResponse.fromJson(Map<String, dynamic> json) {
    return ClubPointResponse(
      data: (json['data'] as List).map((item) => ClubPointModel.fromJson(item)).toList(),
      meta: Meta.fromJson(json['meta']),
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}

class ClubPointModel extends ClubPoint {
  const ClubPointModel({
    required int id,
    required int userId,
    required String orderCode,
    required int points,
    required DateTime convertedAt,
  }) : super(
          id: id,
          userId: userId,
          orderCode: orderCode,
          points: points,
          convertedAt: convertedAt,
        );

  factory ClubPointModel.fromJson(Map<String, dynamic> json) {
    return ClubPointModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderCode: json['order_code'] ?? 0,
      points: json['points'] ?? 0,
      convertedAt: json['converted_at'] != null
          ? DateTime.parse(json['converted_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_code': orderCode,
      'points': points,
      'converted_at': convertedAt.toIso8601String(),
    };
  }
} 