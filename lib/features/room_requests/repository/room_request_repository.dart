import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/utils/const.dart';

import 'package:utara_app/core/models/room_request.dart';

import '../../../core/services/api_service.dart';

class RoomRequestRepository {
  final ApiService _apiService;

  RoomRequestRepository(this._apiService);

  Future<RoomRequest> processRoomRequest({
    required String requestId,
    required String status, // 'APPROVED' or 'REJECTED'
    String? roomId,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final response = await http.put(
      Uri.parse('$baseUrl/room-requests/$requestId/process'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
      body: jsonEncode({
        'status': status,
        if (roomId != null) 'room_id': roomId,
      }),
    );
    log(response.toString());
    if (response.statusCode == 200) {
      return RoomRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to process room request: ${response.body}');
    }
  }

  final String baseUrl = Const.baseUrl; // From swagger.yaml

  Future<Map<String, dynamic>> createRoomRequest({
    required String place,
    required String purpose,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required Map<String, int> numberOfPeople,
    required String formName,
    String? specialRequests,
    String? reference,
    String? chitthiImagePath,
  }) async {
    AuthStore authStore = getIt<AuthStore>();

    final uri = Uri.parse('$baseUrl/room-requests/');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${authStore.token}';

    // Add form fields
    request.fields['form_name'] = formName;
    request.fields['place'] = place;
    request.fields['purpose'] = purpose;
    request.fields['check_in_date'] = checkInDate.toUtc().toIso8601String();
    request.fields['check_out_date'] = checkOutDate.toUtc().toIso8601String();
    request.fields['number_of_people'] = jsonEncode(numberOfPeople);
    if (specialRequests != null) {
      request.fields['special_requests'] = specialRequests;
    }
    if (reference != null) {
      request.fields['reference'] = reference;
    }

    // Add chitthi image if provided
    if (chitthiImagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('chitthi', chitthiImagePath),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    log(response.body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create room request: ${response.body}');
    }
  }

  Future<List<RoomRequest>> fetchRoomRequests({
    String? status,
    String? userId,
    bool? checkoutToday,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final uri = Uri.parse('$baseUrl/room-requests/').replace(
      queryParameters: {
        if (status != null) 'status': status,
        if (userId != null) 'user_id': userId,
        if (checkoutToday == true) 'checkout_today': 'true',
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
    );
    log(response.body.toString());
    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body);
      return data
              ?.map((e) => RoomRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } else {
      throw Exception('Failed to fetch room requests: ${response.body}');
    }
  }

  Future<RoomRequest> adminUpdateRoomRequest({
    required String requestId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    Map<String, int>? numberOfPeople,
    String? place,
    String? purpose,
    String? reference,
    String? specialRequests,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final body = <String, dynamic>{};

    if (checkInDate != null) {
      body['check_in_date'] = checkInDate.toUtc().toIso8601String();
    }
    if (checkOutDate != null) {
      body['check_out_date'] = checkOutDate.toUtc().toIso8601String();
    }
    if (numberOfPeople != null) {
      body['number_of_people'] = numberOfPeople;
    }
    if (place != null) body['place'] = place;
    if (purpose != null) body['purpose'] = purpose;
    if (reference != null) body['reference'] = reference;
    if (specialRequests != null) body['special_requests'] = specialRequests;

    final response = await http.put(
      Uri.parse('$baseUrl/room-requests/$requestId/admin-update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return RoomRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update room request: ${response.body}');
    }
  }

  Future<bool> checkInCheckOut({
    required String id,
    required bool isCheckedIn,
  }) async {
    try {
      AuthStore authStore = getIt<AuthStore>();
      final response = await _apiService.dio.put(
        isCheckedIn
            ? '/room-assignments/$id/check-out'
            : '/room-assignments/$id/check-in',
        options: Options(
          headers: {'Authorization': 'Bearer ${authStore.token}'},
        ),
      );
      final data = response.data as Map<String, dynamic>;
      return data['id'] != null;
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
}
