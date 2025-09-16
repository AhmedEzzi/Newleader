import 'package:meta/meta.dart';

import '../../../domain/auth/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.type,
    required super.name,
    required super.email,
    required super.avatar,
    required super.avatarOriginal,
    super.phone,
    required super.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      avatarOriginal: json['avatar_original'] ?? '',
      phone: json['phone'],
      emailVerified: json['email_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'email': email,
      'avatar': avatar,
      'avatar_original': avatarOriginal,
      'phone': phone,
      'email_verified': emailVerified,
    };
  }
}