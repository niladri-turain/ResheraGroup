import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../model/promotional_vendor_banner_model.dart';

class PromotionalVendorBannerProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PromotionalVendorBannerModel? _bannerModel;
  PromotionalVendorBannerModel? get bannerModel => _bannerModel;

  Future<void> fetchPromotionalBanners() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String endpoint = "${ApiEndPoints.vendorBanner}?business_id=VolejRejNm&banner_type=promotional_banner";
      
      final response = await _apiService.get(
        endpoint,
        token: AppStrings.token,
      );

      _bannerModel = PromotionalVendorBannerModel.fromJson(response);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
