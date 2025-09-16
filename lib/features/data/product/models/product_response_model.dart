import '../../../domain/product/entities/product.dart' as entity;
import 'product_model.dart';

class ProductResponseModel extends entity.ProductsResponse {
  const ProductResponseModel({
    required super.data,
    required super.links,
    required super.meta,
    required super.success,
    required super.status,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      data: json['data'] == null
          ? []
          : List<ProductModel>.from(
          json['data'].map((x) => ProductModel.fromJson(x))
      ),
      links: json['links'] == null
          ? const ProductResponseLinksModel(first: '', last: '', prev: null, next: '')
          : ProductResponseLinksModel.fromJson(json['links']),
      meta: json['meta'] == null
          ? const MetaModel(currentPage: 0, from: 0, lastPage: 0, links: [], path: '', perPage: 0, to: 0, total: 0)
          : MetaModel.fromJson(json['meta']),
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => (x as ProductModel).toJson()).toList(),
      'links': (links as ProductResponseLinksModel).toJson(),
      'meta': (meta as MetaModel).toJson(),
      'success': success,
      'status': status,
    };
  }
}

class ProductResponseLinksModel extends entity.ProductResponseLinks {
  const ProductResponseLinksModel({
    required super.first,
    required super.last,
    required super.prev,
    required super.next,
  });

  factory ProductResponseLinksModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseLinksModel(
      first: json['first'] ?? '',
      last: json['last'] ?? '',
      prev: json['prev'],
      next: json['next'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class MetaModel extends entity.Meta {
  const MetaModel({
    required super.currentPage,
    required super.from,
    required super.lastPage,
    required super.links,
    required super.path,
    required super.perPage,
    required super.to,
    required super.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'] ?? 0,
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      links: json['links'] == null
          ? []
          : List<LinkModel>.from(
          json['links'].map((x) => LinkModel.fromJson(x))
      ),
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links.map((x) => (x as LinkModel).toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class LinkModel extends entity.Link {
  const LinkModel({
    required super.url,
    required super.label,
    required super.active,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'] ?? '',
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}