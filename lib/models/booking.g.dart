// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: (json['id'] as num).toInt(),
  guestId: (json['guest_id'] as num).toInt(),
  roomId: (json['room_id'] as num).toInt(),
  checkInDate: DateTime.parse(json['check_in_date'] as String),
  checkOutDate: DateTime.parse(json['check_out_date'] as String),
  status: json['status'] as String?,
  totalAmount: (json['total_amount'] as num).toDouble(),
  paymentStatus: json['payment_status'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'guest_id': instance.guestId,
  'room_id': instance.roomId,
  'check_in_date': instance.checkInDate.toIso8601String(),
  'check_out_date': instance.checkOutDate.toIso8601String(),
  'status': instance.status,
  'total_amount': instance.totalAmount,
  'payment_status': instance.paymentStatus,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
