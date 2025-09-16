class CartItem {
  final int id;
  final String productName;
  final String thumbnailImage;
  final String variant;
  final String productSlug;
  final String mainPrice;
  final String discountedPrice;
  final String discount;
  final String currencySymbol;
  final int quantity;
  final int lowerLimit;  // Add this
  final int upperLimit;  // Add this

  CartItem({
    required this.id,
    required this.productName,
    required this.productSlug,
    required this.thumbnailImage,
    required this.variant,
    required this.mainPrice,
    required this.discountedPrice,
    required this.discount,
    required this.currencySymbol,
    required this.quantity,
    this.lowerLimit = 1,   // Default value
    this.upperLimit = 10,  // Default value
  });
}

class CartSummary {
  final String subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final double discount;
  final String currencySymbol;
  final String? couponCode;
  final bool couponApplied;

  CartSummary({
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.currencySymbol,
    this.discount = 0.0,
    this.couponCode,
    this.couponApplied = false,
  });
}