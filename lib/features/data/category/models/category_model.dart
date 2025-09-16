import '../../../domain/category/entities/category.dart';

class CategoryResponseModel {
  final List<CategoryModel> data;
  final bool? success;
  final int? status;

  CategoryResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      data: json["data"] == null
          ? []
          : List<CategoryModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
      success: json["success"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'success': success,
      'status': status,
    };
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.slug,
    required super.name,
    required super.banner,
    required super.bannerDesktop,
    required super.bannerMobile,
    required super.coverImage,
    required super.icon,
    required super.productCount,
    required super.numberOfChildren,
    required super.links,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      slug: json["slug"],
      name: json["name"],
      banner: json["banner"],
      bannerDesktop: json["banner_desktop"],
      bannerMobile: json["banner_mobile"],
      coverImage: json["cover_image"],
      icon: json["icon"],
      productCount: json["Product_Count"],
      numberOfChildren: json["number_of_children"],
      links: json["links"] == null ? null : LinksModel.fromJson(json["links"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'banner': banner,
      'banner_desktop': bannerDesktop,
      'banner_mobile': bannerMobile,
      'cover_image': coverImage,
      'icon': icon,
      'Product_Count': productCount,
      'number_of_children': numberOfChildren,
    };
  }
}


class LinksModel extends Links {
  const LinksModel({
    required super.products,
    required super.subCategories,
  });

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      products: json["products"],
      subCategories: json["sub_categories"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products,
      'sub_categories': subCategories,
    };
  }
}