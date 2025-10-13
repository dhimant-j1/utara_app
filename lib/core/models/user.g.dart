// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  username: json['user_name'] as String? ?? '',
  email: json['email'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isImportant: json['is_important'] as bool,
  phoneNumber: json['phone_number'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  userType: json['user_type'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.username,
  'email': instance.email,
  'name': instance.name,
  'role': _$UserRoleEnumMap[instance.role]!,
  'is_important': instance.isImportant,
  'phone_number': instance.phoneNumber,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'user_type': instance.userType,
};

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'SUPER_ADMIN',
  UserRole.staff: 'STAFF',
  UserRole.user: 'USER',
};
