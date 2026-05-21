import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../model/order_model.dart';

class OrderProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();
  final SharedPrefService _prefService = sl<SharedPrefService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OrderModel? _orderData;
  OrderModel? get orderData => _orderData;

  // For placing a new order
  Future<bool> placeOrder() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _prefService.getToken();
      final userId = await _prefService.getUserId();

      final response = await _apiService.post(
        ApiEndPoints.createOrder,
        body: {
          'user_id': userId,
        },
        token: token,
      );

      final result = OrderModel.fromJson(response);
      
      if (result.success == true) {
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = result.message ?? 'Failed to place order';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // For fetching order history/list
  Future<void> fetchOrders({bool showLoader = true}) async {
    if (showLoader) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final token = await _prefService.getToken();
      final userId = await _prefService.getUserId();

      // Using GET for fetching orders as requested: {{base_url}}/orders?user_id=...
      final response = await _apiService.get(
        "${ApiEndPoints.createOrder}?user_id=${userId ?? ''}",
        token: token,
      );

      _orderData = OrderModel.fromJson(response);
      
      if (_orderData?.success != true) {
        _errorMessage = _orderData?.message ?? 'Failed to fetch orders';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
