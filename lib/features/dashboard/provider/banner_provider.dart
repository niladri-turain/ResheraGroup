import 'package:flutter/material.dart';
import 'package:resheragroup/core/constants/api_end_points.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/di/injection_container.dart';
import 'package:resheragroup/core/service/api_service.dart';
import '../model/banner_model.dart';

class BannerProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BannerResponseModel? _bannerResponse;
  Map<String, List<BannerItem>>? get banners => _bannerResponse?.data;

  Future<void> fetchBanners() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        "${ApiEndPoints.mainPanelUrl}${ApiEndPoints.banner}",
        xApiToken: AppStrings.xApiTokenForLogin,
      );

      _bannerResponse = BannerResponseModel.fromJson(response);

      if (_bannerResponse?.status != true) {
        _errorMessage = _bannerResponse?.message ?? "Failed to fetch banners";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> getBannerImagesBySection(String section) {
    if (banners == null || !banners!.containsKey(section)) {
      return [];
    }
    return banners![section]!.map((item) => item.image ?? "").where((img) => img.isNotEmpty).toList();
  }
}
