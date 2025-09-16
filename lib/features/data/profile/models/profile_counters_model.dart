class ProfileCountersModel {
  final int cartItemCount;
  final int wishlistItemCount;
  final int orderCount;

  ProfileCountersModel({
    required this.cartItemCount,
    required this.wishlistItemCount,
    required this.orderCount,
  });

  factory ProfileCountersModel.fromJson(Map<String, dynamic> json) {
    return ProfileCountersModel(
      cartItemCount: json['cart_item_count'] ?? 0,
      wishlistItemCount: json['wishlist_item_count'] ?? 0,
      orderCount: json['order_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_count': cartItemCount,
      'wishlist_item_count': wishlistItemCount,
      'order_count': orderCount,
    };
  }
}
