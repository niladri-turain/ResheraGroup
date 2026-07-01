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

      // Reset error message as we got a successful response
      _errorMessage = null;

      List<OrderData> fetchedItems = [];
      if (response is List) {
        fetchedItems = response.map((e) => OrderData.fromJson(e)).toList();
      } else if (response is Map) {
        if (response['data'] is List) {
          fetchedItems = (response['data'] as List).map((e) => OrderData.fromJson(e)).toList();
        }
        _orderListData = OrderListModel.fromJson(response as Map<String, dynamic>);
      }

      if (fetchedItems.isNotEmpty) {
        _orders.addAll(fetchedItems);
        _currentPage++;
        if (fetchedItems.length < 10) {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
      
      if (_orderListData == null) {
        _orderListData = OrderListModel(success: true, data: _orders);
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
