import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../model/cart_list_model.dart';
import '../model/product_details_model.dart';

class ViewCartListProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();
  
  static const String _cartCountKey = "cart_total_items";

  CartListModel? _cartData;
  CartListModel? get cartData => _cartData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _totalItems = 0;
  int get totalItems => _totalItems;

  Map<String, dynamic> _localCart = {};
  Map<String, dynamic> get localCart => _localCart;

  ViewCartListProvider() {
    _loadCartCount();
    _loadLocalCart();
  }

  Future<void> _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    _totalItems = prefs.getInt(_cartCountKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveCartCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cartCountKey, count);
    _totalItems = count;
    notifyListeners();
  }

  Future<void> _loadLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? localCartJson = prefs.getString("local_cart_items");
    if (localCartJson != null) {
      try {
        _localCart = json.decode(localCartJson);
      } catch (e) {
        _localCart = {};
      }
    }
    notifyListeners();
  }

  Future<void> _saveLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("local_cart_items", json.encode(_localCart));
  }

  void updateLocalCartItem({
    required String productId,
    required String businessCategoryId,
    required String variantId,
    required int quantity,
    required List<Attribute> attributes,
  }) {
    if (quantity <= 0) {
      _localCart.remove(productId);
    } else {
      _localCart[productId] = {
        'productId': productId,
        'businessCategoryId': businessCategoryId,
        'variantId': variantId,
        'quantity': quantity,
        'attributes': attributes.map((a) => {
          'attribute_id': a.attributeId,
          'attribute_name': a.attributeName,
          'value_id': a.valueId,
          'value': a.value,
        }).toList(),
      };
    }
    _saveLocalCart();
    notifyListeners();
  }

  int getLocalQuantity(String productId) {
    // Check local cart first for immediate updates
    if (_localCart.containsKey(productId)) {
      return _localCart[productId]?['quantity'] ?? 0;
    }
    
    // Check server cart data if not in local cart
    if (_cartData?.data != null) {
      for (var item in _cartData!.data!) {
        final key = item.productVariantId != null 
            ? "${item.productId}_${item.productVariantId}" 
            : item.productId ?? "";
        if (key == productId) {
          return item.quantity ?? 0;
        }
      }
    }
    return 0;
  }

  void clearLocalCart() {
    _localCart.clear();
    _saveLocalCart();
    notifyListeners();
  }

  int get totalUniqueItems {
    Set<String> uniqueIds = {};
    if (_cartData?.data != null) {
      for (var item in _cartData!.data!) {
        // Unique key for variant
        final key = item.productVariantId != null 
            ? "${item.productId}_${item.productVariantId}" 
            : item.productId ?? "";
        if (key.isNotEmpty) uniqueIds.add(key);
      }
    }
    uniqueIds.addAll(_localCart.keys);
    return uniqueIds.length;
  }

  Future<void> clearCartLocal() async {
    _cartData = null;
    _totalItems = 0;
    _localCart = {};
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartCountKey);
    await prefs.remove("local_cart_items");
  }

  /// Fetches or Updates the cart.
  /// [showLoader] determines if the global isLoading state should be set.
  Future<void> fetchCart({
    String? productId,
    String? businessCategoryId,
    String? variantId,
    int? quantity,
    List<CartAttribute>? attributes,
    bool showLoader = true,
  }) async {
    if (showLoader) {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _prefService.getToken();
      final userId = await _prefService.getUserId();

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
        "${ApiEndPoints.cart}?user_id=${userId?.toString() ?? ''}",
        method: 'GET',
        body: body,
        // token: token,
      );

      if (response['success'] == true ) {
        _cartData = CartListModel.fromJson(response);
        if (_cartData?.totalItems != null) {
          await _saveCartCount(_cartData!.totalItems!);
        }
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
