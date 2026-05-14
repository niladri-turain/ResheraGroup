class PromotionalVendorBannerModel {
  bool? status;
  String? message;
  List<PromotionalBannerData>? data;

  PromotionalVendorBannerModel({this.status, this.message, this.data});

  PromotionalVendorBannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromotionalBannerData>[];
      json['data'].forEach((v) {
        data!.add(PromotionalBannerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionalBannerData {
  String? id;
  String? businessId;
  String? bannerType;
  String? title;
  String? image;
  bool? status;
  String? statusLabel;
  int? sortOrder;

  PromotionalBannerData(
      {this.id,
      this.businessId,
      this.bannerType,
      this.title,
      this.image,
      this.status,
      this.statusLabel,
      this.sortOrder});

  PromotionalBannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    bannerType = json['banner_type'];
    title = json['title'];
    image = json['image'];
    status = json['status'];
    statusLabel = json['status_label'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['business_id'] = businessId;
    data['banner_type'] = bannerType;
    data['title'] = title;
    data['image'] = image;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['sort_order'] = sortOrder;
    return data;
  }
}
