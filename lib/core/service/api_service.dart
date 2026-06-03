import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/login/provider/login_provider.dart';
import '../../features/login/screen/login_screen.dart';
import '../di/injection_container.dart';
import '../utils/navigation_service.dart';
import '../constants/app_strings.dart';
import '../constants/api_end_points.dart';

class ApiService {
  final String baseUrl;
  
  ApiService({required this.baseUrl});

  // Common headers
  Map<String, String> _getHeaders({String? token, String? xApiToken}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-TOKEN': xApiToken ?? AppStrings.xApiTokenForAll,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper to get full URI
  Uri _getUri(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return Uri.parse(endpoint);
    }
    return Uri.parse('$baseUrl$endpoint');
  }

  // GET Request
  Future<dynamic> get(String endpoint, {String? token, String? xApiToken, dynamic body}) async {
    try {
      final url = _getUri(endpoint);
      final headers = _getHeaders(token: token, xApiToken: xApiToken);
      
      print('--- API GET Request ---');
      print('URL: $url');
      print('Headers: $headers');

      final response = await http.get(
        url,
        headers: headers,
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, {dynamic body, String? token, String? xApiToken}) async {
    try {
      final url = _getUri(endpoint);
      final headers = _getHeaders(token: token, xApiToken: xApiToken);
      
      print('--- API POST Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, {dynamic body, String? token, String? xApiToken}) async {
    try {
      final response = await http.put(
        _getUri(endpoint),
        headers: _getHeaders(token: token, xApiToken: xApiToken),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {String? token, String? xApiToken}) async {
    try {
      final response = await http.delete(
        _getUri(endpoint),
        headers: _getHeaders(token: token, xApiToken: xApiToken),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  // Multipart Request (Supports GET/POST with form-data)
  Future<dynamic> multipartRequest(String endpoint, {
    required String method,
    Map<String, String>? body,
    Map<String, String>? headers,
    String? token,
    String? xApiToken,
  }) async {
    try {
      final uri = _getUri(endpoint);
      final request = http.MultipartRequest(method, uri);
      
      // Adding headers
      request.headers.addAll(_getHeaders(token: token, xApiToken: xApiToken));
      if (headers != null) {
        request.headers.addAll(headers);
      }
      
      // Adding form-data fields
      if (body != null) {
        request.fields.addAll(body);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } on SocketException {
      throw Exception('Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  // Response handling logic
  dynamic _processResponse(http.Response response) {
    final responseBody = response.body;
    
    print('--- API Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');
    print('--------------------');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        throw Exception('Invalid JSON response');
      }
    } else if (response.statusCode == 401) {
      // Handle Unauthorized error only for address endpoint
      if (response.request?.url.toString().contains(ApiEndPoints.address) ?? false) {
        _handleUnauthorized();
      }
      throw Exception('Session expired. Please login again.');
    } else {
      String errorMessage = 'Something went wrong';
      try {
        final Map<String, dynamic> errorData = jsonDecode(responseBody);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (_) {
        errorMessage = 'Error ${response.statusCode}: $responseBody';
      }
      throw Exception(errorMessage);
    }
  }

  void _handleUnauthorized() {
    // Clear user data and navigate to login screen
    sl<LoginProvider>().logout();
    NavigationService.navigateToAndRemoveUntil(const LoginScreen());
  }
}
