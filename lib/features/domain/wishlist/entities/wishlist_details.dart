class WishlistItem {
  final int id;
  final int productId;
  final String slug;
  final String name;
  final String thumbnailImage;
  final String price;
  final String currencySymbol;
  final double rating;
  final int ratingCount;
  final bool hasVariation;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.slug,
    required this.name,
    required this.thumbnailImage,
    required this.price,
    required this.hasVariation,
    required this.currencySymbol,
    this.rating = 0,
    this.ratingCount = 0,
  });
}

class WishlistCheck {
  final bool isInWishlist;
  final String message;
  final int? productId;
  final String? productSlug;
  final int? wishlistId;

  WishlistCheck({
    required this.isInWishlist,
    this.message = '',
    this.productId,
    this.productSlug,
    this.wishlistId,
  });
}