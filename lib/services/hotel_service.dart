// Create lib/services/hotel_service.dart
import 'dart:developer';
import 'package:lodgix/request.dart';

class HotelService {
  static const String _baseUrl = '/users/hotels';

  // Get all hotels from database
  static Future<List<Map<String, dynamic>>> getAllHotels() async {
    try {
      log('Fetching all hotels from database...');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.get(_baseUrl);
      
      if (response != null && response['status'] == 'success') {
        log('Hotels fetched successfully: ${response['data'].length} hotels');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      
      log('Failed to fetch hotels: ${response?['message']}');
      return [];
    } catch (e) {
      log('Error fetching hotels: $e');
      return [];
    }
  }

  // Get hotel by ID
  static Future<Map<String, dynamic>?> getHotelById(int hotelId) async {
    try {
      log('Fetching hotel by ID: $hotelId');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.get('$_baseUrl/$hotelId');
      
      if (response != null && response['status'] == 'success') {
        log('Hotel fetched successfully');
        return response['data'];
      }
      
      log('Failed to fetch hotel: ${response?['message']}');
      return null;
    } catch (e) {
      log('Error fetching hotel: $e');
      return null;
    }
  }

  // Get hotels by city
  static Future<List<Map<String, dynamic>>> getHotelsByCity(String city) async {
    try {
      log('Fetching hotels for city: $city');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.get('$_baseUrl?city=$city');
      
      if (response != null && response['status'] == 'success') {
        log('Hotels fetched successfully for $city');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      
      log('Failed to fetch hotels for city: ${response?['message']}');
      return [];
    } catch (e) {
      log('Error fetching hotels by city: $e');
      return [];
    }
  }

  // Search hotels by name or location
  static Future<List<Map<String, dynamic>>> searchHotels(String query) async {
    try {
      log('Searching hotels with query: $query');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.get('$_baseUrl/search?q=$query');
      
      if (response != null && response['status'] == 'success') {
        log('Hotel search results: ${response['data'].length} hotels');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      
      log('Failed to search hotels: ${response?['message']}');
      return [];
    } catch (e) {
      log('Error searching hotels: $e');
      return [];
    }
  }
}