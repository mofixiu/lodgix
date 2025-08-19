import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  @JsonKey(name: 'hotel_id')
  final int hotelId;
  final String email;
  final String password;
  @JsonKey(name: 'full_name')
  final String fullname;
  final String role;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
   @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

 User({
    required this.id,
    required this.username,
    required this.hotelId,
    required this.email,
    required this.password,
    required this.fullname,
    required this.role,
    required this.phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}