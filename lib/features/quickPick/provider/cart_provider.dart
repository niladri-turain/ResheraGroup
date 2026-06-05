import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../model/product_details_model.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();
  
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _clearCartRequired = false;
  bool get clearCartRequired => _clearCartRequired;

  Future<bool> addToCart({
    required String businessId,
    required String productId,
    required String businessCategoryId,
    required String variantId,
    required int quantity,
    required List<Attribute> attributes,
  }) async {
    _isSyncing = true;
    _errorMessage = null;
    _clearCartRequired = false;
    notifyListeners();

    try {
      final token = await _prefService.getToken();
      final userId = await _prefService.getUserId();

      // Building flat structure for Multipart form-data as per your requirement
      final Map<String, String> body = {
        'user_id': userId?.toString() ?? '',
        'business_id': businessId,
        'product_id': productId,
        'business_category_id': businessCategoryId,
        'product_variant_id': variantId,
        'quantity': quantity.toString(),
      };

      // Adding attributes in the format: attributes[i][attribute_id]
      for (int i = 0; i < attributes.length; i++) {
        body['attributes[$i][attribute_id]'] = attributes[i].attributeId ?? "";
        body['attributes[$i][attribute_value_id]'] = attributes[i].valueId ?? "";
      }

      // Using multipartRequest for form-data support with POST method
      final response = await _apiService.multipartRequest(
        ApiEndPoints.cart,
        method: 'POST',
        body: body,
      );

      // API might return "success" or "status" as the boolean flag
      final bool isSuccess = response['success'] == true ;

      if (isSuccess) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to add to cart';
        final String err = _errorMessage!.toLowerCase();
        // Check for vendor conflict flag in the structured response or message
        if (response['action_required'] == 'clear_cart' ||
            err.contains('clear_cart') ||
            err.contains('another shop') ||
            err.contains('different vendor') ||
            err.contains('another vendor') ||
            err.contains('dishes from')) {
          _clearCartRequired = true;
        }
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      final String err = _errorMessage!.toLowerCase();
      // Even in catch block, check if the error message implies a vendor conflict
      if (err.contains('clear_cart') ||
          err.contains('another shop') ||
          err.contains('different vendor') ||
          err.contains('another vendor') ||
          err.contains('dishes from')) {
        _clearCartRequired = true;
      }
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
