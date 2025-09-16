

import 'package:leader_company/features/data/auth/models/user_model.dart';

class AuthResponseModel {
  final bool result;
  final String message;
  final String? accessToken;
  final String? tokenType;
  final dynamic expiresAt;
  final UserModel? user;

  AuthResponseModel({
    required this.result,
    required this.message,
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      result: json['result'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresAt: json['expires_at'], // Allow null value
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt,
      'user': user?.toJson(),
    };
  }
}