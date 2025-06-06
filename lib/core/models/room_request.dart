import 'package:json_annotation/json_annotation.dart';
import 'room.dart';

part 'room_request.g.dart';

enum RequestStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

@JsonSerializable()
class RoomRequest {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'check_in_date')
  final DateTime checkInDate;
  @JsonKey(name: 'check_out_date')
  final DateTime checkOutDate;
  @JsonKey(name: 'number_of_people')
  final int numberOfPeople;
  @JsonKey(name: 'preferred_type')
  final RoomType preferredType;
  @JsonKey(name: 'special_requests')
  final String specialRequests;
  final RequestStatus status;
  @JsonKey(name: 'processed_by')
  final String? processedBy;
  @JsonKey(name: 'processed_at')
  final DateTime? processedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const RoomRequest({
    required this.id,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfPeople,
    required this.preferredType,
    required this.specialRequests,
    required this.status,
    this.processedBy,
    this.processedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomRequest.fromJson(Map<String, dynamic> json) => _$RoomRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RoomRequestToJson(this);

  RoomRequest copyWith({
    String? id,
    String? userId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfPeople,
    RoomType? preferredType,
    String? specialRequests,
    RequestStatus? status,
    String? processedBy,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoomRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      preferredType: preferredType ?? this.preferredType,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      processedBy: processedBy ?? this.processedBy,
      processedAt: processedAt ?? this.processedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get durationInDays {
    return checkOutDate.difference(checkInDate).inDays;
  }

  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;
  bool get isProcessed => isApproved || isRejected;
} 