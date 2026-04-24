class BusinessCategoryResponse {
  final List<BusinessCategory> data;

  BusinessCategoryResponse({required this.data});

  factory BusinessCategoryResponse.fromJson(Map<String, dynamic> json) {
    return BusinessCategoryResponse(
      data: (json['data'] as List)
          .map((i) => BusinessCategory.fromJson(i))
          .toList(),
    );
  }
}

class BusinessCategory {
  final String id;
  final String name;
  final String image;
  final int status;
  final String statusLabel;
  final String createdAt;

  BusinessCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      statusLabel: json['status_label'],
      createdAt: json['created_at'],
    );
  }
}
