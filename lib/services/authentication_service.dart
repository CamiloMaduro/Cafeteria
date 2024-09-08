import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/token.dart';
import '../models/apiResponse.dart';

class AuthenticationService {
  final String baseUrl;

  AuthenticationService(this.baseUrl);

  Future<ApiResponse<Token>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse<Token>.fromJson(
          data,
          (json) => Token.fromJson(json), // Aquí se espera un JSON que contiene el token
        );
      } else {
        return ApiResponse<Token>(
          success: false,
          message: 'Login failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse<Token>(
        success: false,
        message: 'An error occurred: $e',
      );
    }
  }
}
