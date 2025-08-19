// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roomservice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomService _$RoomServiceFromJson(Map<String, dynamic> json) => RoomService(
  id: (json['id'] as num).toInt(),
  roomId: (json['room_id'] as num).toInt(),
  requestType: json['request_type'] as String,
  requestTime: DateTime.parse(json['request_time'] as String),
  status: json['status'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RoomServiceToJson(RoomService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'request_type': instance.requestType,
      'request_time': instance.requestTime.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
