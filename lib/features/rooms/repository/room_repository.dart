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
    required String building,
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
          'building': building,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}', // Replace with actual token
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

  Future<List<Map<String, dynamic>>> getRooms({
    int? floor,
    String? type,
    String? building,
    bool? isVisible,
    bool? isOccupied,
  }) async {
    try {
      AuthStore authStore = getIt<AuthStore>();

      // Build query parameters
      Map<String, dynamic> queryParams = {};
      if (floor != null) queryParams['floor'] = floor;
      if (type != null) queryParams['type'] = type;
      if (building != null) queryParams['building'] = building;
      if (isVisible != null) queryParams['is_visible'] = isVisible;
      if (isOccupied != null) queryParams['is_occupied'] = isOccupied;

      final response = await _apiService.dio.get(
        '/rooms/',
        queryParameters: queryParams,
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

  Future<Map<String, dynamic>> getRoomById(String roomId) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/rooms/$roomId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to view this room';
        case 404:
          throw 'Room not found';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to fetch room details';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<Map<String, dynamic>> updateRoom({
    required String roomId,
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
      final response = await _apiService.dio.put(
        '/rooms/$roomId',
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
            'Authorization': 'Bearer ${authStore.token}',
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
          throw 'You do not have permission to update rooms';
        case 404:
          throw 'Room not found';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to update room';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<Map<String, dynamic>> deleteRoom(String roomId) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.delete(
        '/rooms/$roomId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to delete rooms';
        case 404:
          throw 'Room not found';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to delete room';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<Map<String, dynamic>> getRoomStats() async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/rooms/stats',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to view room statistics';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to fetch room statistics';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Upload CSV file for bulk room creation
  Future<Map<String, dynamic>> uploadRoomsCSV(String filePath) async {
    try {
      AuthStore authStore = getIt<AuthStore>();

      // Create FormData with the CSV file
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _apiService.dio.post(
        '/rooms/upload-rooms', // Adjust this endpoint according to your backend
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 400:
          throw data['error'] ?? 'Invalid CSV file or format';
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to upload rooms';
        case 413:
          throw 'File too large';
        case 422:
          throw data['error'] ?? 'CSV validation failed';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to upload CSV file';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Simplified createRoom method for CSV bulk upload (kept for compatibility)
  Future<Map<String, dynamic>> createRoomFromData(Map<String, dynamic> roomData) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.post(
        '/rooms/',
        data: roomData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 400:
          throw data['error'] ?? 'Invalid room data';
        case 401:
          throw 'Unauthorized access';
        case 403:
          throw 'You do not have permission to create rooms';
        case 409:
          throw 'Room with this number already exists';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to create room';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get all buildings
  Future<Map<String, dynamic>> getBuildings() async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/rooms/buildings',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 401:
          throw 'Unauthorized access';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to fetch buildings';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get floors for a specific building
  Future<Map<String, dynamic>> getFloors(String building) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.get(
        '/rooms/floors',
        queryParameters: {'building': building},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authStore.token}',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      switch (statusCode) {
        case 400:
          throw 'Building parameter is required';
        case 401:
          throw 'Unauthorized access';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw data?['error'] ?? 'Failed to fetch floors';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }
}
