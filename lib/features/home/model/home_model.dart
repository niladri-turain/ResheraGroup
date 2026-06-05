class HomeDashboardModel {
  bool? status;
  String? message;
  DashboardData? data;

  HomeDashboardModel({this.status, this.message, this.data});

  HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }
}

class DashboardData {
  String? sessionToken;
  // Add other fields as per API response

  DashboardData({this.sessionToken});

  DashboardData.fromJson(Map<String, dynamic> json) {
    sessionToken = json['session_token'];
  }
}
