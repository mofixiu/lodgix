// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
  id: (json['id'] as num).toInt(),
  hotelId: (json['hotel_id'] as num).toInt(),
  roomNumber: json['room_number'] as String,
  type: json['type'] as String,
  pricePerNight: (json['price_per_night'] as num).toDouble(),
  status: json['status'] as String?,
  floor: json['floor'] as String,
  description: json['description'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
  'id': instance.id,
  'hotel_id': instance.hotelId,
  'room_number': instance.roomNumber,
  'type': instance.type,
  'price_per_night': instance.pricePerNight,
  'status': instance.status,
  'floor': instance.floor,
  'description': instance.description,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
