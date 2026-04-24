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
  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token),
      );
      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('GET Error: $e');
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
      throw Exception('POST Error: $e');
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
      throw Exception('PUT Error: $e');
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
      throw Exception('DELETE Error: $e');
    }
  }

  // Response handling logic
  dynamic _processResponse(http.Response response) {
    final responseBody = response.body;

    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return jsonDecode(responseBody);
        } catch (e) {
          throw Exception('Format Error: Invalid JSON response');
        }
      case 400:
        throw Exception('Bad Request: $responseBody');
      case 401:
      case 403:
        throw Exception('Unauthorized: $responseBody');
      case 404:
        throw Exception('Not Found: $responseBody');
      case 500:
        throw Exception('Internal Server Error: $responseBody');
      default:
        throw Exception('Error occurred with code: ${response.statusCode}');
    }
  }
}
