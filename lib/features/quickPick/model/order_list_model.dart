class OrderListModel {
  bool? success;
  List<OrderData>? data;

  OrderListModel({this.success, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
  }
}

class OrderData {
  String? id;
  String? orderNo;
  String? invoiceNo;
  String? businessId;
  int? businessCategoryId;
  int? userId;
  int? paymentStatus;
  String? paymentStatusLabel;
  int? paymentMethod;
  String? paymentMethodLabel;
  int? orderStatus;
  String? orderStatusLabel;
  int? totalItems;
  num? itemsTotal;
  num? discountAmount;
  num? platformCharge;
  num? deliveryCharge;
  num? taxAmount;
  num? grandTotal;
  num? loyaltyUsed;
  num? loyaltyEarned;
  num? walletUsed;
  num? onlinePaid;
  String? notes;
  List<OrderItem>? items;
  List<dynamic>? addresses;
  List<StatusHistory>? statusHistories;
  Business? business;
  BusinessCategory? businessCategory;
  String? placedAt;
  String? createdAt;
  String? updatedAt;

  OrderData({
    this.id,
    this.orderNo,
    this.invoiceNo,
    this.businessId,
    this.businessCategoryId,
    this.userId,
    this.paymentStatus,
    this.paymentStatusLabel,
    this.paymentMethod,
    this.paymentMethodLabel,
    this.orderStatus,
    this.orderStatusLabel,
    this.totalItems,
    this.itemsTotal,
    this.discountAmount,
    this.platformCharge,
    this.deliveryCharge,
    this.taxAmount,
    this.grandTotal,
    this.loyaltyUsed,
    this.loyaltyEarned,
    this.walletUsed,
    this.onlinePaid,
    this.notes,
    this.items,
    this.addresses,
    this.statusHistories,
    this.business,
    this.businessCategory,
    this.placedAt,
    this.createdAt,
    this.updatedAt,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderNo = json['order_no'];
    invoiceNo = json['invoice_no'];
    businessId = json['business_id'];
    businessCategoryId = json['business_category_id'];
    userId = json['user_id'];
    paymentStatus = json['payment_status'];
    paymentStatusLabel = json['payment_status_label'];
    paymentMethod = json['payment_method'];
    paymentMethodLabel = json['payment_method_label'];
    orderStatus = json['order_status'];
    orderStatusLabel = json['order_status_label']?.toString();
    totalItems = json['total_items'];
    itemsTotal = json['items_total'];
    discountAmount = json['discount_amount'];
    platformCharge = json['platform_charge'];
    deliveryCharge = json['delivery_charge'];
    taxAmount = json['tax_amount'];
    grandTotal = json['grand_total'];
    loyaltyUsed = json['loyalty_used'];
    loyaltyEarned = json['loyalty_earned'];
    walletUsed = json['wallet_used'];
    onlinePaid = json['online_paid'];
    notes = json['notes'];
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = List<dynamic>.from(json['addresses']);
    }
    if (json['status_histories'] != null) {
      statusHistories = <StatusHistory>[];
      json['status_histories'].forEach((v) {
        statusHistories!.add(StatusHistory.fromJson(v));
      });
    }
    business = json['business'] != null ? Business.fromJson(json['business']) : null;
    businessCategory = json['business_category'] != null ? BusinessCategory.fromJson(json['business_category']) : null;
    placedAt = json['placed_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class OrderItem {
  String? id;
  int? productId;
  int? productVariantId;
  String? productName;
  String? sku;
  String? image;
  int? quantity;
  num? mrp;
  num? sellingPrice;
  num? discountAmount;
  num? finalPrice;
  num? subtotal;
  num? loyaltyPoints;
  String? status;
  String? cancelNote;
  List<OrderAttribute>? attributes;
  ProductSnapshot? productSnapshot;

  OrderItem({
    this.id,
    this.productId,
    this.productVariantId,
    this.productName,
    this.sku,
    this.image,
    this.quantity,
    this.mrp,
    this.sellingPrice,
    this.discountAmount,
    this.finalPrice,
    this.subtotal,
    this.loyaltyPoints,
    this.status,
    this.cancelNote,
    this.attributes,
    this.productSnapshot,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    productName = json['product_name'];
    sku = json['sku'];
    image = json['image'];
    quantity = json['quantity'];
    mrp = json['mrp'];
    sellingPrice = json['selling_price'];
    discountAmount = json['discount_amount'];
    finalPrice = json['final_price'];
    subtotal = json['subtotal'] ?? json['sub_total'];
    loyaltyPoints = json['loyalty_points'];
    status = json['status']?.toString();
    cancelNote = json['cancel_note'];
    if (json['attributes'] != null) {
      attributes = <OrderAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(OrderAttribute.fromJson(v));
      });
    }
    productSnapshot = json['product_snapshot'] != null ? ProductSnapshot.fromJson(json['product_snapshot']) : null;
  }
}

class OrderAttribute {
  int? attributeId;
  int? attributeValueId;
  String? name;
  String? value;

  OrderAttribute({this.attributeId, this.attributeValueId, this.name, this.value});

  OrderAttribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeValueId = json['attribute_value_id'];
    name = json['name'];
    value = json['value'];
  }
}

class ProductSnapshot {
  String? productName;
  String? sku;
  num? mrp;
  num? sellingPrice;
  num? finalPrice;
  String? image;

  ProductSnapshot({
    this.productName,
    this.sku,
    this.mrp,
    this.sellingPrice,
    this.finalPrice,
    this.image,
  });

  ProductSnapshot.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    sku = json['sku'];
    mrp = json['mrp'];
    sellingPrice = json['selling_price'];
    finalPrice = json['final_price'];
    image = json['image'];
  }
}

class Business {
  int? id;
  int? userId;
  dynamic sponsorId;
  String? businessType;
  String? businessName;
  int? businessCategoryId;
  int? businessSubCategoryId;
  dynamic yearsInBusiness;
  dynamic gstNumber;
  dynamic panNumber;
  dynamic fssaiLicense;
  dynamic registrationNumber;
  String? createdAt;
  String? updatedAt;

  Business({
    this.id,
    this.userId,
    this.sponsorId,
    this.businessType,
    this.businessName,
    this.businessCategoryId,
    this.businessSubCategoryId,
    this.yearsInBusiness,
    this.gstNumber,
    this.panNumber,
    this.fssaiLicense,
    this.registrationNumber,
    this.createdAt,
    this.updatedAt,
  });

  Business.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sponsorId = json['sponsor_id'];
    businessType = json['business_type'];
    businessName = json['business_name'];
    businessCategoryId = json['business_category_id'];
    businessSubCategoryId = json['business_sub_category_id'];
    yearsInBusiness = json['years_in_business'];
    gstNumber = json['gst_number'];
    panNumber = json['pan_number'];
    fssaiLicense = json['fssai_license'];
    registrationNumber = json['registration_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class BusinessCategory {
  int? id;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  BusinessCategory({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  BusinessCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
}

class StatusHistory {
  int? id;
  int? orderId;
  int? status;
  dynamic trackingId;
  dynamic deliveryPartnerId;
  dynamic deliveryPartnerName;
  String? remarks;
  dynamic changedBy;
  String? createdAt;
  String? updatedAt;

  StatusHistory({
    this.id,
    this.orderId,
    this.status,
    this.trackingId,
    this.deliveryPartnerId,
    this.deliveryPartnerName,
    this.remarks,
    this.changedBy,
    this.createdAt,
    this.updatedAt,
  });

  StatusHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
    trackingId = json['tracking_id'];
    deliveryPartnerId = json['delivery_partner_id'];
    deliveryPartnerName = json['delivery_partner_name'];
    remarks = json['remarks'];
    changedBy = json['changed_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
