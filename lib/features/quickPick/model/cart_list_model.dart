class CartListModel {
  bool? success;
  String? message;
  int? totalItems;
  List<CartItem>? data;

  CartListModel({this.success, this.message, this.totalItems, this.data});

  CartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalItems = json['total_items'];
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
  User? user;
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
      this.user,
      this.businessCategoryId,
      this.productId,
      this.productVariantId,
      this.productName,
      this.quantity,
      this.image,
      this.product,
      this.attributes});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    businessCategoryId = json['business_category_id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
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

class User {
  String? userId;
  String? name;
  String? email;
  String? mobile;
  String? profileImage;

  User({this.userId, this.name, this.email, this.mobile, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profile_image'];
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
    attributeId = json['attribute_id'];
    attributeValueId = json['attribute_value_id'];
    attributeName = json['attribute_name'];
    attributeValue = json['attribute_value'];
  }
}
