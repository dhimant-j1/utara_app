import 'package:json_annotation/json_annotation.dart';

part 'food_pass.g.dart';

enum MealType {
  @JsonValue('BREAKFAST')
  breakfast,
  @JsonValue('LUNCH')
  lunch,
  @JsonValue('DINNER')
  dinner,
}

@JsonSerializable()
class FoodPass {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'member_name')
  final String memberName;
  @JsonKey(name: 'meal_type')
  final MealType mealType;
  final DateTime date;
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @JsonKey(name: 'dining_hall')
  final String? diningHall;
  @JsonKey(name: 'color_code')
  final String? colorCode;
  @JsonKey(name: 'is_used')
  final bool isUsed;
  @JsonKey(name: 'used_at')
  final DateTime? usedAt;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const FoodPass({
    required this.id,
    required this.userId,
    required this.memberName,
    required this.mealType,
    required this.date,
    required this.qrCode,
    required this.diningHall,
    required this.colorCode,
    required this.isUsed,
    this.usedAt,
    required this.createdBy,
    required this.createdAt,
  });

  factory FoodPass.fromJson(Map<String, dynamic> json) => _$FoodPassFromJson(json);
  Map<String, dynamic> toJson() => _$FoodPassToJson(this);

  FoodPass copyWith({
    String? id,
    String? userId,
    String? memberName,
    MealType? mealType,
    DateTime? date,
    String? qrCode,
    String? diningHall,
    String? colorCode,
    bool? isUsed,
    DateTime? usedAt,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return FoodPass(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      memberName: memberName ?? this.memberName,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
      qrCode: qrCode ?? this.qrCode,
      diningHall: diningHall ?? this.diningHall,
      colorCode: colorCode ?? this.colorCode,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt ?? this.usedAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get mealTypeName {
    return switch (mealType) {
      MealType.breakfast => 'Breakfast',
      MealType.lunch => 'Lunch',
      MealType.dinner => 'Dinner',
    };
  }

  bool get canBeUsed => !isUsed && date.isAfter(DateTime.now().subtract(const Duration(days: 1)));
}
