import 'package:dio/dio.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  void setAuthToken(String? token) {
    _apiService.setAuthToken(token);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String gaam,
    required String name,
    required String phoneNumber,
    String? role,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'name': name,
        'gaam': gaam,
        'phone_number': phoneNumber,
      };

      if (role != null) {
        data['role'] = role;
      }

      final response = await _apiService.dio.post('/auth/signup', data: data);
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<Map<String, dynamic>> verifySignupOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/verify-signup-otp',
        data: {'phone_number': phoneNumber, 'otp': otp},
      );
      return response.data;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User> getProfile() async {
    AuthStore authStore = getIt<AuthStore>();
    try {
      final response = await _apiService.dio.get(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      switch (statusCode) {
        case 400:
          return data['error'] ?? 'Invalid request';
        case 401:
          return 'Invalid email or password';
        case 403:
          return 'You do not have permission to perform this action';
        case 404:
          return 'Service not found';
        case 500:
          return 'Server error. Please try again later';
        default:
          return data?['error'] ?? 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}
