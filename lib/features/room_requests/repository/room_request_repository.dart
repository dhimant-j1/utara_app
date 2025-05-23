import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomRequestRepository {
  static const baseUrl = 'http://localhost:8080'; // From swagger.yaml

  Future<Map<String, dynamic>> createRoomRequest({
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfPeople,
    required String preferredType,
    String? specialRequests,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/room-requests'),
      headers: {
        'Content-Type': 'application/json',
        // Add auth token header when auth is implemented
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
