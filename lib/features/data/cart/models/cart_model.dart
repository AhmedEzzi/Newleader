import '../../../domain/cart/entities/cart.dart';

class CartItemModel {
  final int id;
  final String productName;
  final String thumbnailImage;
  final String variant;
  final String mainPrice;
  final String discountedPrice;
  final String discount;
  final String currencySymbol;
  final String productSlug;
  final int quantity;
  final int lowerLimit;  // Add this
  final int upperLimit;  // Add this

  CartItemModel({
    required this.id,
    required this.productName,
    required this.thumbnailImage,
    required this.variant,
    required this.mainPrice,
    required this.discountedPrice,
    required this.discount,
    required this.productSlug,
    required this.currencySymbol,
    required this.quantity,
    this.lowerLimit = 1,   // Default value
    this.upperLimit = 10,  // Default value
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      thumbnailImage: json['product_thumbnail_image'] ?? '',
      variant: json['variation'] ?? '',
      mainPrice: json['product_main_price'],
      discountedPrice: json['product_discounted_price'],
      discount: json['product_discount'],
      currencySymbol: json['currency_symbol'] ?? '',
      quantity: json['quantity'] ?? 1,
      productSlug: json['product_slug']??'',
      lowerLimit: json['lower_limit'] ?? 1,  // Parse from JSON if available
      upperLimit: json['upper_limit'] ?? 10, // Parse from JSON if available
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      productName: productName,
      thumbnailImage: thumbnailImage,
      variant: variant,
      mainPrice: mainPrice,
      discountedPrice: discountedPrice,
      discount: discount,
      currencySymbol: currencySymbol,
      quantity: quantity,
      lowerLimit: lowerLimit,  // Pass to entity
      upperLimit: upperLimit, productSlug: productSlug,  // Pass to entity
    );
  }
}

class CartSummaryModel {
  final String subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final double total;
  final String currencySymbol;
  final String? couponCode;
  final bool couponApplied;

  CartSummaryModel({
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.currencySymbol,
    this.couponCode,
    required this.couponApplied,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    // Extract currency symbol from formatted strings
    String currencySymbol = '';
    String subtotalStr = json['sub_total'] ?? '0';

    // Parse currency symbol (assuming format like "3,683 L.E")
    if (subtotalStr.contains(' ')) {
      final parts = subtotalStr.split(' ');
      if (parts.length > 1) {
        currencySymbol = parts.last;
      }
    }

    // Helper function to parse formatted price strings
    double parsePrice(String? priceStr) {
      if (priceStr == null || priceStr.isEmpty) return 0.0;

      // Remove currency part and any commas, then parse to double
      final numericPart = priceStr.split(' ').first.replaceAll(',', '');
      return double.tryParse(numericPart) ?? 0.0;
    }

    return CartSummaryModel(
      subtotal: json['sub_total'],
      tax: parsePrice(json['tax']),
      shippingCost: parsePrice(json['shipping_cost']),
      discount: parsePrice(json['discount']),
      total: json['grand_total_value'] != null
          ? (json['grand_total_value'] as num).toDouble()
          : parsePrice(json['grand_total']),
      currencySymbol: currencySymbol,
      couponCode: json['coupon_code'],
      couponApplied: json['coupon_applied'] ?? false,
    );
  }

  CartSummary toEntity() {
    return CartSummary(
      subtotal: subtotal,
      tax: tax,
      shippingCost: shippingCost,
      total: total,
      discount: discount,
      currencySymbol: currencySymbol,
      couponCode: couponCode,
      couponApplied: couponApplied,
    );
  }
}

class CartCountModel {
  final int count;

  CartCountModel({required this.count});

  factory CartCountModel.fromJson(Map<String, dynamic> json) {
    return CartCountModel(count: json['count'] ?? 0);
  }
}