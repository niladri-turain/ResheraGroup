import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../model/login_model.dart';
import 'user_address_provider.dart';

class LoginProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();
  final SharedPrefService _prefService = sl<SharedPrefService>();
  final UserAddressProvider _addressProvider = sl<UserAddressProvider>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginModel? _loginModel;
  LoginModel? get loginModel => _loginModel;

  String? _userName;
  String? get userName => _userName;

  String? _userEmail;
  String? get userEmail => _userEmail;

  String? _userPhone;
  String? get userPhone => _userPhone;

  LoginProvider() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    _userName = await _prefService.getName();
    _userEmail = await _prefService.getEmail();
    _userPhone = await _prefService.getPhone();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        "${ApiEndPoints.mainPanelUrl}${ApiEndPoints.loginApi}",
        body: {
          'username': username,
          'password': password,
        },
        xApiToken: AppStrings.xApiTokenForLogin,
      );

      _loginModel = LoginModel.fromJson(response);

      if (_loginModel?.status == true && _loginModel?.data != null) {
        final data = _loginModel!.data!;
        final user = data.user!;

        await _prefService.saveUserData(
          token: data.token ?? '',
          userId: user.userId ?? 0,
          username: user.username ?? '',
          name: user.name ?? '',
          email: user.email ?? '',
          phone: user.phone?.toString() ?? '',
        );
        _userName = user.name;
        _userEmail = user.email;
        _userPhone = user.phone?.toString();
        
        // Fetch addresses immediately after successful login
        await _addressProvider.fetchUserAddresses(data.token ?? '');

        notifyListeners();
        return true;
      } else {
        _errorMessage = _loginModel?.message ?? 'Login failed';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _prefService.clear();
    _loginModel = null;
    _userName = null;
    notifyListeners();
  }
}
