class ProductListResponse {
  final bool status;
  final String message;
  final List<ProductItem> data;

  ProductListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => ProductItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ProductItem {
  final String productId;
  final String name;
  final String? description;
  final String? image;
  final double finalPrice;

  ProductItem({
    required this.productId,
    required this.name,
    this.description,
    this.image,
    required this.finalPrice,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      finalPrice: (json['final_price'] ?? 0).toDouble(),
    );
  }
}
