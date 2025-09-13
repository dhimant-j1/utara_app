import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/core/stores/auth_store.dart';
import 'package:utara_app/utils/const.dart';
import 'package:utara_app/core/models/food_pass_category.dart';

class FoodPassCategoryRepository {
  final String baseUrl = Const.baseUrl;

  /// Get all food pass categories
  Future<List<FoodPassCategory>> getAllCategories() async {
    final authStore = getIt<AuthStore>();
    final response = await http.get(
      Uri.parse('$baseUrl/food-passes/get-pass-categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> categories = responseData['categories'];
      return categories.map((json) => FoodPassCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch food pass categories: ${response.body}');
    }
  }

  /// Get a specific food pass category by ID
  Future<FoodPassCategory> getCategoryById(String id) async {
    final authStore = getIt<AuthStore>();
    final response = await http.get(
      Uri.parse('$baseUrl/food-passes/get-pass-categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> categories = responseData['categories'];
      final categoryData = categories.firstWhere((cat) => cat['id'] == id);
      return FoodPassCategory.fromJson(categoryData);
    } else {
      throw Exception('Failed to fetch food pass category: ${response.body}');
    }
  }

  /// Create a new food pass category
  Future<FoodPassCategory> createCategory({
    required String buildingName,
    required String colorCode,
  }) async {
    final authStore = getIt<AuthStore>();
    final response = await http.post(
      Uri.parse('$baseUrl/food-passes/food-pass-category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
      body: jsonEncode({
        'building_name': buildingName,
        'color_code': colorCode,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return FoodPassCategory.fromJson(responseData['category']);
    } else {
      throw Exception('Failed to create food pass category: ${response.body}');
    }
  }

  /// Update an existing food pass category
  Future<void> updateCategory({
    required String id,
    String? buildingName,
    String? colorCode,
  }) async {
    final authStore = getIt<AuthStore>();
    final response = await http.put(
      Uri.parse('$baseUrl/food-passes/update-pass-category/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
      body: jsonEncode({
        if (buildingName != null) 'building_name': buildingName,
        if (colorCode != null) 'color_code': colorCode,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update food pass category: ${response.body}');
    }
  }

  /// Delete a food pass category
  Future<void> deleteCategory(String id) async {
    final authStore = getIt<AuthStore>();
    final response = await http.delete(
      Uri.parse('$baseUrl/food-passes/delete-pass-category/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authStore.token}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete food pass category: ${response.body}');
    }
  }
}
