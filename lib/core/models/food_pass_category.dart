import 'package:json_annotation/json_annotation.dart';

part 'food_pass_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FoodPassCategory {
  final String id;
  final String buildingName;
  final String colorCode;
  final DateTime createdAt;

  const FoodPassCategory({
    required this.id,
    required this.buildingName,
    required this.colorCode,
    required this.createdAt,
  });

  factory FoodPassCategory.fromJson(Map<String, dynamic> json) =>
      _$FoodPassCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$FoodPassCategoryToJson(this);

  FoodPassCategory copyWith({
    String? id,
    String? buildingName,
    String? colorCode,
    DateTime? createdAt,
  }) {
    return FoodPassCategory(
      id: id ?? this.id,
      buildingName: buildingName ?? this.buildingName,
      colorCode: colorCode ?? this.colorCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodPassCategory &&
        other.id == id &&
        other.buildingName == buildingName &&
        other.colorCode == colorCode &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      buildingName,
      colorCode,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'FoodPassCategory(id: $id, buildingName: $buildingName, colorCode: $colorCode, createdAt: $createdAt)';
  }
}