import 'package:json_annotation/json_annotation.dart';

part 'room_assignment.g.dart';

@JsonSerializable()
class RoomAssignment {
  final String id;
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'request_id')
  final String requestId;
  @JsonKey(name: 'check_in_date')
  final DateTime checkInDate;
  @JsonKey(name: 'check_out_date')
  final DateTime checkOutDate;
  @JsonKey(name: 'assigned_by')
  final String assignedBy;
  @JsonKey(name: 'assigned_at')
  final DateTime assignedAt;
  @JsonKey(name: 'checked_in')
  final bool checkedIn;
  @JsonKey(name: 'checked_out')
  final bool checkedOut;

  const RoomAssignment({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.requestId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.assignedBy,
    required this.assignedAt,
    required this.checkedIn,
    required this.checkedOut,
  });

  factory RoomAssignment.fromJson(Map<String, dynamic> json) =>
      _$RoomAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$RoomAssignmentToJson(this);
}
