import 'package:json_annotation/json_annotation.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest {
  final int id;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String password;
  final String email;
  final String? address;
  @JsonKey(name: 'id_document')
  final String idDocument;
  @JsonKey(name: 'otp_verified')
  final bool? otpVerified;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Guest({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.email,
    this.address,
    required this.idDocument,
     this.otpVerified,
     DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);
  Map<String, dynamic> toJson() => _$GuestToJson(this);
}