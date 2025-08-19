
import 'package:json_annotation/json_annotation.dart';

part 'roomservice.g.dart';

@JsonSerializable()
class RoomService {
  final int id;
  @JsonKey(name: 'room_id')
  final int roomId;
  @JsonKey(name: 'request_type')
  final String requestType;
  @JsonKey(name: 'request_time')
  final DateTime requestTime;
  final String? status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;



  RoomService({
    required this.id,
    required this.roomId,
    required this.requestType,
    required this.requestTime,
    this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }): createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
 

  factory RoomService.fromJson(Map<String, dynamic> json) =>
      _$RoomServiceFromJson(json);
  Map<String, dynamic> toJson() => _$RoomServiceToJson(this);
}
