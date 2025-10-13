import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('SUPER_ADMIN')
  superAdmin,
  @JsonValue('STAFF')
  staff,
  @JsonValue('USER')
  user,
}

@JsonSerializable()
class User {
  final String id;
  @JsonKey(name: 'user_name')
  final String username;
  final String email;
  final String name;
  final UserRole role;
  @JsonKey(name: 'is_important')
  final bool isImportant;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'user_type')
  final String? userType;

  const User({
    required this.id,
    this.username = '',
    required this.email,
    required this.name,
    required this.role,
    required this.isImportant,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? name,
    UserRole? role,
    bool? isImportant,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userType,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isImportant: isImportant ?? this.isImportant,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userType: userType ?? this.userType,
    );
  }

  bool get isAdmin => role == UserRole.superAdmin;
  bool get isStaff => role == UserRole.staff;
  bool get isUser => role == UserRole.user;
  bool get canManageRooms => isAdmin || isStaff;
  bool get canManageFoodPasses => isAdmin || isStaff;
  bool get canProcessRequests => isAdmin || isStaff;
}
