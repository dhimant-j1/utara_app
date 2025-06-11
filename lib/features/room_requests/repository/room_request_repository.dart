import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/utils/const.dart';

import 'package:utara_app/core/models/room_request.dart';

class RoomRequestRepository {
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
        'Authorization': 'Bearer ${authStore.token}'
      },
      body: jsonEncode({
        'status': status,
        if (roomId != null) 'room_id': roomId,
      }),
    );
    if (response.statusCode == 200) {
      return RoomRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to process room request: ${response.body}');
    }
  }

  final String baseUrl = Const.baseUrl; // From swagger.yaml

  Future<Map<String, dynamic>> createRoomRequest({
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfPeople,
    required String preferredType,
    String? specialRequests,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final response = await http.post(
      Uri.parse('$baseUrl/room-requests/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}'
      },
      body: jsonEncode({
        'check_in_date': checkInDate.toUtc().toIso8601String(),
        'check_out_date': checkOutDate.toUtc().toIso8601String(),
        'number_of_people': numberOfPeople,
        'preferred_type': preferredType,
        'special_requests': specialRequests,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create room request: ${response.body}');
    }
  }

  Future<List<RoomRequest>> fetchRoomRequests(
      {String? status, String? userId}) async {
    AuthStore authStore = getIt<AuthStore>();
    final uri = Uri.parse('$baseUrl/room-requests').replace(queryParameters: {
      if (status != null) 'status': status,
      if (userId != null) 'user_id': userId,
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => RoomRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch room requests: ${response.body}');
    }
  }
}
