class VendorListResponse {
  final List<Vendor> data;

  VendorListResponse({required this.data});

  factory VendorListResponse.fromJson(Map<String, dynamic> json) {
    return VendorListResponse(
      data: (json['data'] as List).map((i) => Vendor.fromJson(i)).toList(),
    );
  }
}

class Vendor {
  final String id;
  final String businessName;
  final String? businessCategoryId;
  final String? businessSubCategoryId;
  final VendorCategory? category;
  final VendorCategory? subCategory;
  final VendorUser? user;
  final VendorKycDetail? kycDetail;

  Vendor({
    required this.id,
    required this.businessName,
    this.businessCategoryId,
    this.businessSubCategoryId,
    this.category,
    this.subCategory,
    this.user,
    this.kycDetail,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? '',
      businessName: json['business_name'] ?? '',
      businessCategoryId: json['business_category_id'],
      businessSubCategoryId: json['business_sub_category_id'],
      category: json['category'] != null ? VendorCategory.fromJson(json['category']) : null,
      subCategory: json['sub_category'] != null ? VendorCategory.fromJson(json['sub_category']) : null,
      user: json['user'] != null ? VendorUser.fromJson(json['user']) : null,
      kycDetail: json['kycdetail'] != null ? VendorKycDetail.fromJson(json['kycdetail']) : null,
    );
  }
}

class VendorCategory {
  final String id;
  final String name;

  VendorCategory({required this.id, required this.name});

  factory VendorCategory.fromJson(Map<String, dynamic> json) {
    return VendorCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class VendorUser {
  final String id;
  final String vendorId;
  final String name;
  final String mobile;
  final String? email;
  final String? kycStatus;

  VendorUser({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.mobile,
    this.email,
    this.kycStatus,
  });

  factory VendorUser.fromJson(Map<String, dynamic> json) {
    return VendorUser(
      id: json['id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'],
      kycStatus: json['kyc_status'],
    );
  }
}

class VendorKycDetail {
  final String? id;
  final KycImage? ownerPhoto;
  final KycImage? shopPhoto;

  VendorKycDetail({this.id, this.ownerPhoto, this.shopPhoto});

  factory VendorKycDetail.fromJson(Map<String, dynamic> json) {
    return VendorKycDetail(
      id: json['id']?.toString(),
      ownerPhoto: json['owner_photo'] != null ? KycImage.fromJson(json['owner_photo']) : null,
      shopPhoto: json['shop_photo'] != null ? KycImage.fromJson(json['shop_photo']) : null,
    );
  }
}

class KycImage {
  final String? url;
  final int? status;
  final String? statusLabel;

  KycImage({this.url, this.status, this.statusLabel});

  factory KycImage.fromJson(Map<String, dynamic> json) {
    return KycImage(
      url: json['url'],
      status: json['status'],
      statusLabel: json['status_label'],
    );
  }
}
