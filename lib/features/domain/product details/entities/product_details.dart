class ProductDetails {
  final int id;
  final String slug;
  final String name;
  final String link;
  final String mainCategoryName;
  final int mainCategoryId;
  final String shopName;
  final String shopLogo;
  final List<Photo> photos;
  final String thumbnailImage;
  final String price; // Using mainPrice from response
  final double calculablePrice;
  final String currencySymbol;
  final int currentStock;
  final String unit;
  final double rating;
  final int ratingCount;
  final String description;
  final bool hasDiscount;
  final String discount;
  final String strokedPrice;
  final Brand brand;
  final List<String> colors;
  final List<ChoiceOption> choiceOptions;
  final bool hasVariation;
  final Map<String, String>? specifications;

  ProductDetails({
    required this.id,
    required this.slug,
    required this.name,
    required this.link,
    required this.mainCategoryName,
    required this.mainCategoryId,
    required this.shopName,
    required this.shopLogo,
    required this.photos,
    required this.thumbnailImage,
    required this.price,
    required this.calculablePrice,
    required this.currencySymbol,
    required this.currentStock,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.brand,
    required this.colors,
    required this.choiceOptions,
    required this.hasVariation,
    this.specifications,
  });
}

class ChoiceOption {
  final String name;
  final String title;
  final List<String> options;

  ChoiceOption({
    required this.name,
    required this.title,
    required this.options,
  });
}

class Photo {
  final String variant;
  final String path;

  Photo({
    required this.variant,
    required this.path,
  });
}

class Brand {
  final int id;
  final String name;
  final String slug;
  final String logo;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
  });
}

class ProductResponse {
  final List<ProductDetails> data;
  final bool success;
  final int status;

  ProductResponse({
    required this.data,
    required this.success,
    required this.status,
  });
}