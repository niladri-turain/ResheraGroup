import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../model/order_model.dart';
import '../../login/model/user_address_model.dart';

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
  Future<bool> placeOrder({
    required double itemsTotal,
    required double grandTotal,
    required double discountAmount,
    required String paymentMethod,
    required BillingAddress? billing,
    required ShippingAddress? shipping,
  }) async {
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
          'billing_address': billing?.address ?? '',
          'billing_city_id': billing?.city?.id ?? '',
          'billing_state_id': billing?.state?.id ?? '',
          'billing_pincode': billing?.pincode ?? '',
          'shipping_address_id': shipping?.id ?? '',
          'shipping_address': shipping?.address ?? '',
          'shipping_city_id': shipping?.city?.id ?? '',
          'shipping_state_id': shipping?.state?.id ?? '',
          'shipping_pincode': shipping?.pincode ?? '',
          'platformCharge': 0,
          'deliveryCharge': 0,
          'taxAmount': 0,
          'discountAmount': discountAmount,
          'itemsTotal': itemsTotal,
          'grandTotal': grandTotal,
          'payment_method': paymentMethod.toUpperCase(),
          'loyalty_points': 0,
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
