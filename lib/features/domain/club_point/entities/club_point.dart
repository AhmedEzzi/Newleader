import 'package:equatable/equatable.dart';

class ClubPoint extends Equatable {
  final int id;
  final int userId;
  final String orderCode;
  final int points;
  final DateTime convertedAt;

  const ClubPoint({
    required this.id,
    required this.userId,
    required this.orderCode,
    required this.points,
    required this.convertedAt,
  });

  @override
  List<Object?> get props => [id, userId, orderCode, points, convertedAt];
} 