// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  hotelId: (json['hotel_id'] as num).toInt(),
  email: json['email'] as String,
  password: json['password'] as String,
  fullname: json['full_name'] as String,
  role: json['role'] as String,
  phoneNumber: json['phone_number'] as String,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'hotel_id': instance.hotelId,
  'email': instance.email,
  'password': instance.password,
  'full_name': instance.fullname,
  'role': instance.role,
  'phone_number': instance.phoneNumber,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
