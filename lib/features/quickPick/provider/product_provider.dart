import 'package:flutter/cupertino.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/product_list_model.dart';
import 'package:get_it/get_it.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Map<String, List<ProductItem>> _categoryProducts = {};

  List<ProductItem> getProductsByCategory(String categoryId) {
    return _categoryProducts[categoryId] ?? [];
  }

  Future<void> fetchProducts({
    required String businessCategoryId,
    required String businessSubCategoryId,
    required String categoryId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final endpoint = "${ApiEndPoints.productList}?business_category_id=$businessCategoryId&business_sub_category_id=$businessSubCategoryId&category_id=$categoryId";
      final response = await _apiService.get(endpoint);

      if (response['status'] == true) {
        final productResponse = ProductListResponse.fromJson(response);
        _categoryProducts[categoryId] = productResponse.data;
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch products';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
