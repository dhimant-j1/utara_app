import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/utils/const.dart';
import 'package:utara_app/core/models/food_pass.dart';

class FoodPassRepository {
  final String baseUrl = Const.baseUrl;

  Future<Map<String, dynamic>> generateFoodPasses({
    required String userId,
    required List<String> memberNames,
    required DateTime startDate,
    required DateTime endDate,
    required String diningHall,
    required String colorCode,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final response = await http.post(
      Uri.parse('$baseUrl/food-passes/generate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}'
      },
      body: jsonEncode({
        'user_id': userId,
        'member_names': memberNames,
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
        'dining_hall': diningHall,
        'color_code': colorCode,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to generate food passes: ${response.body}');
    }
  }

  Future<List<FoodPass>> getUserFoodPasses({
    String? userId,
    DateTime? date,
    bool? isUsed,
  }) async {
    AuthStore authStore = getIt<AuthStore>();
    final queryParams = <String, String>{};

    if (date != null) {
      queryParams['date'] = date.toUtc().toIso8601String().split('T')[0];
    }
    if (isUsed != null) {
      queryParams['is_used'] = isUsed.toString();
    }

    final uri = Uri.parse('$baseUrl/food-passes/user/$userId').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${authStore.token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) ?? [];
      return data.map((json) => FoodPass.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food passes: ${response.body}');
    }
  }
}
