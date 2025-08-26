import 'dart:developer';
import 'package:lodgix/request.dart' as RequestService;

class PaymentService {
  static Future<List<Map<String, dynamic>>> getUserPayments(int guestId) async {
    try {
      log('Getting payments for guest ID: $guestId');
      
      final response = await RequestService.get('/users/payments/guest/$guestId');
      
      print('=== PAYMENT API RESPONSE DEBUG ===');
      print('Response status: ${response?['status']}');
      print('Response message: ${response?['message']}');
      print('Raw API response: $response');
      print('Response data: ${response?['data']}');
      print('==================================');

      if (response != null && response['status'] == 'success') {
        final payments = List<Map<String, dynamic>>.from(response['data'] ?? []);
        log('Payments retrieved successfully: ${payments.length} items');
        return payments;
      } else {
        log('Failed to get payments: ${response?['message'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      log('Error in getUserPayments: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPaymentById(int paymentId) async {
    try {
      log('Getting payment by ID: $paymentId');
      
      final response = await RequestService.get('/payments/$paymentId');
      
      if (response != null && response['status'] == 'success') {
        log('Payment retrieved successfully');
        return response['data'];
      } else {
        log('Failed to get payment: ${response?['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      log('Error in getPaymentById: $e');
      return null;
    }
  }
}