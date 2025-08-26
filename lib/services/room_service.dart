// Create lib/services/room_service.dart
import 'dart:developer';
import '../request.dart';

class RoomService {
  // Get rooms for a hotel
  static Future<List<Map<String, dynamic>>?> getHotelRooms(int hotelId) async {
    try {
      log('Getting rooms for hotel ID: $hotelId');
      log('Making GET request to: /rooms/hotel/$hotelId');

      final response = await get('/rooms/hotel/$hotelId');

      if (response != null && response['status'] == 'success') {
        log('Hotel rooms retrieved successfully');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      } else {
        log('Failed to get hotel rooms: ${response?['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      log('Error in getHotelRooms: $e');
      return [];
    }
  }

  // Get available rooms for booking
  static Future<List<Map<String, dynamic>>?> getAvailableRooms({
    required int hotelId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int roomsNeeded,
  }) async {
    try {
      log('Getting available rooms for hotel ID: $hotelId, rooms needed: $roomsNeeded');
      
      final response = await get(
        '/rooms/available?hotel_id=$hotelId&check_in=${checkInDate.toIso8601String()}&check_out=${checkOutDate.toIso8601String()}&rooms_needed=$roomsNeeded'
      );

      if (response != null && response['status'] == 'success') {
        log('Available rooms retrieved successfully');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      } else {
        log('Failed to get available rooms: ${response?['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      log('Error in getAvailableRooms: $e');
      return [];
    }
  }
}