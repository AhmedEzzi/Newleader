import '../../../../core/database/objectbox_store.dart';
import '../../../../core/database/timestamp_service.dart';
import '../../../../objectbox.g.dart';
import '../models/flash_deal_response_model.dart';
import '../models/product_entity.dart';
import '../models/product_model.dart';
import '../models/product_response_model.dart';

abstract class ProductLocalDataSource {
  Future<bool> isCollectionCacheValid(String collectionType, int page);
  Future<ProductResponseModel?> getCollectionFromCache(String collectionType, int page);
  Future<void> saveCollection(String collectionType, int page, ProductResponseModel response);
  Future<FlashDealResponseModel?> getFlashDealsFromCache(String collectionType, int page);
  Future<void> saveFlashDealCollection(String collectionType, int page, FlashDealResponseModel response);
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final ObjectBox objectBox;
  final TimestampService timestampService;

  ProductLocalDataSourceImpl({
    required this.objectBox,
    required this.timestampService,
  });

  @override
  Future<bool> isCollectionCacheValid(String collectionType, int page) async {
    final query = objectBox.collectionBox.query(
        ProductCollectionEntity_.collectionType.equals(collectionType) &
        ProductCollectionEntity_.page.equals(page)
    ).build();

    final collection = query.findFirst();
    query.close();

    if (collection == null) {
      return false;
    }

    return timestampService.isCacheValid(collection.timestamp);
  }

  @override
  Future<ProductResponseModel?> getCollectionFromCache(String collectionType, int page) async {
    final query = objectBox.collectionBox.query(
        ProductCollectionEntity_.collectionType.equals(collectionType) &
        ProductCollectionEntity_.page.equals(page)
    ).build();

    final collection = query.findFirst();
    query.close();

    if (collection == null) {
      return null;
    }

    // Convert entities to models
    final productModels = collection.products.map((entity) => entity.toModel()).toList();

    // Create response model with cached data
    return ProductResponseModel(
      data: productModels,
      links: const ProductResponseLinksModel(
        first: '',
        last: '',
        prev: null,
        next: '',
      ),
      meta: MetaModel(
        currentPage: page,
        from: 1,
        lastPage: collection.totalPages,
        links: [],
        path: '',
        perPage: productModels.length,
        to: productModels.length,
        total: productModels.length * collection.totalPages,
      ),
      success: true,
      status: 200,
    );
  }

  @override
  Future<void> saveCollection(String collectionType, int page, ProductResponseModel response) async {
    // Start a transaction for atomicity
    objectBox.store.runInTransaction(TxMode.write, () {
      final timestamp = timestampService.getCurrentTimestamp();

      // Create or update the collection
      final existingQuery = objectBox.collectionBox.query(
          ProductCollectionEntity_.collectionType.equals(collectionType) &
          ProductCollectionEntity_.page.equals(page)
      ).build();

      final existingCollection = existingQuery.findFirst();
      existingQuery.close();

      final collection = existingCollection ?? ProductCollectionEntity(
        collectionType: collectionType,
        page: page,
        totalPages: response.meta.lastPage,
        timestamp: timestamp,
      );

      if (existingCollection != null) {
        collection.timestamp = timestamp;
        collection.totalPages = response.meta.lastPage;
        // Clear existing relations to update with new data
        collection.products.clear();
      }

      // Process each product
      for (final productModell in response.data) {
        final productModel = productModell as ProductModel;

        // Check if product already exists
        final productQuery = objectBox.productBox.query(
            ProductEntity_.productId.equals(productModel.id)
        ).build();

        final existingProduct = productQuery.findFirst();
        productQuery.close();

        // Create or update product
        final productEntity = existingProduct ?? ProductEntity.fromModel(productModel, timestamp);
        if (existingProduct != null) {
          // Update properties
          productEntity.name = productModel.name;
          productEntity.slug = productModel.slug;
          productEntity.mainCategoryId = productModel.mainCategoryId is int ? productModel.mainCategoryId : 0;
          productEntity.mainCategoryName = productModel.mainCategoryName;
          productEntity.thumbnailImage = productModel.thumbnailImage;
          productEntity.hasDiscount = productModel.hasDiscount;
          productEntity.discount = productModel.discount;
          productEntity.mainPrice = productModel.mainPrice;
          productEntity.discountedPrice = productModel.discountedPrice;
          productEntity.published = productModel.published;
          productEntity.hasVariation = productModel.hasVariation;
          productEntity.stockQuantity = productModel.stockQuantity;
          productEntity.currentStock = productModel.currentStock;
          productEntity.rating = productModel.rating;
          productEntity.ratingCount = productModel.ratingCount;
          productEntity.sales = productModel.sales;
          productEntity.details = productModel.links.details;
          productEntity.timestamp = timestamp;

          // Clear existing relations to update
          productEntity.categories.clear();
          productEntity.stock.clear();
        }

        // Process categories
        for (final categoryModell in productModel.categories) {
          final categoryModel = categoryModell as CategoryModel;

          // Check if category exists
          final categoryQuery = objectBox.categoryBox.query(
              CategoryEntity_.categoryId.equals(categoryModel.id)
          ).build();

          final existingCategory = categoryQuery.findFirst();
          categoryQuery.close();

          // Create or get category
          final categoryEntity = existingCategory ?? CategoryEntity.fromModel(categoryModel);
          if (existingCategory == null) {
            objectBox.categoryBox.put(categoryEntity);
          }

          // Link category to product
          productEntity.categories.add(categoryEntity);
        }

        // Process stock items
        for (final stockModell in productModel.stock) {
          final stockModel = stockModell as StockModel;

          // Check if stock exists
          final stockQuery = objectBox.stockBox.query(
              ProductStockEntity_.stockId.equals(stockModel.id)
          ).build();

          final existingStock = stockQuery.findFirst();
          stockQuery.close();

          // Create or update stock
          final stockEntity = existingStock ?? ProductStockEntity.fromModel(stockModel);
          if (existingStock != null) {
            stockEntity.variant = stockModel.variant;
            stockEntity.sku = stockModel.sku;
            stockEntity.price = stockModel.price is double ? stockModel.price : 0.0;
            stockEntity.qty = stockModel.qty;
            stockEntity.image = stockModel.image?.toString();
            stockEntity.updatedAt = stockModel.updatedAt;
          }

          // Save stock entity
          objectBox.stockBox.put(stockEntity);

          // Link stock to product
          productEntity.stock.add(stockEntity);
          stockEntity.product.target = productEntity;
        }

        // Save product entity
        objectBox.productBox.put(productEntity);

        // Link product to collection
        collection.products.add(productEntity);
      }

      // Save collection
      objectBox.collectionBox.put(collection);
    });
  }

  @override
  Future<FlashDealResponseModel?> getFlashDealsFromCache(String collectionType, int page) async {
    // For now, just return null as we're waiting for proper implementation
    // This will force the app to always get data from remote source
    return null;
  }

  @override
  Future<void> saveFlashDealCollection(String collectionType, int page, FlashDealResponseModel response) async {
    // Simple implementation that just saves products for now
    // We'll extract all products from flash deals and save them
    try {
      final products = <ProductModel>[];
      
      // Extract products from all flash deals
      for (final deal in response.data) {
        // Add all products from this deal to our list
        for (final product in deal.products) {
          if (product is ProductModel) {
            products.add(product);
          }
        }
      }
      
      // If we have products, save them using the existing collection method
      if (products.isNotEmpty) {
        // Create a product response model from the extracted products
        final productResponse = ProductResponseModel(
          data: products,
          links: const ProductResponseLinksModel(
            first: '',
            last: '',
            prev: null,
            next: '',
          ),
          meta: MetaModel(
            currentPage: page,
            from: 1,
            lastPage: 1,
            links: [],
            path: '',
            perPage: products.length,
            to: products.length,
            total: products.length,
          ),
          success: true,
          status: 200,
        );
        
        // Save using existing method
        await saveCollection(collectionType, page, productResponse);
      }
    } catch (e) {
      print('Error saving flash deals: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    objectBox.productBox.removeAll();
    objectBox.categoryBox.removeAll();
    objectBox.stockBox.removeAll();
    objectBox.collectionBox.removeAll();
  }
}