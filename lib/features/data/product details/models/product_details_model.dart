import '../../../domain/product details/entities/product_details.dart';

class ProductDetailsModel {
  final int id;
  final String slug;
  final String name;
  final String mainCategoryName;
  final int mainCategoryId;
  final String addedBy;
  final int sellerId;
  final int shopId;
  final String shopSlug;
  final String shopName;
  final String shopLogo;
  final List<PhotoModel> photos;
  final String thumbnailImage;
  final List<String> tags;
  final String priceHighLow;
  final List<ChoiceOptionModel> choiceOptions; // Updated to typed list
  final List<String> colors;
  final bool hasVariation;
  final bool hasDiscount;
  final String discount;
  final String strokedPrice;
  final String mainPrice;
  final double calculablePrice;
  final String currencySymbol;
  final int currentStock;
  final String unit;
  final double rating;
  final int ratingCount;
  final int earnPoint;
  final String description;
  final dynamic downloads;
  final String videoLink;
  final BrandModel brand;
  final String link;
  final List<dynamic> wholesale;
  final int estShippingTime;
  final Map<String, String> specifications; // Added specifications field

  ProductDetailsModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.mainCategoryName,
    required this.mainCategoryId,
    required this.addedBy,
    required this.sellerId,
    required this.shopId,
    required this.shopSlug,
    required this.shopName,
    required this.shopLogo,
    required this.photos,
    required this.thumbnailImage,
    required this.tags,
    required this.priceHighLow,
    required this.choiceOptions,
    required this.colors,
    required this.hasVariation,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.mainPrice,
    required this.calculablePrice,
    required this.currencySymbol,
    required this.currentStock,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.earnPoint,
    required this.description,
    required this.downloads,
    required this.videoLink,
    required this.brand,
    required this.link,
    required this.wholesale,
    required this.estShippingTime,
    required this.specifications, // Added to constructor
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Convert specifications from json
    Map<String, String> specifications = {};
    if (json['specifications'] != null) {
      // Check if specifications is a Map before attempting to cast it
      if (json['specifications'] is Map) {
        final specsMap = json['specifications'] as Map<String, dynamic>;
        specifications = specsMap.map((key, value) => MapEntry(key, value.toString()));
      }
    }

    return ProductDetailsModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      mainCategoryName: json['main_category_name'] ?? '',
      mainCategoryId: json['main_category_id'] ?? 0,
      addedBy: json['added_by'] ?? '',
      sellerId: json['seller_id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      shopSlug: json['shop_slug'] ?? '',
      shopName: json['shop_name'] ?? '',
      shopLogo: json['shop_logo'] ?? '',
      photos: (json['photos'] as List?)
          ?.map((photo) => PhotoModel.fromJson(photo))
          .toList() ??
          [],
      thumbnailImage: json['thumbnail_image'] ?? '',
      tags: (json['tags'] as List?)?.map((tag) => tag.toString()).toList() ?? [],
      priceHighLow: json['price_high_low'] ?? '',
      choiceOptions: (json['choice_options'] as List?)
          ?.map((option) => ChoiceOptionModel.fromJson(option))
          .toList() ??
          [],
      colors: (json['colors'] as List?)?.map((color) => color.toString()).toList() ?? [],
      hasVariation: json['has_variation'] ?? false,
      hasDiscount: json['has_discount'] ?? false,
      discount: json['discount'] ?? '',
      strokedPrice: json['stroked_price'] ?? '',
      mainPrice: json['main_price'] ?? '',
      calculablePrice: (json['calculable_price'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol'] ?? '',
      currentStock: json['current_stock'] ?? 0,
      unit: json['unit'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] ?? 0,
      earnPoint: json['earn_point'] ?? 0,
      description: json['description'] ?? '',
      downloads: json['downloads'],
      videoLink: json['video_link'] ?? '',
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      link: json['link'] ?? '',
      wholesale: json['wholesale'] ?? [],
      estShippingTime: json['est_shipping_time'] ?? 0,
      specifications: specifications, // Added specifications
    );
  }

  ProductDetails toEntity() {
    return ProductDetails(
      id: id,
      slug: slug,
      name: name,
      link: link,
      mainCategoryName: mainCategoryName,
      mainCategoryId: mainCategoryId,
      shopName: shopName,
      shopLogo: shopLogo,
      photos: photos.map((photo) => photo.toEntity()).toList(),
      thumbnailImage: thumbnailImage,
      price: mainPrice,
      calculablePrice: calculablePrice,
      currencySymbol: currencySymbol,
      currentStock: currentStock,
      unit: unit,
      rating: rating,
      ratingCount: ratingCount,
      description: description,
      hasDiscount: hasDiscount,
      discount: discount,
      strokedPrice: strokedPrice,
      brand: brand.toEntity(),
      colors: colors,
      choiceOptions: choiceOptions.map((option) => option.toEntity()).toList(),
      hasVariation: hasVariation,
      specifications: specifications, // Added to entity conversion
    );
  }
}

class ChoiceOptionModel {
  final String name;
  final String title;
  final List<String> options;

  ChoiceOptionModel({
    required this.name,
    required this.title,
    required this.options,
  });

  factory ChoiceOptionModel.fromJson(Map<String, dynamic> json) {
    return ChoiceOptionModel(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      options: (json['options'] as List?)?.map((option) => option.toString()).toList() ?? [],
    );
  }

  ChoiceOption toEntity() {
    return ChoiceOption(
      name: name,
      title: title,
      options: options,
    );
  }
}

class PhotoModel {
  final String variant;
  final String path;

  PhotoModel({
    required this.variant,
    required this.path,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      variant: json['variant'] ?? '',
      path: json['path'] ?? '',
    );
  }

  Photo toEntity() {
    return Photo(
      variant: variant,
      path: path,
    );
  }
}

class BrandModel {
  final int id;
  final String name;
  final String slug;
  final String logo;

  BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Brand toEntity() {
    return Brand(
      id: id,
      name: name,
      slug: slug,
      logo: logo,
    );
  }
}

class ProductResponseModel {
  final List<ProductDetailsModel> data;
  final bool success;
  final int status;

  ProductResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      data: (json['data'] as List?)
          ?.map((product) => ProductDetailsModel.fromJson(product))
          .toList() ??
          [],
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  ProductResponse toEntity() {
    return ProductResponse(
      data: data.map((product) => product.toEntity()).toList(),
      success: success,
      status: status,
    );
  }
}