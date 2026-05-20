class LoginModel {
  bool? status;
  String? message;
  LoginData? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }
}

class LoginData {
  String? tokenType;
  String? token;
  UserData? user;

  LoginData({this.tokenType, this.token, this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    token = json['token'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }
}

class UserData {
  String? userId;
  String? username;
  String? name;
  String? email;
  int? phone;

  UserData({this.userId, this.username, this.name, this.email, this.phone});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
}
