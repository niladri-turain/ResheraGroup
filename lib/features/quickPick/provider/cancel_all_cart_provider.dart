import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';

class CancelAllCartProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> cancelCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = await _prefService.getUserId();
      if (userId == null) {
        throw Exception("User ID not found");
      }

      // API: {{base_url}}/cart/user/3
      final response = await _apiService.delete(
        "${ApiEndPoints.cancelCart}/$userId",
      );

      if (response['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Failed to delete cart";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
