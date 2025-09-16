class VariantPrice {
  final bool result;
  final VariantPriceData data;

  VariantPrice({
    required this.result,
    required this.data,
  });
}

class VariantPriceData {
  final String price;
  final int stock;
  final int stockTxt;
  final int digital;
  final String variant;
  final String variation;
  final int maxLimit;
  final int inStock;
  final String image;

  VariantPriceData({
    required this.price,
    required this.stock,
    required this.stockTxt,
    required this.digital,
    required this.variant,
    required this.variation,
    required this.maxLimit,
    required this.inStock,
    required this.image,
  });
}