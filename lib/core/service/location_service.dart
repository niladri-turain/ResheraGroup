import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Returns the current address as a String
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
      return [
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country
      ].where((element) => element != null && element.isNotEmpty)
          .join(', ');
    } catch (e) {
      return "Unable to fetch address.";
    }
  }
}