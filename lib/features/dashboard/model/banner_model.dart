class BannerResponseModel {
  bool? status;
  String? message;
  Map<String, List<BannerItem>>? data;

  BannerResponseModel({this.status, this.message, this.data});

  BannerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = {};
      json['data'].forEach((key, value) {
        if (value is List) {
          data![key] = value.map((v) => BannerItem.fromJson(v)).toList();
        }
      });
    }
  }
}

class BannerItem {
  int? id;
  String? section;
  String? image;
  String? youtubeLink;

  BannerItem({this.id, this.section, this.image, this.youtubeLink});

  BannerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    section = json['section'];
    image = json['image'];
    youtubeLink = json['youtube_link'];
  }
}
