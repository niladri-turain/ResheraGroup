class VendorCategoryResponse {
  final List<VendorCategoryItem> data;

  VendorCategoryResponse({required this.data});

  factory VendorCategoryResponse.fromJson(Map<String, dynamic> json) {
    return VendorCategoryResponse(
      data: (json['data'] as List)
          .map((i) => VendorCategoryItem.fromJson(i))
          .toList(),
    );
  }
}

class VendorCategoryItem {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final int status;
  final String statusLabel;

  VendorCategoryItem({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.status,
    required this.statusLabel,
  });

  factory VendorCategoryItem.fromJson(Map<String, dynamic> json) {
    return VendorCategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      status: json['status'] ?? 0,
      statusLabel: json['status_label'] ?? '',
    );
  }
}
