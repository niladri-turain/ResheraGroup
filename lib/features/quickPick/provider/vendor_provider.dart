import 'package:flutter/cupertino.dart';
import 'package:resheragroup/features/quickPick/model/vendor_list_model.dart';

import '../../../core/constants/api_end_points.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/api_service.dart';

class VendorProvider with ChangeNotifier{
  final ApiService _apiService = sl<ApiService>();

   List<Vendor> _vendorCategory = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vendor> get vendorCategory => _vendorCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVendorCategory(String categoryId,String subCategoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiEndPoints.vendors}?business_category_id=$categoryId&business_sub_category_id=$subCategoryId',
      );
      final vendorResponse = VendorListResponse.fromJson(response);
      _vendorCategory = vendorResponse.data;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}