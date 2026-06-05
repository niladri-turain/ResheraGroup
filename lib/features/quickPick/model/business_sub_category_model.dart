class BusinessSubCategoryResponse {
  final List<BusinessSubCategory> data;

  BusinessSubCategoryResponse({required this.data});

  factory BusinessSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return BusinessSubCategoryResponse(
      data: (json['data'] as List)
          .map((i) => BusinessSubCategory.fromJson(i))
          .toList(),
    );
  }
}

class BusinessSubCategory {
  final String id;
  final String name;
  final String image;
  final int status;
  final String commission;
  final String statusLabel;
  final ParentCategory category;
  final String createdAt;

  BusinessSubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.commission,
    required this.statusLabel,
    required this.category,
    required this.createdAt,
  });

  factory BusinessSubCategory.fromJson(Map<String, dynamic> json) {
    return BusinessSubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      commission: json['commission'] ?? '0.00',
      statusLabel: json['status_label'] ?? '',
      category: ParentCategory.fromJson(json['category'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ParentCategory {
  final String id;
  final String name;

  ParentCategory({required this.id, required this.name});

  factory ParentCategory.fromJson(Map<String, dynamic> json) {
    return ParentCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
