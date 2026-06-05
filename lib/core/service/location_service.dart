import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _addressKey = 'cached_address';

  /// Returns the current address as a String and saves it to SharedPreferences
  static Future<String> getCurrentAddress() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Location services are disabled.";
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Location permission denied.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return "Location permission permanently denied.";
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      // Format the address
      String address = [
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
      ].where((element) => element != null && element.isNotEmpty)
          .join(', ');

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_addressKey, address);

      return address;
    } catch (e) {
      return "Unable to fetch address.";
    }
  }

  /// Retrieves the cached address from SharedPreferences
  static Future<String?> getCachedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_addressKey);
  }
}
