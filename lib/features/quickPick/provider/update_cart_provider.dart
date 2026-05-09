import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';

class UpdateCartProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  static const String _bearerToken = AppStrings.token;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateCart({
    required String cartId,
    required int quantity,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, String> body = {
        'quantity': quantity.toString(),
      };

      final Map<String, String> headers = {
        'X-HTTP-Method-Override': 'PUT',
      };

      // POST {{base_url}}/cart/{cart_id}
      // Using X-HTTP-Method-Override: PUT as requested for the update operation
      final response = await _apiService.multipartRequest(
        "${ApiEndPoints.updateCart}/$cartId",
        method: 'POST',
        body: body,
        headers: headers,
        token: _bearerToken,
      );

      if (response['success'] == true) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update cart';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
