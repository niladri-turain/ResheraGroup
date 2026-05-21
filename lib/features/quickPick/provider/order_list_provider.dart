import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../model/order_list_model.dart';

class OrderListProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();
  final SharedPrefService _prefService = sl<SharedPrefService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OrderListModel? _orderListData;
  OrderListModel? get orderListData => _orderListData;

  Future<void> fetchOrders({bool showLoader = true}) async {
    if (showLoader) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final token = await _prefService.getToken();
      final userId = await _prefService.getUserId();

      // {{base_url}}/orders?user_id=userid
      final response = await _apiService.get(
        "${ApiEndPoints.createOrder}?user_id=${userId ?? ''}",
        // token: token,
      );

      _orderListData = OrderListModel.fromJson(response);
      
      if (_orderListData?.success != true) {
        _errorMessage = "Failed to fetch orders";
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
