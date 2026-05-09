import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/cart_list_model.dart';

class ViewCartListProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  
  // Constant Bearer Token & User ID
  static const String _bearerToken = "3|z7TObCtolxbRKsFaV6Kvx3kP9CzX64Fvcxews6yo893fa3bd";
  static const String _userId = "Wpmbk5ezJn";

  CartListModel? _cartData;
  CartListModel? get cartData => _cartData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches or Updates the cart using GET method with form-data body as per your screenshot.
  /// Call without parameters to fetch list, or with parameters to update and fetch.
  Future<void> fetchCart({
    String? productId,
    String? businessCategoryId,
    String? variantId,
    int? quantity,
    List<CartAttribute>? attributes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Building form-data body as per your screenshot
      final Map<String, String> body = {};

      // Adding optional update parameters if provided
      if (productId != null) body['product_id'] = productId;
      if (businessCategoryId != null) body['business_category_id'] = businessCategoryId;
      if (variantId != null) body['product_variant_id'] = variantId;
      if (quantity != null) body['quantity'] = quantity.toString();

      if (attributes != null) {
        for (int i = 0; i < attributes.length; i++) {
          body['attributes[$i][attribute_id]'] = attributes[i].attributeId ?? "";
          body['attributes[$i][attribute_value_id]'] = attributes[i].attributeValueId ?? "";
        }
      }

      // Using GET method with form-data body via multipartRequest
      // URL contains user_id as query param, and body contains fields as per Postman
      final response = await _apiService.multipartRequest(
        "${ApiEndPoints.cart}?user_id=$_userId",
        method: 'GET',
        body: body,
        token: _bearerToken,
      );

      if (response['success'] == true) {
        _cartData = CartListModel.fromJson(response);
      } else {
        _errorMessage = response['message'] ?? 'Failed to sync cart';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
