import '../../../domain/product details/entities/variant_product_price.dart';

class VariantPriceModel {
  final bool result;
  final VariantPriceDataModel data;

  VariantPriceModel({
    required this.result,
    required this.data,
  });

  factory VariantPriceModel.fromJson(Map<String, dynamic> json) {
    return VariantPriceModel(
      result: json['result'] ?? false,
      data: VariantPriceDataModel.fromJson(json['data'] ?? {}),
    );
  }

  VariantPrice toEntity() {
    return VariantPrice(
      result: result,
      data: data.toEntity(),
    );
  }
}






class VariantPriceDataModel {
  final String price;
  final int stock;
  final int stockTxt;
  final int digital;
  final String variant;
  final String variation;
  final int maxLimit;
  final int inStock;
  final String image;

  VariantPriceDataModel({
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

  factory VariantPriceDataModel.fromJson(Map<String, dynamic> json) {
    return VariantPriceDataModel(
      price: json['price'] ?? '',
      stock: json['stock'] ?? 0,
      stockTxt: json['stock_txt'] ?? 0,
      digital: json['digital'] ?? 0,
      variant: json['variant'] ?? '',
      variation: json['variation'] ?? '',
      maxLimit: json['max_limit'] ?? 0,
      inStock: json['in_stock'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  VariantPriceData toEntity() {
    return VariantPriceData(
      price: price,
      stock: stock,
      stockTxt: stockTxt,
      digital: digital,
      variant: variant,
      variation: variation,
      maxLimit: maxLimit,
      inStock: inStock,
      image: image,
    );
  }

}