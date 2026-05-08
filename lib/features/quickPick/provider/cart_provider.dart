import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/product_details_model.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  
  // Constant token for authorization
  static const String _bearerToken = "3|z7TObCtolxbRKsFaV6Kvx3kP9CzX64Fvcxews6yo893fa3bd";
  
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> addToCart({
    required String productId,
    required String businessCategoryId,
    required String variantId,
    required int quantity,
    required List<Attribute> attributes,
  }) async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        'user_id': 'Wpmbk5ezJn',
        'product_id': productId,
        'business_category_id': businessCategoryId,
        'product_variant_id': variantId,
        'quantity': quantity,
        'attributes': attributes.map((a) => {
          'attribute_id': a.attributeId ?? "",
          'attribute_value_id': a.valueId ?? "",
        }).toList(),
      };

      // Passing the bearer token in the post request
      final response = await _apiService.post(
        ApiEndPoints.cart, 
        body: body, 
        token: _bearerToken
      );

      // Checking success key as per your latest response
      if (response['success'] == true) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to add to cart';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
