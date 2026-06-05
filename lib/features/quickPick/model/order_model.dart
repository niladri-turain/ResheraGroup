class OrderModel {
  bool? success;
  String? message;
  OrderData? data;
  List<OrderData>? dataList;

  OrderModel({this.success, this.message, this.data, this.dataList});

  OrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = <OrderData>[];
        json['data'].forEach((v) {
          dataList!.add(OrderData.fromJson(v));
        });
      } else {
        data = OrderData.fromJson(json['data']);
      }
    }
  }
}

class OrderData {
  int? id;
  String? orderNo;
  String? invoiceNo;
  int? userId;
  int? totalItems;
  String? itemsTotal;
  String? discountAmount;
  String? platformCharge;
  String? deliveryCharge;
  String? taxAmount;
  String? grandTotal;
  String? loyaltyUsed;
  String? onlinePaid;
  int? paymentStatus;
  int? paymentMethod;
  int? orderStatus;
  String? placedAt;
  List<OrderItems>? items;
  List<OrderAddresses>? addresses;
  List<StatusHistories>? statusHistories;

  OrderData({
    this.id,
    this.orderNo,
    this.invoiceNo,
    this.userId,
    this.totalItems,
    this.itemsTotal,
    this.discountAmount,
    this.platformCharge,
    this.deliveryCharge,
    this.taxAmount,
    this.grandTotal,
    this.loyaltyUsed,
    this.onlinePaid,
    this.paymentStatus,
    this.paymentMethod,
    this.orderStatus,
    this.placedAt,
    this.items,
    this.addresses,
    this.statusHistories,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    invoiceNo = json['invoice_no'];
    userId = json['user_id'];
    totalItems = json['total_items'];
    itemsTotal = json['items_total']?.toString();
    discountAmount = json['discount_amount']?.toString();
    platformCharge = json['platform_charge']?.toString();
    deliveryCharge = json['delivery_charge']?.toString();
    taxAmount = json['tax_amount']?.toString();
    grandTotal = json['grand_total']?.toString();
    loyaltyUsed = json['loyalty_used']?.toString();
    onlinePaid = json['online_paid']?.toString();
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    orderStatus = json['order_status'];
    placedAt = json['placed_at'];
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items!.add(OrderItems.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <OrderAddresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(OrderAddresses.fromJson(v));
      });
    }
    if (json['status_histories'] != null) {
      statusHistories = <StatusHistories>[];
      json['status_histories'].forEach((v) {
        statusHistories!.add(StatusHistories.fromJson(v));
      });
    }
  }
}

class OrderItems {
  int? id;
  int? productId;
  String? productName;
  int? quantity;
  String? mrp;
  String? sellingPrice;
  String? finalPrice;
  ProductSnapshot? productSnapshot;
  List<OrderAttributes>? attributes;

  OrderItems({
    this.id,
    this.productId,
    this.productName,
    this.quantity,
    this.mrp,
    this.sellingPrice,
    this.finalPrice,
    this.productSnapshot,
    this.attributes,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    mrp = json['mrp']?.toString();
    sellingPrice = json['selling_price']?.toString();
    finalPrice = json['final_price']?.toString();
    productSnapshot = json['product_snapshot'] != null
        ? ProductSnapshot.fromJson(json['product_snapshot'])
        : null;
    if (json['attributes'] != null) {
      attributes = <OrderAttributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(OrderAttributes.fromJson(v));
      });
    }
  }
}

class ProductSnapshot {
  String? productName;
  String? sku;
  String? mrp;
  String? finalPrice;
  String? image;

  ProductSnapshot({this.productName, this.sku, this.mrp, this.finalPrice, this.image});

  ProductSnapshot.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    sku = json['sku'];
    mrp = json['mrp']?.toString();
    finalPrice = json['final_price']?.toString();
    image = json['image'];
  }
}

class OrderAttributes {
  int? id;
  String? attributeName;
  String? attributeValue;

  OrderAttributes({this.id, this.attributeName, this.attributeValue});

  OrderAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeName = json['attribute_name'];
    attributeValue = json['attribute_value'];
  }
}

class OrderAddresses {
  String? billingAddress;
  String? billingPincode;
  String? shippingAddress;
  String? shippingPincode;

  OrderAddresses({
    this.billingAddress,
    this.billingPincode,
    this.shippingAddress,
    this.shippingPincode,
  });

  OrderAddresses.fromJson(Map<String, dynamic> json) {
    billingAddress = json['billing_address'];
    billingPincode = json['billing_pincode'];
    shippingAddress = json['shipping_address'];
    shippingPincode = json['shipping_pincode'];
  }
}

class StatusHistories {
  int? status;
  String? remarks;
  String? createdAt;

  StatusHistories({this.status, this.remarks, this.createdAt});

  StatusHistories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
  }
}
