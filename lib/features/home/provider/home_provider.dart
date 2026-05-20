import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../model/home_model.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService = GetIt.I<ApiService>();
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HomeDashboardModel? _dashboardModel;
  HomeDashboardModel? get dashboardModel => _dashboardModel;

  Future<bool> fetchDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isLoggedIn = await _prefService.isLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = "Not logged in";
        return false;
      }

      final token = await _prefService.getToken();
      
      final response = await _apiService.post(
        "${ApiEndPoints.mainPanelUrl}${ApiEndPoints.dashboardUrl}",
        token: token,
        xApiToken: AppStrings.xApiTokenForLogin,
      );

      _dashboardModel = HomeDashboardModel.fromJson(response);

      if (_dashboardModel?.status == true) {
        if (_dashboardModel?.data?.sessionToken != null) {
          await _prefService.saveDashboardSession(_dashboardModel!.data!.sessionToken!);
        }
        return true;
      } else {
        _errorMessage = _dashboardModel?.message ?? "Failed to load dashboard data";
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
