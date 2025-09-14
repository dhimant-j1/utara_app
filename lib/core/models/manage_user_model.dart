// To parse this JSON data, do
//
//     final manageUserModel = manageUserModelFromJson(jsonString);

import 'dart:convert';

ManageUserModel manageUserModelFromJson(String str) =>
    ManageUserModel.fromJson(json.decode(str));

String manageUserModelToJson(ManageUserModel data) =>
    json.encode(data.toJson());

class ManageUserModel {
  int? count;
  List<ManangeUser>? users;

  ManageUserModel({
    this.count,
    this.users,
  });

  ManageUserModel copyWith({
    int? count,
    List<ManangeUser>? users,
  }) =>
      ManageUserModel(
        count: count ?? this.count,
        users: users ?? this.users,
      );

  factory ManageUserModel.fromJson(Map<String, dynamic> json) =>
      ManageUserModel(
        count: json["count"],
        users: json["users"] == null
            ? []
            : List<ManangeUser>.from(
                json["users"]!.map((x) => ManangeUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class ManangeUser {
  String? id;
  String? userName;
  String? email;
  String? name;
  String? role;
  bool? isImportant;
  String? phoneNumber;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;

  ManangeUser({
    this.id,
    this.userName,
    this.email,
    this.name,
    this.role,
    this.isImportant,
    this.phoneNumber,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  ManangeUser copyWith({
    String? id,
    String? userName,
    String? email,
    String? name,
    String? role,
    bool? isImportant,
    String? phoneNumber,
    String? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ManangeUser(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        isImportant: isImportant ?? this.isImportant,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        userType: userType ?? this.userType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ManangeUser.fromJson(Map<String, dynamic> json) => ManangeUser(
        id: json["id"],
        userName: json["user_name"],
        email: json["email"],
        name: json["name"],
        role: json["role"],
        isImportant: json["is_important"],
        phoneNumber: json["phone_number"],
        userType: json["user_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "email": email,
        "name": name,
        "role": role,
        "is_important": isImportant,
        "phone_number": phoneNumber,
        "user_type": userType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
