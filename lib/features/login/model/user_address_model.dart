class UserAddressModel {
  bool? status;
  String? message;
  AddressData? data;

  UserAddressModel({this.status, this.message, this.data});

  UserAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AddressData.fromJson(json['data']) : null;
  }
}

class AddressData {
  BillingAddress? billing;
  List<ShippingAddress>? shipping;

  AddressData({this.billing, this.shipping});

  AddressData.fromJson(Map<String, dynamic> json) {
    billing = json['billing'] != null ? BillingAddress.fromJson(json['billing']) : null;
    if (json['shipping'] != null) {
      shipping = <ShippingAddress>[];
      json['shipping'].forEach((v) {
        shipping!.add(ShippingAddress.fromJson(v));
      });
    }
  }
}

class BillingAddress {
  String? address;
  CityStateInfo? city;
  CityStateInfo? state;
  String? pincode;

  BillingAddress({this.address, this.city, this.state, this.pincode});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'] != null ? CityStateInfo.fromJson(json['city']) : null;
    state = json['state'] != null ? CityStateInfo.fromJson(json['state']) : null;
    pincode = json['pincode'];
  }
}

class ShippingAddress {
  int? id;
  String? name;
  String? phone;
  String? address;
  CityStateInfo? city;
  CityStateInfo? state;
  String? pincode;
  String? type;

  ShippingAddress({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.type,
  });

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'] != null ? CityStateInfo.fromJson(json['city']) : null;
    state = json['state'] != null ? CityStateInfo.fromJson(json['state']) : null;
    pincode = json['pincode'];
    type = json['type'];
  }
}

class CityStateInfo {
  int? id;
  String? name;

  CityStateInfo({this.id, this.name});

  CityStateInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
