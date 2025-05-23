// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodPass _$FoodPassFromJson(Map<String, dynamic> json) => FoodPass(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      memberName: json['member_name'] as String,
      mealType: $enumDecode(_$MealTypeEnumMap, json['meal_type']),
      date: DateTime.parse(json['date'] as String),
      qrCode: json['qr_code'] as String,
      isUsed: json['is_used'] as bool,
      usedAt: json['used_at'] == null
          ? null
          : DateTime.parse(json['used_at'] as String),
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FoodPassToJson(FoodPass instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'member_name': instance.memberName,
      'meal_type': _$MealTypeEnumMap[instance.mealType]!,
      'date': instance.date.toIso8601String(),
      'qr_code': instance.qrCode,
      'is_used': instance.isUsed,
      'used_at': instance.usedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'BREAKFAST',
  MealType.lunch: 'LUNCH',
  MealType.dinner: 'DINNER',
};
