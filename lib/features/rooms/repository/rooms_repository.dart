import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/utils/const.dart';
import 'package:utara_app/core/models/room.dart';

class RoomsRepository {
  final String baseUrl = Const.baseUrl;

  Future<List<Room>> fetchAvailableRooms({String? type}) async {
    AuthStore authStore = getIt<AuthStore>();
    final uri = Uri.parse('$baseUrl/rooms/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch available rooms: ${response.body}');
    }
  }
}
