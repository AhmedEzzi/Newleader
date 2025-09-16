import '../../../domain/profile/entities/user_profile.dart';

class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String token;
  final bool isVerified;
  final int cartItemCount;
  final int wishlistItemCount;
  final int orderCount;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.token,
    required this.isVerified,
    required this.cartItemCount,
    required this.wishlistItemCount,
    required this.orderCount,
  });

  // In user_profile_model.dart, update the fromJson method
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle both API response formats
    if (json.containsKey('result')) {
      // This is the response from get-user-by-access_token
      return UserProfileModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        avatar: json['avatar_original'] ?? json['avatar'] ?? '',  // Use avatar_original if available
        token: '',  // Token is sent, not received in this API
        isVerified: true,  // Assuming user is verified if we got their data
        cartItemCount: 0,  // These will be set separately from profile counters
        wishlistItemCount: 0,
        orderCount: 0,
      );
    } else {
      // Original response format
      return UserProfileModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        avatar: json['avatar'] ?? '',
        token: json['token'] ?? '',
        isVerified: json['is_verified'] ?? false,
        cartItemCount: json['cart_item_count'] ?? 0,
        wishlistItemCount: json['wishlist_item_count'] ?? 0,
        orderCount: json['order_count'] ?? 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'token': token,
      'is_verified': isVerified,
      'cart_item_count': cartItemCount,
      'wishlist_item_count': wishlistItemCount,
      'order_count': orderCount,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      token: token,
      isVerified: isVerified,
      cartItemCount: cartItemCount,
      wishlistItemCount: wishlistItemCount,
      orderCount: orderCount,
    );
  }
}

class UserProfileResponseModel {
  final UserProfileModel data;
  final bool success;
  final int status;

  UserProfileResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      data: UserProfileModel.fromJson(json['data'] ?? {}),
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  ProfileResponse toEntity() {
    return ProfileResponse(
      data: data.toEntity(),
      success: success,
      status: status,
    );
  }
}
