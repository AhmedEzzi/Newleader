import '../../../domain/brand/entities/brand.dart';

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

class BrandResponseModel {
  final List<BrandModel> brands;
  final int currentPage;
  final int totalPages;

  BrandResponseModel({
    required this.brands,
    required this.currentPage,
    required this.totalPages,
  });

  factory BrandResponseModel.fromJson(Map<String, dynamic> json) {
    return BrandResponseModel(
      brands: (json['data'] as List?)
          ?.map((item) => BrandModel.fromJson(item))
          .toList() ?? [],
      currentPage: json['current_page'] ?? 1,
      totalPages: json['last_page'] ?? 1,
    );
  }

  List<Brand> toEntities() {
    return brands.map((model) => model.toEntity()).toList();
  }
}