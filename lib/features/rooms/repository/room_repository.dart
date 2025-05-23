import 'package:dio/dio.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import '../../../core/services/api_service.dart';

class RoomRepository {
  final ApiService _apiService;

  RoomRepository(this._apiService);

  Future<Map<String, dynamic>> createRoom({
    required String roomNumber,
    required int floor,
    required String type,
    required List<Map<String, dynamic>> beds,
    required bool hasGeyser,
    required bool hasAc,
    required bool hasSofaSet,
    int? sofaSetQuantity,
    String? extraAmenities,
    required bool isVisible,
    List<Map<String, dynamic>>? images,
  }) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.post(
        '/rooms/',
        data: {
          'room_number': roomNumber,
          'floor': floor,
          'type': type,
          'beds': beds,
          'has_geyser': hasGeyser,
          'has_ac': hasAc,
          'has_sofa_set': hasSofaSet,
          if (sofaSetQuantity != null) 'sofa_set_quantity': sofaSetQuantity,
          if (extraAmenities != null) 'extra_amenities': extraAmenities,
          'is_visible': isVisible,
          if (images != null) 'images': images,
        },
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${authStore.token}', // Replace with actual token
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 400:
          throw data['error'] ?? 'Invalid request';
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to create rooms';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to create room';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getRooms() async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/rooms/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to view rooms';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to fetch rooms';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }
}
