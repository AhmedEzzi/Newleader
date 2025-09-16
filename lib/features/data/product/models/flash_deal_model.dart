import 'package:leader_company/features/domain/product/entities/flash_deal.dart';
import 'package:leader_company/features/data/product/models/product_model.dart';

class FlashDealModel extends FlashDeal {
  FlashDealModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.date,
    required super.banner,
    required super.products,
  });

  factory FlashDealModel.fromJson(Map<String, dynamic> json) {
    final productsList = json['products'] != null && json['products']['data'] != null
        ? List<ProductModel>.from(
            json['products']['data'].map((x) => ProductModel.fromJson(x)))
        : <ProductModel>[];

    return FlashDealModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? 0,
      banner: json['banner'] ?? '',
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'date': date,
      'banner': banner,
      'products': {
        'data': products.map((product) => (product as ProductModel).toJson()).toList(),
      },
    };
  }
} 