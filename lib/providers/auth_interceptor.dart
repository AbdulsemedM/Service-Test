// auth_interceptor.dart
import 'package:service_booking/configuration/auth_service.dart';

class AuthInterceptor {
  String? token;

  AuthInterceptor({this.token});

  Future<void> fetchToken() async {
    try {
      final authService = AuthService();
      token = await authService.getToken();
      print('Token fetched: $token');
    } catch (e) {
      print('Failed to fetch token: $e');
    }
  }

  Future<Map<String, String>> getHeaders() async {
    if (token == null) {
      await fetchToken();
    }
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
