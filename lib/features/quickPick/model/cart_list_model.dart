class CartListModel {
  bool? success;
  String? message;
  int? totalItems;
  List<CartItem>? data;

  CartListModel({this.success, this.message, this.totalItems, this.data});

  CartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? json['status'];
    message = json['message'];
    totalItems = json['total_items'] is int
        ? json['total_items']
        : int.tryParse(json['total_items']?.toString() ?? '');
    if (json['data'] != null) {
      data = <CartItem>[];
      json['data'].forEach((v) {
        data!.add(CartItem.fromJson(v));
      });
    }
  }
}

class CartItem {
  String? id;
  int? userId;
  String? businessCategoryId;
  String? productId;
  String? productVariantId;
  String? productName;
  int? quantity;
  String? image;
  Product? product;
  List<CartAttribute>? attributes;

  CartItem(
      {this.id,
      this.userId,
      this.businessCategoryId,
      this.productId,
      this.productVariantId,
      this.productName,
      this.quantity,
      this.image,
      this.product,
      this.attributes});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    // Handling "user" which is now an int ID
    userId = json['user'] is int 
        ? json['user'] 
        : int.tryParse(json['user']?.toString() ?? '');
    businessCategoryId = json['business_category_id']?.toString();
    productId = json['product_id']?.toString();
    productVariantId = json['product_variant_id']?.toString();
    productName = json['product_name'];
    quantity = json['quantity'] is int
        ? json['quantity']
        : int.tryParse(json['quantity']?.toString() ?? '');
    image = json['image'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['attributes'] != null) {
      attributes = <CartAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(CartAttribute.fromJson(v));
      });
    }
  }
}

class Product {
  String? name;
  dynamic finalPrice;
  String? image;

  Product({this.name, this.finalPrice, this.image});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    finalPrice = json['final_price'];
    image = json['image'];
  }
}

class CartAttribute {
  String? attributeId;
  String? attributeValueId;
  String? attributeName;
  String? attributeValue;

  CartAttribute(
      {this.attributeId,
      this.attributeValueId,
      this.attributeName,
      this.attributeValue});

  CartAttribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id']?.toString();
    attributeValueId = json['attribute_value_id']?.toString();
    attributeName = json['attribute_name'];
    attributeValue = json['attribute_value'];
  }
}
