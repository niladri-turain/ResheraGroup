import 'package:flutter/material.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/location_service.dart';
import '../model/user_address_model.dart';

class UserAddressProvider with ChangeNotifier {
  final ApiService _apiService = sl<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserAddressModel? _addressModel;
  UserAddressModel? get addressModel => _addressModel;

  ShippingAddress? _selectedAddress;
  ShippingAddress? get selectedAddress => _selectedAddress;

  String? _guestLocation;
  String? get guestLocation => _guestLocation;

  void setSelectedAddress(ShippingAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> fetchGuestLocation() async {
    _guestLocation = await LocationService.getCachedAddress();
    _guestLocation ??= await LocationService.getCurrentAddress();
    notifyListeners();
  }

  Future<void> fetchUserAddresses(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        "${ApiEndPoints.mainPanelUrl}${ApiEndPoints.address}",
        token: token,
        xApiToken: AppStrings.xApiTokenForLogin,
      );

      _addressModel = UserAddressModel.fromJson(response);

      if (_addressModel?.status != true) {
        _errorMessage = _addressModel?.message ?? 'Failed to fetch addresses';
      } else {
        // Set first shipping address as default if none selected
        if (_selectedAddress == null && _addressModel?.data?.shipping?.isNotEmpty == true) {
          _selectedAddress = _addressModel?.data?.shipping?.first;
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAddresses() {
    _addressModel = null;
    _selectedAddress = null;
    notifyListeners();
  }
}
