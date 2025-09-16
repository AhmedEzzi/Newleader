import 'package:leader_company/features/domain/product/entities/product.dart';

class FlashDeal {
  final int id;
  final String slug;
  final String title;
  final int date;
  final String banner;
  final List<Product> products;

  FlashDeal({
    required this.id,
    required this.slug,
    required this.title,
    required this.date,
    required this.banner,
    required this.products,
  });
} 