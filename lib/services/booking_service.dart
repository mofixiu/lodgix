// Create lib/services/booking_service.dart
import 'dart:developer';
import 'package:lodgix/request.dart' as RequestService;

class BookingService {
  // Create a new booking
  static Future<Map<String, dynamic>?> createBooking({
    required int guestId,
    required int roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required double totalAmount,
    required String paymentStatus,
    String status = 'Booked',
  }) async {
    try {
      log('Creating booking for guest ID: $guestId');
      log('Making POST request to: /users/bookings'); // Updated path

      final response = await RequestService.post('/users/bookings', {
        'guest_id': guestId,
        'room_id': roomId,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'status': status,
        'total_amount': totalAmount,
        'payment_status': paymentStatus,
      });

      if (response != null && response['status'] == 'success') {
        log('Booking created successfully');
        return response;
      } else {
        log('Booking creation failed: ${response?['message'] ?? 'Unknown error'}');
        return response;
      }
    } catch (e) {
      log('Error in createBooking: $e');
      return {
        'status': 'error',
        'message': 'Failed to create booking: $e'
      };
    }
  }

  // Create a payment record
  static Future<Map<String, dynamic>?> createPayment({
    required int bookingId,
    required double amount,
    required String method,
    required String status,
  }) async {
    try {
      log('Creating payment for booking ID: $bookingId');
      log('Making POST request to: /users/payments'); // Updated path

      final response = await RequestService.post('/users/payments', {
        'booking_id': bookingId,
        'amount': amount,
        'payment_date': DateTime.now().toIso8601String(),
        'method': method,
        'status': status,
      });

      if (response != null && response['status'] == 'success') {
        log('Payment record created successfully');
        return response;
      } else {
        log('Payment creation failed: ${response?['message'] ?? 'Unknown error'}');
        return response;
      }
    } catch (e) {
      log('Error in createPayment: $e');
      return {
        'status': 'error',
        'message': 'Failed to create payment record: $e'
      };
    }
  }

  // Get user's bookings with hotel details
  static Future<List<Map<String, dynamic>>> getUserBookings(int guestId) async {
    try {
      log('Getting bookings for guest ID: $guestId');
      
      // Use the correct API path based on your backend routes
      final response = await RequestService.get('/users/bookings/guest/$guestId');
      
      print('=== API RESPONSE DEBUG ===');
      print('Status code: ${response != null ? "success" : "null"}');
      print('Response status: ${response?['status']}');
      print('Response message: ${response?['message']}');
      print('Raw API response: $response');
      print('Response data type: ${response?['data'].runtimeType}');
      print('Response data: ${response?['data']}');
      print('==========================');

      if (response != null && response['status'] == 'success') {
        final bookings = List<Map<String, dynamic>>.from(response['data'] ?? []);
        
        // Debug each booking in the response
        for (int i = 0; i < bookings.length; i++) {
          print('Booking $i details:');
          print('  ID: ${bookings[i]['id']}');
          print('  Hotel Name: ${bookings[i]['hotel_name']}');
          print('  Total Amount: ${bookings[i]['total_amount']} (${bookings[i]['total_amount'].runtimeType})');
          print('  Hotel Price: ${bookings[i]['hotel_price']}');
          print('  Payment Status: ${bookings[i]['payment_status']}');
          print('  Status: ${bookings[i]['status']}');
          print('  Check-in: ${bookings[i]['check_in_date']}');
          print('  Check-out: ${bookings[i]['check_out_date']}');
        }
        
        log('Bookings retrieved successfully: ${bookings.length} items');
        return bookings;
      } else {
        log('Failed to get bookings: ${response?['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      log('Error in getUserBookings: $e');
      return [];
    }
  }

  // Get available rooms for a hotel
  static Future<List<Map<String, dynamic>>> getAvailableRooms({
    required int hotelId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      log('Getting available rooms for hotel ID: $hotelId');
      
      // Use /users/rooms/available instead of /rooms/available
      final response = await RequestService.get('/users/rooms/available?hotel_id=$hotelId&check_in=${checkInDate.toIso8601String()}&check_out=${checkOutDate.toIso8601String()}');

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