class UserProfile {
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

  UserProfile({
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
}

class ProfileResponse {
  final UserProfile data;
  final bool success;
  final int status;

  ProfileResponse({
    required this.data,
    required this.success,
    required this.status,
  });
}
