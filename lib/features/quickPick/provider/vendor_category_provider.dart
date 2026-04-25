import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/api_service.dart';
import '../model/vendor_category_model.dart';

class VendorCategoryProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();

  List<VendorCategoryItem> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VendorCategoryItem> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVendorCategories(String businessCategoryId, String subCategoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiEndPoints.categories}?business_category_id=$businessCategoryId&business_sub_category_id=$subCategoryId',
      );
      final vendorCategoryResponse = VendorCategoryResponse.fromJson(response);
      _categories = vendorCategoryResponse.data;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
