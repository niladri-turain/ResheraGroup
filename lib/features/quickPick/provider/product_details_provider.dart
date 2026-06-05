import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/product_details_model.dart';

class ProductDetailsProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductData? _productDetails;
  ProductData? get productDetails => _productDetails;

  Future<void> fetchProductDetails({
    required String businessCategoryId,
    required String businessSubCategoryId,
    required String categoryId,
    required String productId,
    required String businessId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _productDetails = null;
    notifyListeners();

    try {
      final endpoint = "${ApiEndPoints.productDetails}?product_id=$productId&business_id=$businessId";
      final response = await _apiService.get(endpoint);

      if (response['status'] == true) {
        final productResponse = ProductDetailsModel.fromJson(response);
        _productDetails = productResponse.data;
        if (_productDetails == null) {
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
