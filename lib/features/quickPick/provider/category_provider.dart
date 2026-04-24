import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/api_service.dart';
import '../model/business_category_model.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();
  
  List<BusinessCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BusinessCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndPoints.businessCategories);
      final businessCategoryResponse = BusinessCategoryResponse.fromJson(response);
      _categories = businessCategoryResponse.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
