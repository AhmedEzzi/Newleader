import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String? slug;
  final String? name;
  final String? banner;
  final String? bannerDesktop;
  final String? bannerMobile;
  final String? coverImage;
  final String? icon;
  final int? productCount;
  final int? numberOfChildren;
  final Links? links;

  const Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.banner,
    required this.bannerDesktop,
    required this.bannerMobile,
    required this.coverImage,
    required this.icon,
    required this.productCount,
    required this.numberOfChildren,
    required this.links,
  });

  @override
  List<Object?> get props => [
    id,
    slug,
    name,
    banner,
    bannerDesktop,
    bannerMobile,
    coverImage,
    icon,
    productCount,
    numberOfChildren,
    links,
  ];
}

class Links extends Equatable {
  final String? products;
  final String? subCategories;

  const Links({
    required this.products,
    required this.subCategories,
  });

  @override
  List<Object?> get props => [
    products,
    subCategories,
  ];
}

class CategoryResponse extends Equatable {
  final List<Category> data;
  final bool? success;
  final int? status;

  const CategoryResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  @override
  List<Object?> get props => [
    data,
    success,
    status,
  ];
}