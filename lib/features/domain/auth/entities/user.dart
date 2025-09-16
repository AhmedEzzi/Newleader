import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final int id;
  final dynamic type;
  final String name;
  final dynamic email;
  final dynamic avatar;
  final String avatarOriginal;
  final dynamic phone;
  final bool emailVerified;

  const User({
    required this.id,
    required this.type,
    required this.name,
    required this.email,
    required this.avatar,
    required this.avatarOriginal,
    required this.emailVerified,
    this.phone,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    email,
    avatar,
    avatarOriginal,
    emailVerified,
    phone,
  ];
}

class AuthResponse extends Equatable {
  final bool result;
  final String message;
  final String? accessToken;
  final String? tokenType;
  final String? expiresAt;
  final User? user;

  const AuthResponse({
    required this.result,
    required this.message,
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.user,
  });

  @override
  List<Object?> get props => [
    result,
    message,
    accessToken,
    tokenType,
    expiresAt,
    user,
  ];
}