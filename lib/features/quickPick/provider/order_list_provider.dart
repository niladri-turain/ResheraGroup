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

  bool _isMoreLoading = false;
  bool get isMoreLoading => _isMoreLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OrderListModel? _orderListData;
  OrderListModel? get orderListData => _orderListData;

  List<OrderData> _orders = [];
  List<OrderData> get orders => _orders;

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchOrders({bool isRefresh = true}) async {
    if (isRefresh) {
      _isLoading = true;
      _currentPage = 1;
      _orders = [];
      _hasMore = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      if (!_hasMore || _isMoreLoading) return;
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final userId = await _prefService.getUserId();

      // {{base_url}}/orders?user_id=userid&page=page
      final response = await _apiService.get(
        "${ApiEndPoints.createOrder}?user_id=${userId ?? ''}&page=$_currentPage",
      );

      final newData = OrderListModel.fromJson(response is Map<String, dynamic> ? response : {});
      
      // Check if we have data either in 'data' field or if the response is a list
      List<OrderData> fetchedOrders = [];
      if (response is List) {
        fetchedOrders = response.map((e) => OrderData.fromJson(e)).toList();
      } else if (response is Map && response['data'] != null) {
        fetchedOrders = (response['data'] as List).map((e) => OrderData.fromJson(e)).toList();
      }

      if (fetchedOrders.isNotEmpty || (response is Map && response['success'] == true)) {
        _errorMessage = null;
        if (fetchedOrders.isNotEmpty) {
          _orders.addAll(fetchedOrders);
          _currentPage++;
          if (fetchedOrders.length < 10) {
            _hasMore = false;
          }
        } else {
          _hasMore = false;
        }
        _orderListData = newData;
      } else {
        _errorMessage = "Failed to fetch orders";
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }
}
