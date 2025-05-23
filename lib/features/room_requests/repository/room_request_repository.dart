import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';

class RoomRequestRepository {
  static const baseUrl = 'http://localhost:8080'; // From swagger.yaml

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
}
