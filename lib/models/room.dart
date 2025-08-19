
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  final int id;
  @JsonKey(name: 'hotel_id')
  final int hotelId;
  @JsonKey(name: 'room_number')
  final String roomNumber;
  final String type;
  @JsonKey(name: 'price_per_night')
  final double pricePerNight;
  final String? status;
  final String floor;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;



  Room({
    required this.id,
    required this.hotelId,
    required this.roomNumber,
    required this.type,
    required this.pricePerNight,
     this.status,
    required this.floor,
    this.description,
  DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Room.fromJson(Map<String, dynamic> json) =>
      _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
