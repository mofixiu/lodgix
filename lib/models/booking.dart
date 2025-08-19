import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';
@JsonSerializable()
class Booking {
  final int id;
  @JsonKey(name: 'guest_id')
  int guestId;
  @JsonKey(name: 'room_id')
  int roomId;
  @JsonKey(name: 'check_in_date')
  DateTime checkInDate;
  @JsonKey(name: 'check_out_date')
  DateTime checkOutDate;
  String? status;
  @JsonKey(name: 'total_amount')
  double totalAmount;
  @JsonKey(name: 'payment_status')
  String? paymentStatus;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Booking({
    required this.id,
    required this.guestId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    this.status,
    required this.totalAmount,
    this.paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}