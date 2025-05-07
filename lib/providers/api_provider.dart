// api_provider.dart
import 'dart:convert';
import 'package:service_booking/configuration/api_constants.dart';
import 'package:http/http.dart' as http;
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

class ApiProvider {
  // final String baseUrl;
  final AuthInterceptor authInterceptor;
  final ErrorInterceptor errorInterceptor;
  final LoggingInterceptor loggingInterceptor;

  ApiProvider({
    // required this.baseUrl,
    required this.authInterceptor,
    required this.errorInterceptor,
    required this.loggingInterceptor,
  });
  Future<http.Response> getRequest(String endpoint,
      {Map<String, dynamic>? params}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();
    final queryParams =
        params?.entries.map((e) => '${e.key}=${e.value}').join('&');
    final urlWithParams =
        queryParams != null ? '$url?$queryParams' : url.toString();
    try {
      final response =
          await http.get(Uri.parse(urlWithParams), headers: headers);
      loggingInterceptor.logRequest(url.toString(), 'GET', headers, null);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> postRequest(
      String endpoint, Map<dynamic, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      loggingInterceptor.logRequest(url.toString(), 'POST', headers, body);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> putRequest(
      String endpoint, Map<dynamic, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      loggingInterceptor.logRequest(url.toString(), 'PUT', headers, body);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> deleteRequest(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );
      loggingInterceptor.logRequest(url.toString(), 'DELETE', headers, null);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }
}
