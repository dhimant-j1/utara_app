import 'package:json_annotation/json_annotation.dart';
import 'room.dart';
import 'room_assignment.dart';

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
  final String place;
  final String purpose;
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'check_in_date')
  final DateTime checkInDate;
  @JsonKey(name: 'check_out_date')
  final DateTime checkOutDate;
  @JsonKey(name: 'number_of_people')
  final PeopleCount numberOfPeople;
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
  final UserInformation? user;
  final String? reference;
  final Room? room;
  final RoomAssignment? assignment;
  @JsonKey(name: 'chitthi_url')
  final String? chitthiUrl;

  const RoomRequest({
    required this.place,
    required this.purpose,
    required this.id,
    required this.name,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfPeople,
    required this.specialRequests,
    required this.status,
    this.processedBy,
    this.processedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.room,
    this.assignment,
    this.reference,
    this.chitthiUrl,
  });

  factory RoomRequest.fromJson(Map<String, dynamic> json) =>
      _$RoomRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RoomRequestToJson(this);

  RoomRequest copyWith({
    String? place,
    String? purpose,
    String? id,
    String? userId,
    String? name,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    PeopleCount? numberOfPeople,
    RoomType? preferredType,
    String? specialRequests,
    RequestStatus? status,
    String? processedBy,
    DateTime? processedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserInformation? user,
    Room? room,
    RoomAssignment? assignment,
    String? reference,
    String? chitthiUrl,
  }) {
    return RoomRequest(
      place: place ?? this.place,
      purpose: purpose ?? this.purpose,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      processedBy: processedBy ?? this.processedBy,
      processedAt: processedAt ?? this.processedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      room: room ?? this.room,
      assignment: assignment ?? this.assignment,
      reference: reference ?? this.reference,
      chitthiUrl: chitthiUrl ?? this.chitthiUrl,
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

class UserInformation {
  final String? name;
  @JsonKey(name: 'user_name')
  final String? userName;
  @JsonKey(name: 'user_type')
  final String? userType;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phone;

  UserInformation({
    required this.name,
    required this.userName,
    required this.userType,
    required this.email,
    required this.phone,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      name: json['name'] as String?,
      userName: json['user_name'] as String?,
      userType: json['user_type'] as String?,
      email: json['email'] as String?,
      phone: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_name': userName,
      'user_type': userType,
      'email': email,
      'phone_number': phone,
    };
  }
}

class PeopleCount {
  final int male;
  final int female;
  final int children;
  final int total;

  PeopleCount({
    required this.male,
    required this.female,
    required this.children,
    required this.total,
  });

  factory PeopleCount.fromJson(Map<String, dynamic> json) {
    return PeopleCount(
      male: json['male'] as int,
      female: json['female'] as int,
      children: json['children'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'male': male,
      'female': female,
      'children': children,
      'total': total,
    };
  }
}
