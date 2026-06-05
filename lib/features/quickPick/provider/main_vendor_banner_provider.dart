import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../model/main_vendor_banner_model.dart';

class MainVendorBannerProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MainVendorBannerModel? _bannerModel;
  MainVendorBannerModel? get bannerModel => _bannerModel;

  Future<void> fetchMainVendorBanners({String? businessId, bool isSilent = false}) async {
    if (!isSilent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      // Use passed businessId if available, otherwise fallback to AppStrings.businessId
      final effectiveBusinessId = businessId ;
      final String endpoint = "${ApiEndPoints.vendorBanner}?business_id=$effectiveBusinessId&banner_type=${AppStrings.mainBannerType}";
      
      final response = await _apiService.get(
        endpoint,
        // token: AppStrings.token,
      );

      _bannerModel = MainVendorBannerModel.fromJson(response);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
