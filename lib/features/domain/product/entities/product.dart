import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String slug;
  final String name;
  final dynamic mainCategoryId;
  final String mainCategoryName;
  final List<Category> categories;
  final String thumbnailImage;
  final bool hasDiscount;
  final String discount;
  final String mainPrice;
  final String discountedPrice;
  final int published;
  final bool hasVariation;
  final int stockQuantity;
  final int currentStock;
  final List<ProductStock> stock;
  final dynamic rating;
  final int ratingCount;
  final int sales;
  final ProductLinks links;

  const Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.categories,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.discount,
    required this.mainPrice,
    required this.discountedPrice,
    required this.published,
    required this.hasVariation,
    required this.stockQuantity,
    required this.currentStock,
    required this.stock,
    required this.rating,
    required this.ratingCount,
    required this.sales,
    required this.links,
  });

  @override
  List<Object?> get props => [
    id,
    slug,
    name,
    mainCategoryId,
    mainCategoryName,
    categories,
    thumbnailImage,
    hasDiscount,
    discount,
    mainPrice,
    discountedPrice,
    published,
    hasVariation,
    stockQuantity,
    currentStock,
    stock,
    rating,
    ratingCount,
    sales,
    links,
  ];
}

class Category extends Equatable {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class ProductStock extends Equatable {
  final int id;
  final int productId;
  final String variant;
  final String sku;
  final dynamic price;
  final int qty;
  final dynamic image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductStock({
    required this.id,
    required this.productId,
    required this.variant,
    required this.sku,
    required this.price,
    required this.qty,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    variant,
    sku,
    price,
    qty,
    image,
    createdAt,
    updatedAt,
  ];
}

class ProductLinks extends Equatable {
  final String details;

  const ProductLinks({
    required this.details,
  });

  @override
  List<Object?> get props => [details];
}

class ProductsResponse extends Equatable {
  final List<Product> data;
  final ProductResponseLinks links;
  final Meta meta;
  final bool success;
  final int status;

  const ProductsResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

  @override
  List<Object?> get props => [
    data,
    links,
    meta,
    success,
    status,
  ];
}

class ProductResponseLinks extends Equatable {
  final String first;
  final String last;
  final dynamic prev;
  final String next;

  const ProductResponseLinks({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  @override
  List<Object?> get props => [first, last, prev, next];
}

class Meta extends Equatable {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<Link> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  const Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  @override
  List<Object?> get props => [
    currentPage,
    from,
    lastPage,
    links,
    path,
    perPage,
    to,
    total,
  ];
}

class Link extends Equatable {
  final String url;
  final String label;
  final bool active;

  const Link({
    required this.url,
    required this.label,
    required this.active,
  });

  @override
  List<Object?> get props => [url, label, active];
}