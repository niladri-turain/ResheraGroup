import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/service/api_service.dart';
import '../model/cancel_reason_model.dart';

class CancelReasonProvider with ChangeNotifier {
  final ApiService apiService;
  CancelReasonProvider({required this.apiService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CancelReason> _reasons = [];
  List<CancelReason> get reasons => _reasons;

  Future<void> fetchCancelReasons() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.get(
        ApiEndPoints.cancelReason,

      );

      final model = CancelReasonModel.fromJson(response);
      if (model.success == true) {
        _reasons = model.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching cancel reasons: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
