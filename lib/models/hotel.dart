
import 'package:json_annotation/json_annotation.dart';

part 'hotel.g.dart';

@JsonSerializable()
class Hotel {
  final int id;
  final String name;
  final String address;
  final String city;
  final String country;
  @JsonKey(name: 'contact_email')
  final String contactEmail;
   @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;



  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.contactEmail,
    this.phoneNumber,
 DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Hotel.fromJson(Map<String, dynamic> json) =>
      _$HotelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelToJson(this);
}
