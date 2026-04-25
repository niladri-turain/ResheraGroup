import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/api_service.dart';
import '../model/business_sub_category_model.dart';

class SubCategoryProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();

  List<BusinessSubCategory> _subCategories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BusinessSubCategory> get subCategories => _subCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSubCategories(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiEndPoints.businessSubCategories}?business_category_id=$categoryId&search=',
      );
      final subCategoryResponse = BusinessSubCategoryResponse.fromJson(response);
      _subCategories = subCategoryResponse.data;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
