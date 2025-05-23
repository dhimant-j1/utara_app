import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

enum RoomType {
  @JsonValue('STANDARD')
  standard,
  @JsonValue('DELUXE')
  deluxe,
  @JsonValue('SUITE')
  suite,
  @JsonValue('FAMILY_ROOM')
  familyRoom,
}

enum BedType {
  @JsonValue('SINGLE')
  single,
  @JsonValue('DOUBLE')
  double,
  @JsonValue('EXTRA_BED')
  extraBed,
}

@JsonSerializable()
class Bed {
  final BedType type;
  final int quantity;

  const Bed({
    required this.type,
    required this.quantity,
  });

  factory Bed.fromJson(Map<String, dynamic> json) => _$BedFromJson(json);
  Map<String, dynamic> toJson() => _$BedToJson(this);
}

@JsonSerializable()
class RoomImage {
  final String url;
  final String description;
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;

  const RoomImage({
    required this.url,
    required this.description,
    required this.uploadedAt,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) => _$RoomImageFromJson(json);
  Map<String, dynamic> toJson() => _$RoomImageToJson(this);
}

@JsonSerializable()
class Room {
  final String id;
  @JsonKey(name: 'room_number')
  final String roomNumber;
  final int floor;
  final RoomType type;
  final List<Bed> beds;
  @JsonKey(name: 'has_geyser')
  final bool hasGeyser;
  @JsonKey(name: 'has_ac')
  final bool hasAc;
  @JsonKey(name: 'has_sofa_set')
  final bool hasSofaSet;
  @JsonKey(name: 'sofa_set_quantity')
  final int sofaSetQuantity;
  @JsonKey(name: 'extra_amenities')
  final String extraAmenities;
  @JsonKey(name: 'is_visible')
  final bool isVisible;
  final List<RoomImage> images;
  @JsonKey(name: 'is_occupied')
  final bool isOccupied;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Room({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.type,
    required this.beds,
    required this.hasGeyser,
    required this.hasAc,
    required this.hasSofaSet,
    required this.sofaSetQuantity,
    required this.extraAmenities,
    required this.isVisible,
    required this.images,
    required this.isOccupied,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room copyWith({
    String? id,
    String? roomNumber,
    int? floor,
    RoomType? type,
    List<Bed>? beds,
    bool? hasGeyser,
    bool? hasAc,
    bool? hasSofaSet,
    int? sofaSetQuantity,
    String? extraAmenities,
    bool? isVisible,
    List<RoomImage>? images,
    bool? isOccupied,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      type: type ?? this.type,
      beds: beds ?? this.beds,
      hasGeyser: hasGeyser ?? this.hasGeyser,
      hasAc: hasAc ?? this.hasAc,
      hasSofaSet: hasSofaSet ?? this.hasSofaSet,
      sofaSetQuantity: sofaSetQuantity ?? this.sofaSetQuantity,
      extraAmenities: extraAmenities ?? this.extraAmenities,
      isVisible: isVisible ?? this.isVisible,
      images: images ?? this.images,
      isOccupied: isOccupied ?? this.isOccupied,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get bedsSummary {
    final bedCounts = <BedType, int>{};
    for (final bed in beds) {
      bedCounts[bed.type] = (bedCounts[bed.type] ?? 0) + bed.quantity;
    }
    
    final parts = <String>[];
    bedCounts.forEach((type, count) {
      final typeName = switch (type) {
        BedType.single => 'Single',
        BedType.double => 'Double',
        BedType.extraBed => 'Extra Bed',
      };
      parts.add('$count $typeName');
    });
    
    return parts.join(', ');
  }

  List<String> get amenitiesList {
    final amenities = <String>[];
    if (hasGeyser) amenities.add('Geyser');
    if (hasAc) amenities.add('AC');
    if (hasSofaSet) amenities.add('Sofa Set ($sofaSetQuantity)');
    if (extraAmenities.isNotEmpty) amenities.add(extraAmenities);
    return amenities;
  }
} 