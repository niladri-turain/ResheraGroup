class ProductDetailsModel {
  final bool? status;
  final String? message;
  final ProductData? data;

  ProductDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final String? productId;
  final String? name;
  final Business? business;
  final String? businessCategoryId;
  final String? businessSubCategoryId;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final List<Variant>? variants;
  final double? mrp;
  final double? costPrice;
  final double? sellingPrice;
  final double? discount;
  final double? finalPrice;
  final String? image;
  final int? status;
  final String? statusLabel;
  final int? productType;
  final String? createdAt;

  ProductData({
    this.productId,
    this.name,
    this.business,
    this.businessCategoryId,
    this.businessSubCategoryId,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.variants,
    this.mrp,
    this.costPrice,
    this.sellingPrice,
    this.discount,
    this.finalPrice,
    this.image,
    this.status,
    this.statusLabel,
    this.productType,
    this.createdAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['product_id'],
      name: json['name'],
      business: json['business'] != null ? Business.fromJson(json['business']) : null,
      businessCategoryId: json['business_category_id'],
      businessSubCategoryId: json['business_sub_category_id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      subSubCategoryId: json['sub_sub_category_id'],
      variants: json['variants'] != null
          ? List<Variant>.from(json['variants'].map((x) => Variant.fromJson(x)))
          : null,
      mrp: json['mrp']?.toDouble(),
      costPrice: json['cost_price']?.toDouble(),
      sellingPrice: json['selling_price']?.toDouble(),
      discount: json['discount']?.toDouble(),
      finalPrice: json['final_price']?.toDouble(),
      image: json['image'],
      status: json['status'],
      statusLabel: json['status_label'],
      productType: json['product_type'],
      createdAt: json['created_at'],
    );
  }
}

class Business {
  final String? businessId;
  final String? businessName;

  Business({
    this.businessId,
    this.businessName,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessId: json['business_id'],
      businessName: json['business_name'],
    );
  }
}

class Variant {
  final String? variantId;
  final String? sku;
  final String? barcode;
  final double? mrp;
  final double? costPrice;
  final double? sellingPrice;
  final double? discount;
  final double? finalPrice;
  final String? shortDescription;
  final String? longDescription;
  final String? manufactureDate;
  final String? expiryDate;
  final bool? isPrimary;
  final int? totalStock;
  final List<Attribute>? attributes;
  final List<VariantImage>? images;
  final Meta? meta;

  Variant({
    this.variantId,
    this.sku,
    this.barcode,
    this.mrp,
    this.costPrice,
    this.sellingPrice,
    this.discount,
    this.finalPrice,
    this.shortDescription,
    this.longDescription,
    this.manufactureDate,
    this.expiryDate,
    this.isPrimary,
    this.totalStock,
    this.attributes,
    this.images,
    this.meta,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      variantId: json['variant_id'],
      sku: json['sku'],
      barcode: json['barcode'],
      mrp: json['mrp']?.toDouble(),
      costPrice: json['cost_price']?.toDouble(),
      sellingPrice: json['selling_price']?.toDouble(),
      discount: json['discount']?.toDouble(),
      finalPrice: json['final_price']?.toDouble(),
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
      manufactureDate: json['manufacture_date'],
      expiryDate: json['expiry_date'],
      isPrimary: json['is_primary'],
      totalStock: json['total_stock'],
      attributes: json['attributes'] != null
          ? List<Attribute>.from(json['attributes'].map((x) => Attribute.fromJson(x)))
          : null,
      images: json['images'] != null
          ? List<VariantImage>.from(json['images'].map((x) => VariantImage.fromJson(x)))
          : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class Attribute {
  final String? attributeId;
  final String? attributeName;
  final String? valueId;
  final String? value;

  Attribute({
    this.attributeId,
    this.attributeName,
    this.valueId,
    this.value,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      attributeId: json['attribute_id'],
      attributeName: json['attribute_name'],
      valueId: json['value_id'],
      value: json['value'],
    );
  }
}

class VariantImage {
  final String? id;
  final String? imageLarge;
  final String? imageMedium;
  final String? imageSmall;

  VariantImage({
    this.id,
    this.imageLarge,
    this.imageMedium,
    this.imageSmall,
  });

  factory VariantImage.fromJson(Map<String, dynamic> json) {
    return VariantImage(
      id: json['id'],
      imageLarge: json['image_large'],
      imageMedium: json['image_medium'],
      imageSmall: json['image_small'],
    );
  }
}

class Meta {
  final String? id;
  final String? metaTitle;
  final String? metaKeyword;
  final String? metaDescription;

  Meta({
    this.id,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'],
      metaTitle: json['meta_title'],
      metaKeyword: json['meta_keyword'],
      metaDescription: json['meta_description'],
    );
  }
}
