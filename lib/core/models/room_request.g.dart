// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomRequest _$RoomRequestFromJson(Map<String, dynamic> json) => RoomRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      checkInDate: DateTime.parse(json['check_in_date'] as String),
      checkOutDate: DateTime.parse(json['check_out_date'] as String),
      numberOfPeople: (json['number_of_people'] as num).toInt(),
      preferredType: $enumDecode(_$RoomTypeEnumMap, json['preferred_type']),
      specialRequests: json['special_requests'] as String,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      processedBy: json['processed_by'] as String?,
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RoomRequestToJson(RoomRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'check_in_date': instance.checkInDate.toIso8601String(),
      'check_out_date': instance.checkOutDate.toIso8601String(),
      'number_of_people': instance.numberOfPeople,
      'preferred_type': _$RoomTypeEnumMap[instance.preferredType]!,
      'special_requests': instance.specialRequests,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'processed_by': instance.processedBy,
      'processed_at': instance.processedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$RoomTypeEnumMap = {
  RoomType.standard: 'STANDARD',
  RoomType.deluxe: 'DELUXE',
  RoomType.suite: 'SUITE',
  RoomType.familyRoom: 'FAMILY_ROOM',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'PENDING',
  RequestStatus.approved: 'APPROVED',
  RequestStatus.rejected: 'REJECTED',
};
