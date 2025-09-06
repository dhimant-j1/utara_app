// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomRequest _$RoomRequestFromJson(Map<String, dynamic> json) => RoomRequest(
      place: json['place'] as String,
      purpose: json['purpose'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['user_id'] as String,
      checkInDate: DateTime.parse(json['check_in_date'] as String),
      checkOutDate: DateTime.parse(json['check_out_date'] as String),
      numberOfPeople: PeopleCount.fromJson(
          json['number_of_people'] as Map<String, dynamic>),
      specialRequests: json['special_requests'] as String,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      processedBy: json['processed_by'] as String?,
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : UserInformation.fromJson(json['user'] as Map<String, dynamic>),
      room: json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
      assignment: json['assignment'] == null
          ? null
          : RoomAssignment.fromJson(json['assignment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomRequestToJson(RoomRequest instance) =>
    <String, dynamic>{
      'place': instance.place,
      'purpose': instance.purpose,
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'check_in_date': instance.checkInDate.toIso8601String(),
      'check_out_date': instance.checkOutDate.toIso8601String(),
      'number_of_people': instance.numberOfPeople,
      'special_requests': instance.specialRequests,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'processed_by': instance.processedBy,
      'processed_at': instance.processedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'room': instance.room,
      'assignment': instance.assignment,
    };

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'PENDING',
  RequestStatus.approved: 'APPROVED',
  RequestStatus.rejected: 'REJECTED',
};
