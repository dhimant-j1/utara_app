import 'package:dio/dio.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import '../../../core/services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    try {
      final data = {
        'email': email,
        'password': password,
        'name': name,
        'phone_number': phoneNumber,
        'role': role,
      };

      final response = await _apiService.dio.post(
        '/createUser',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        switch (statusCode) {
          case 400:
            throw data['error'] ?? 'Invalid request';
          case 401:
            throw 'Unauthorized access';
          case 403:
            throw 'You do not have permission to create users';
          case 409:
            throw 'A user with this email already exists';
          case 500:
            throw 'Server error. Please try again later';
          default:
            throw data?['error'] ?? 'Failed to create user';
        }
      }
      throw 'Failed to create user: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/users',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      final data = response.data as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['users'] ?? []);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        switch (statusCode) {
          case 401:
            throw 'Unauthorized access';
          case 403:
            throw 'You do not have permission to view users';
          case 500:
            throw 'Server error. Please try again later';
          default:
            throw data?['error'] ?? 'Failed to fetch users';
        }
      }
      throw 'Failed to fetch users: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> deleteUser({required String userId}) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.delete(
        '/user/delete-user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      final data = response.data as Map<String, dynamic>;

      return data;
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        switch (statusCode) {
          case 401:
            throw 'Unauthorized access';
          case 403:
            throw 'You do not have permission to view users';
          case 500:
            throw 'Server error. Please try again later';
          default:
            throw data?['error'] ?? 'Failed to fetch users';
        }
      }
      throw 'Failed to fetch users: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    required String userId,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    try {
      final data = {
        'email': email,
        'password': password,
        'name': name,
        'phone_number': phoneNumber,
        'role': role,
      };

      final response = await _apiService.dio.put(
        '/user/update-user/$userId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        switch (statusCode) {
          case 400:
            throw data['error'] ?? 'Invalid request';
          case 401:
            throw 'Unauthorized access';
          case 403:
            throw 'You do not have permission to create users';
          case 409:
            throw 'A user with this email already exists';
          case 500:
            throw 'Server error. Please try again later';
          default:
            throw data?['error'] ?? 'Failed to create user';
        }
      }
      throw 'Failed to create user: ${e.toString()}';
    }
  }
}
