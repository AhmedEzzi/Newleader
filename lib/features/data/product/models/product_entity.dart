import 'package:objectbox/objectbox.dart';
import '../models/product_model.dart';

@Entity()
class ProductEntity {
  @Id()
  int id = 0;

  int productId = 0;
  String slug = '';
  String name = '';
  int mainCategoryId = 0;
  String mainCategoryName = '';
  String thumbnailImage = '';
  bool hasDiscount = false;
  String discount = '';
  String mainPrice = '';
  String discountedPrice = '';
  int published = 0;
  bool hasVariation = false;
  int stockQuantity = 0;
  int currentStock = 0;
  dynamic rating = 0;
  int ratingCount = 0;
  int sales = 0;
  String details = '';
  DateTime timestamp = DateTime.now();

  // Relations to other entities
  final categories = ToMany<CategoryEntity>();
  final stock = ToMany<ProductStockEntity>();

  // Default constructor for ObjectBox
  ProductEntity();

  // Named constructor
  ProductEntity.create({
    required this.productId,
    required this.slug,
    required this.name,
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.discount,
    required this.mainPrice,
    required this.discountedPrice,
    required this.published,
    required this.hasVariation,
    required this.stockQuantity,
    required this.currentStock,
    required this.rating,
    required this.ratingCount,
    required this.sales,
    required this.details,
    required this.timestamp,
  });

  // Convert from ProductModel to ProductEntity
  static ProductEntity fromModel(ProductModel model, DateTime timestamp) {
    final entity = ProductEntity.create(
      productId: model.id,
      slug: model.slug,
      name: model.name,
      mainCategoryId: model.mainCategoryId is int ? model.mainCategoryId : 0,
      mainCategoryName: model.mainCategoryName,
      thumbnailImage: model.thumbnailImage,
      hasDiscount: model.hasDiscount,
      discount: model.discount,
      mainPrice: model.mainPrice,
      discountedPrice: model.discountedPrice,
      published: model.published,
      hasVariation: model.hasVariation,
      stockQuantity: model.stockQuantity,
      currentStock: model.currentStock,
      rating: model.rating,
      ratingCount: model.ratingCount,
      sales: model.sales,
      details: model.links.details,
      timestamp: timestamp,
    );

    return entity;
  }

  // Convert from ProductEntity to ProductModel
  ProductModel toModel() {
    final categoryModels = categories
        .map((c) => CategoryModel(id: c.categoryId, name: c.name))
        .toList();

    final stockModels = stock
        .map((s) => StockModel(
      id: s.stockId,
      productId: s.productId,
      variant: s.variant,
      sku: s.sku,
      price: s.price,
      qty: s.qty,
      image: s.image,
      createdAt: s.createdAt,
      updatedAt: s.updatedAt,
    ))
        .toList();

    return ProductModel(
      id: productId,
      slug: slug,
      name: name,
      mainCategoryId: mainCategoryId,
      mainCategoryName: mainCategoryName,
      categories: categoryModels,
      thumbnailImage: thumbnailImage,
      hasDiscount: hasDiscount,
      discount: discount,
      mainPrice: mainPrice,
      discountedPrice: discountedPrice,
      published: published,
      hasVariation: hasVariation,
      stockQuantity: stockQuantity,
      currentStock: currentStock,
      stock: stockModels,
      rating: rating,
      ratingCount: ratingCount,
      sales: sales,
      links: ProductLinksModel(details: details),
    );
  }
}

@Entity()
class CategoryEntity {
  @Id()
  int id = 0;

  int categoryId = 0;
  String name = '';

  // Back reference to products
  final products = ToMany<ProductEntity>();

  // Default constructor
  CategoryEntity();

  // Named constructor
  CategoryEntity.create({
    required this.categoryId,
    required this.name,
  });

  static CategoryEntity fromModel(CategoryModel model) {
    return CategoryEntity.create(
      categoryId: model.id,
      name: model.name,
    );
  }
}

@Entity()
class ProductStockEntity {
  @Id()
  int id = 0;

  int stockId = 0;
  int productId = 0;
  String variant = '';
  String sku = '';
  double price = 0.0;
  int qty = 0;
  String? image;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Back reference to the product
  final product = ToOne<ProductEntity>();

  // Default constructor needed by ObjectBox
  ProductStockEntity();

  // Named constructor for creating from parameters
  ProductStockEntity.create({
    required this.stockId,
    required this.productId,
    required this.variant,
    required this.sku,
    required this.price,
    required this.qty,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  static ProductStockEntity fromModel(StockModel model) {
    final price = model.price is double ? model.price : 0.0;

    return ProductStockEntity.create(
      stockId: model.id,
      productId: model.productId,
      variant: model.variant,
      sku: model.sku,
      price: price,
      qty: model.qty,
      image: model.image?.toString(),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}

// ProductsResponseEntity to store paginated data information
@Entity()
class ProductCollectionEntity {
  @Id()
  int id = 0;

  String collectionType = ''; // e.g., "featured", "best_selling", etc.
  int page = 0;
  int totalPages = 0;
  DateTime timestamp = DateTime.now();

  // Reference to products
  final products = ToMany<ProductEntity>();

  // Default constructor
  ProductCollectionEntity({
    required this.collectionType,
    required this.page,
    required this.totalPages,
    required this.timestamp,
  });

  // Named constructor
  ProductCollectionEntity.create({
    required this.collectionType,
    required this.page,
    required this.totalPages,
    required this.timestamp,
  });
}