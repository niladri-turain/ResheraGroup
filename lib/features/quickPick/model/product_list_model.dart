class ProductListResponse {
  final bool status;
  final String message;
  final List<ProductItem> data;
  final PaginationMeta? meta;

  ProductListResponse({
    required this.status,
    required this.message,
    required this.data,
    this.meta,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => ProductItem.fromJson(item))
              .toList() ??
          [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 0,
    );
  }
}

class ProductItem {
  final String productId;
  final String name;
  final String? description;
  final String? businessCategoryId;
  final String? businessSubCategoryId;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final PrimaryVariant? primaryVariant;
  final double mrp;
  final double costPrice;
  final double sellingPrice;
  final double discount;
  final double finalPrice;
  final String? image;
  final int? status;
  final String? statusLabel;
  final int? productType;
  final String? createdAt;

  ProductItem({
    required this.productId,
    required this.name,
    this.description,
    this.businessCategoryId,
    this.businessSubCategoryId,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.primaryVariant,
    required this.mrp,
    required this.costPrice,
    required this.sellingPrice,
    required this.discount,
    required this.finalPrice,
    this.image,
    this.status,
    this.statusLabel,
    this.productType,
    this.createdAt,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      businessCategoryId: json['business_category_id'],
      businessSubCategoryId: json['business_sub_category_id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      subSubCategoryId: json['sub_sub_category_id'],
      primaryVariant: json['primary_variant'] != null
          ? PrimaryVariant.fromJson(json['primary_variant'])
          : null,
      mrp: (json['mrp'] ?? 0).toDouble(),
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      finalPrice: (json['final_price'] ?? 0).toDouble(),
      image: json['image'],
      status: json['status'],
      statusLabel: json['status_label'],
      productType: json['product_type'],
      createdAt: json['created_at'],
    );
  }
}

class PrimaryVariant {
  final String variantId;
  final String? sku;
  final String? barcode;
  final double mrp;
  final double costPrice;
  final double sellingPrice;
  final double discount;
  final double finalPrice;
  final bool isPrimary;
  final int totalStock;
  final List<ProductAttribute> attributes;
  final List<ProductVariantImage> images;
  final VariantMeta? meta;

  PrimaryVariant({
    required this.variantId,
    this.sku,
    this.barcode,
    required this.mrp,
    required this.costPrice,
    required this.sellingPrice,
    required this.discount,
    required this.finalPrice,
    required this.isPrimary,
    required this.totalStock,
    required this.attributes,
    required this.images,
    this.meta,
  });

  factory PrimaryVariant.fromJson(Map<String, dynamic> json) {
    return PrimaryVariant(
      variantId: json['variant_id'] ?? '',
      sku: json['sku'],
      barcode: json['barcode'],
      mrp: (json['mrp'] ?? 0).toDouble(),
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      finalPrice: (json['final_price'] ?? 0).toDouble(),
      isPrimary: json['is_primary'] ?? false,
      totalStock: json['total_stock'] ?? 0,
      attributes: (json['attributes'] as List?)
              ?.map((item) => ProductAttribute.fromJson(item))
              .toList() ??
          [],
      images: (json['images'] as List?)
              ?.map((item) => ProductVariantImage.fromJson(item))
              .toList() ??
          [],
      meta: json['meta'] != null ? VariantMeta.fromJson(json['meta']) : null,
    );
  }
}

class ProductAttribute {
  final String attributeId;
  final String attributeName;
  final String valueId;
  final String value;

  ProductAttribute({
    required this.attributeId,
    required this.attributeName,
    required this.valueId,
    required this.value,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      attributeId: json['attribute_id'] ?? '',
      attributeName: json['attribute_name'] ?? '',
      valueId: json['value_id'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class ProductVariantImage {
  final String id;
  final String? imageLarge;
  final String? imageMedium;
  final String? imageSmall;

  ProductVariantImage({
    required this.id,
    this.imageLarge,
    this.imageMedium,
    this.imageSmall,
  });

  factory ProductVariantImage.fromJson(Map<String, dynamic> json) {
    return ProductVariantImage(
      id: json['id'] ?? '',
      imageLarge: json['image_large'],
      imageMedium: json['image_medium'],
      imageSmall: json['image_small'],
    );
  }
}

class VariantMeta {
  final String id;
  final String? metaTitle;
  final String? metaKeyword;
  final String? metaDescription;

  VariantMeta({
    required this.id,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
  });

  factory VariantMeta.fromJson(Map<String, dynamic> json) {
    return VariantMeta(
      id: json['id'] ?? '',
      metaTitle: json['meta_title'],
      metaKeyword: json['meta_keyword'],
      metaDescription: json['meta_description'],
    );
  }
}
