import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';

class DeleteCartProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deleteCart({
    required String cartId,
  }) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _prefService.getToken();

      final Map<String, String> headers = {
        'X-HTTP-Method-Override': 'DELETE',
      };

      // POST {{base_url}}/cart/{cart_id} with DELETE override
      final response = await _apiService.multipartRequest(
        "${ApiEndPoints.updateCart}/$cartId",
        method: 'POST',
        headers: headers,
        // token: token ?? AppStrings.token,
      );

      if (response['success'] == true) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete item from cart';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
