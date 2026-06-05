import 'order_list_model.dart';

class OrderDetailsModel {
  bool? success;
  OrderData? data;

  OrderDetailsModel({this.success, this.data});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
  }
}
