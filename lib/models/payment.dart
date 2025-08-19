
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int id;
  @JsonKey(name: 'booking_id')
  final int bookingId;
  final double amount;
  @JsonKey(name: 'payment_date')
  final DateTime paymentDate;
  final String? method;
  final String? status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;



  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentDate,
    this.method,
     this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
