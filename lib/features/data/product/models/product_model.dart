import '../../../domain/product/entities/product.dart' as entity;

class ProductModel extends entity.Product {
  const ProductModel({
    required super.id,
    required super.slug,
    required super.name,
    required super.mainCategoryId,
    required super.mainCategoryName,
    required super.categories,
    required super.thumbnailImage,
    required super.hasDiscount,
    required super.discount,
    required super.mainPrice,
    required super.discountedPrice,
    required super.published,
    required super.hasVariation,
    required super.stockQuantity,
    required super.currentStock,
    required super.stock,
    required super.rating,
    required super.ratingCount,
    required super.sales,
    required super.links,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      mainCategoryId: json['main_category_id'] ?? 0,
      mainCategoryName: json['main_category_name'] ?? '',
      categories: json['categories'] is List
          ? List<CategoryModel>.from(
        json['categories'].map((x) => CategoryModel.fromJson(x)),
      )
          : [],
      thumbnailImage: json['thumbnail_image'] ?? json['image']??'',
      hasDiscount: json['has_discount'] ?? false,
      discount: json['discount'] ?? '',
      mainPrice: json['main_price'] ?? '',
      discountedPrice: json['stroked_price'] ?? json['discounted_price'] ?? json['price'] ??'',
      published: json['published'] ?? 1,
      hasVariation: json['has_variation'] ?? false,
      stockQuantity: json['stock_quantity'] ?? 0,
      currentStock: json['current_stock'] ?? 0,
      stock: json['stock'] == null
          ? []
          : List<StockModel>.from(
        json['stock'].map((x) => StockModel.fromJson(x)),
      ),
      rating: json['rating'] ?? 0,
      ratingCount: json['rating_count'] ?? 0,
      sales: json['sales'] ?? 0,
      links: json['links'] == null
          ? const ProductLinksModel(details: '')
          : ProductLinksModel.fromJson(json['links']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'main_category_id': mainCategoryId,
      'main_category_name': mainCategoryName,
      'categories': categories.map((x) => (x as CategoryModel).toJson()).toList(),
      'thumbnail_image': thumbnailImage,
      'has_discount': hasDiscount,
      'discount': discount,
      'main_price': mainPrice,
      'discounted_price': discountedPrice,
      'published': published,
      'has_variation': hasVariation,
      'stock_quantity': stockQuantity,
      'current_stock': currentStock,
      'stock': stock.map((x) => (x as StockModel).toJson()).toList(),
      'rating': rating,
      'rating_count': ratingCount,
      'sales': sales,
      'links': (links as ProductLinksModel).toJson(),
    };
  }
}

class CategoryModel extends entity.Category {
  const CategoryModel({
    required super.id,
    required super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StockModel extends entity.ProductStock {
  const StockModel({
    required super.id,
    required super.productId,
    required super.variant,
    required super.sku,
    required super.price,
    required super.qty,
    required super.image,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variant: json['variant'] ?? '',
      sku: json['sku'] ?? '',
      price: json['price'] ?? 0.0,
      qty: json['qty'] ?? 0,
      image: json['image'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant': variant,
      'sku': sku,
      'price': price,
      'qty': qty,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductLinksModel extends entity.ProductLinks {
  const ProductLinksModel({
    required super.details,
  });

  factory ProductLinksModel.fromJson(Map<String, dynamic> json) {
    return ProductLinksModel(
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details,
    };
  }
}

