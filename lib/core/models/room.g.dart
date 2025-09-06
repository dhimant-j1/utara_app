// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bed _$BedFromJson(Map<String, dynamic> json) => Bed(
      type: $enumDecode(_$BedTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$BedToJson(Bed instance) => <String, dynamic>{
      'type': _$BedTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
    };

const _$BedTypeEnumMap = {
  BedType.single: 'SINGLE',
  BedType.double: 'DOUBLE',
  BedType.extraBed: 'EXTRA_BED',
};

RoomImage _$RoomImageFromJson(Map<String, dynamic> json) => RoomImage(
      url: json['url'] as String,
      description: json['description'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );

Map<String, dynamic> _$RoomImageToJson(RoomImage instance) => <String, dynamic>{
      'url': instance.url,
      'description': instance.description,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
    };

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String,
      roomNumber: json['room_number'] as String,
      floor: (json['floor'] as num).toInt(),
      type: $enumDecode(_$RoomTypeEnumMap, json['type']),
      beds: (json['beds'] as List<dynamic>)
          .map((e) => Bed.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasGeyser: json['has_geyser'] as bool? ?? false,
      hasAc: json['has_ac'] as bool? ?? false,
      hasSofaSet: json['has_sofa_set'] as bool? ?? false,
      sofaSetQuantity: (json['sofa_set_quantity'] as num?)?.toInt(),
      extraAmenities: json['extra_amenities'] as String? ?? '',
      isVisible: json['is_visible'] as bool? ?? true,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => RoomImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      isOccupied: json['is_occupied'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'room_number': instance.roomNumber,
      'floor': instance.floor,
      'type': _$RoomTypeEnumMap[instance.type]!,
      'beds': instance.beds,
      'has_geyser': instance.hasGeyser,
      'has_ac': instance.hasAc,
      'has_sofa_set': instance.hasSofaSet,
      'sofa_set_quantity': instance.sofaSetQuantity,
      'extra_amenities': instance.extraAmenities,
      'is_visible': instance.isVisible,
      'images': instance.images,
      'is_occupied': instance.isOccupied,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$RoomTypeEnumMap = {
  RoomType.shreeHariPlus: 'SHREEHARIPLUS',
  RoomType.shreeHari: 'SHREEHARI',
  RoomType.sarjuPlus: 'SARJUPLUS',
  RoomType.sarju: 'SARJU',
  RoomType.neelkanthPlus: 'NEELKANTHPLUS',
  RoomType.neelkanth: 'NEELKANTH',
};
