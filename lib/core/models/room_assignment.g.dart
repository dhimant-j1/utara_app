// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomAssignment _$RoomAssignmentFromJson(Map<String, dynamic> json) =>
    RoomAssignment(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      userId: json['user_id'] as String,
      requestId: json['request_id'] as String,
      checkInDate: DateTime.parse(json['check_in_date'] as String),
      checkOutDate: DateTime.parse(json['check_out_date'] as String),
      assignedBy: json['assigned_by'] as String,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
      checkedIn: json['checked_in'] as bool,
      checkedOut: json['checked_out'] as bool,
    );

Map<String, dynamic> _$RoomAssignmentToJson(RoomAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'user_id': instance.userId,
      'request_id': instance.requestId,
      'check_in_date': instance.checkInDate.toIso8601String(),
      'check_out_date': instance.checkOutDate.toIso8601String(),
      'assigned_by': instance.assignedBy,
      'assigned_at': instance.assignedAt.toIso8601String(),
      'checked_in': instance.checkedIn,
      'checked_out': instance.checkedOut,
    };
