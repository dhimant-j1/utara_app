// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pass_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodPassCategory _$FoodPassCategoryFromJson(Map<String, dynamic> json) =>
    FoodPassCategory(
      id: json['id'] as String,
      buildingName: json['building_name'] as String,
      colorCode: json['color_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FoodPassCategoryToJson(FoodPassCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'building_name': instance.buildingName,
      'color_code': instance.colorCode,
      'created_at': instance.createdAt.toIso8601String(),
    };
