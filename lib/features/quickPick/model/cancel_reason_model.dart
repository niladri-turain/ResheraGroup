class CancelReasonModel {
  bool? success;
  String? message;
  List<CancelReason>? data;

  CancelReasonModel({this.success, this.message, this.data});

  CancelReasonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CancelReason>[];
      json['data'].forEach((v) {
        data!.add(CancelReason.fromJson(v));
      });
    }
  }
}

class CancelReason {
  String? id;
  String? reason;
  bool? status;

  CancelReason({this.id, this.reason, this.status});

  CancelReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    status = json['status'];
  }
}
