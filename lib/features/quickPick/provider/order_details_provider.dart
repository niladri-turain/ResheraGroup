import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/di/injection_container.dart';
import '../model/order_details_model.dart';

class OrderDetailsProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OrderDetailsModel? _orderDetailsData;
  OrderDetailsModel? get orderDetailsData => _orderDetailsData;

  Future<void> fetchOrderDetails(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    _orderDetailsData = null;
    notifyListeners();

    try {
      // {{base_url}}/orders/orderId
      final response = await _apiService.get(
        "${ApiEndPoints.createOrder}/$orderId",
      );

      _orderDetailsData = OrderDetailsModel.fromJson(response);
      
      if (_orderDetailsData?.success != true) {
        _errorMessage = "Failed to fetch order details";
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
