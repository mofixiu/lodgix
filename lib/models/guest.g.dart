// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String,
  phoneNumber: json['phone_number'] as String,
  password: json['password'] as String,
  email: json['email'] as String,
  address: json['address'] as String?,
  idDocument: json['id_document'] as String,
  otpVerified: json['otp_verified'] as bool?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'phone_number': instance.phoneNumber,
  'password': instance.password,
  'email': instance.email,
  'address': instance.address,
  'id_document': instance.idDocument,
  'otp_verified': instance.otpVerified,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
