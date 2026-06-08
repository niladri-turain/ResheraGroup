import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/cancel_order_model.dart';

class CancelOrderProvider with ChangeNotifier {
  final ApiService apiService;
  CancelOrderProvider({required this.apiService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<CancelOrderModel?> cancelOrderItem({

    required String orderItemId,
    required String cancelReasonId,
    String? cancelNote,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Using multipartRequest as the API requires form-data
      final response = await apiService.multipartRequest(
        ApiEndPoints.cancelItem,
        method: 'POST',
        body: {
          'order_item_id': orderItemId,
          'cancel_reason_id': cancelReasonId,
          'cancel_note': cancelNote ?? '',
        },
      );

      final result = CancelOrderModel.fromJson(response);
      return result;
    } catch (e) {
      debugPrint("Error cancelling order item: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
