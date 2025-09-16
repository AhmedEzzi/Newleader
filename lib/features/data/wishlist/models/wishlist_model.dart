import '../../../domain/wishlist/entities/wishlist_details.dart';

class WishlistItemModel {
  final int id;
  final ProductModel product;

  WishlistItemModel({
    required this.id,
    required this.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? 0,
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }

  WishlistItem toEntity() {
    return WishlistItem(
      id: id,
      productId: product.id,
      slug: product.slug,
      name: product.name,
      thumbnailImage: product.thumbnailImage,
      price: product.basePrice,
      currencySymbol: '',
      rating: product.rating,
      ratingCount: product.ratingCount,
      hasVariation: product.hasVariation,
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String thumbnailImage;
  final String basePrice;
  final double rating;
  final bool hasVariation;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.thumbnailImage,
    required this.basePrice,
    required this.rating,
    required this.hasVariation,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      basePrice: json['base_price'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      hasVariation: json['has_variation'] ?? false,
      ratingCount: json['rating_count'] ?? 0,
    );
  }
}

class WishlistCheckModel {
  final bool isInWishlist;
  final String message;
  final int? productId;
  final String? productSlug;
  final int? wishlistId;

  WishlistCheckModel({
    required this.isInWishlist,
    this.message = '',
    this.productId,
    this.productSlug,
    this.wishlistId,
  });

  factory WishlistCheckModel.fromJson(Map<String, dynamic> json) {
    return WishlistCheckModel(
      isInWishlist: json['is_in_wishlist'] ?? false,
      message: json['message'] ?? '',
      productId: json['product_id'],
      productSlug: json['product_slug'],
      wishlistId: json['wishlist_id'],
    );
  }

  WishlistCheck toEntity() {
    return WishlistCheck(
      isInWishlist: isInWishlist,
      message: message,
      productId: productId,
      productSlug: productSlug,
      wishlistId: wishlistId,
    );
  }
}