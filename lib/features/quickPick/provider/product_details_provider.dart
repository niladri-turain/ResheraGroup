import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/product_list_model.dart';

class ProductDetailsProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductItem? _productDetails;
  ProductItem? get productDetails => _productDetails;

  Future<void> fetchProductDetails({
    required String businessCategoryId,
    required String businessSubCategoryId,
    required String categoryId,
    required String productId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _productDetails = null;
    notifyListeners();

    try {
      final endpoint = "${ApiEndPoints.productList}?business_category_id=$businessCategoryId&business_sub_category_id=$businessSubCategoryId&category_id=$categoryId&product_id=$productId";
      final response = await _apiService.get(endpoint);

      if (response['status'] == true) {
        final productResponse = ProductListResponse.fromJson(response);
        if (productResponse.data.isNotEmpty) {
          _productDetails = productResponse.data.first;
        } else {
          _errorMessage = "Product not found";
        }
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch product details';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
