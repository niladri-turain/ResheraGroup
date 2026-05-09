import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  
  ApiService({required this.baseUrl});

  // Common headers
  Map<String, String> _getHeaders([String? token]) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET Request
  Future<dynamic> get(String endpoint, {String? token,dynamic body,}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, {dynamic body, String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, {dynamic body, String? token}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
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
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest(method, uri);
      
      // Adding headers
      request.headers.addAll(_getHeaders(token));
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
      throw Exception('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  // Response handling logic
  dynamic _processResponse(http.Response response) {
    final responseBody = response.body;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        throw Exception('Invalid JSON response');
      }
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
}
