class OrderModel {
  bool? success;
  String? message;
  int? totalItems;
  List<OrderItem>? data;

  OrderModel({this.success, this.message, this.totalItems, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalItems = json['total_items'];
    if (json['data'] != null) {
      data = <OrderItem>[];
      json['data'].forEach((v) {
        data!.add(OrderItem.fromJson(v));
      });
    }
  }
}

class OrderItem {
  String? id;
  int? userId;
  String? businessCategoryId;
  String? productId;
  String? productVariantId;
  String? productName;
  int? quantity;
  String? image;
  ProductInfo? product;
  List<OrderAttribute>? attributes;

  OrderItem({
    this.id,
    this.userId,
    this.businessCategoryId,
    this.productId,
    this.productVariantId,
    this.productName,
    this.quantity,
    this.image,
    this.product,
    this.attributes,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user'] is int ? json['user'] : int.tryParse(json['user']?.toString() ?? '');
    businessCategoryId = json['business_category_id']?.toString();
    productId = json['product_id']?.toString();
    productVariantId = json['product_variant_id']?.toString();
    productName = json['product_name']?.toString();
    quantity = json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '');
    image = json['image']?.toString();
    product = json['product'] != null ? ProductInfo.fromJson(json['product']) : null;
    if (json['attributes'] != null) {
      attributes = <OrderAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(OrderAttribute.fromJson(v));
      });
    }
  }
}

class ProductInfo {
  String? name;
  num? finalPrice;
  String? image;

  ProductInfo({this.name, this.finalPrice, this.image});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    finalPrice = json['final_price'] is num ? json['final_price'] : double.tryParse(json['final_price']?.toString() ?? '');
    image = json['image']?.toString();
  }
}

class OrderAttribute {
  String? attributeId;
  String? attributeValueId;
  String? attributeName;
  String? attributeValue;

  OrderAttribute({
    this.attributeId,
    this.attributeValueId,
    this.attributeName,
    this.attributeValue,
  });

  OrderAttribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id']?.toString();
    attributeValueId = json['attribute_value_id']?.toString();
    attributeName = json['attribute_name']?.toString();
    attributeValue = json['attribute_value']?.toString();
  }
}
