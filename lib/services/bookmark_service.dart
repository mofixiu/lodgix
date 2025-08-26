import 'dart:developer';
import 'package:lodgix/request.dart';

class BookmarkService {
  static const String _baseUrl = '/users/bookmarks';

  // Add bookmark to database
  static Future<Map<String, dynamic>?> addBookmark({
    required int hotelId,
    required int guestId,
  }) async {
    try {
      log('Adding bookmark for hotel: $hotelId, guest: $guestId');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final data = {
        'hotel_id': hotelId,
        'guest_id': guestId,
      };

      final response = await RequestService.post(_baseUrl, data);
      
      if (response != null && response['status'] == 'success') {
        log('Bookmark added successfully');
        return response;
      }
      
      log('Failed to add bookmark: ${response?['message']}');
      return response;
    } catch (e) {
      log('Error adding bookmark: $e');
      rethrow;
    }
  }

  // Get all bookmarks for a guest
  static Future<List<Map<String, dynamic>>> getBookmarks({
    required int guestId,
  }) async {
    try {
      log('Fetching bookmarks for guest: $guestId');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.get('$_baseUrl?guest_id=$guestId');
      
      if (response != null && response['status'] == 'success') {
        log('Bookmarks fetched successfully');
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      
      log('Failed to fetch bookmarks: ${response?['message']}');
      return [];
    } catch (e) {
      log('Error fetching bookmarks: $e');
      return [];
    }
  }

  // Remove bookmark from database
  static Future<Map<String, dynamic>?> removeBookmark({
    required int bookmarkId,
  }) async {
    try {
      log('Removing bookmark: $bookmarkId');
      
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final response = await RequestService.delete('$_baseUrl/$bookmarkId');
      
      if (response != null && response['status'] == 'success') {
        log('Bookmark removed successfully');
        return response;
      }
      
      log('Failed to remove bookmark: ${response?['message']}');
      return response;
    } catch (e) {
      log('Error removing bookmark: $e');
      rethrow;
    }
  }

  // Check if hotel is bookmarked by guest
  static Future<bool> isBookmarked({
    required int hotelId,
    required int guestId,
  }) async {
    try {
      final bookmarks = await getBookmarks(guestId: guestId);
      return bookmarks.any((bookmark) => 
        bookmark['hotel_id'] == hotelId);
    } catch (e) {
      log('Error checking bookmark status: $e');
      return false;
    }
  }

  // Get bookmark ID for a specific hotel and guest
  static Future<int?> getBookmarkId({
    required int hotelId,
    required int guestId,
  }) async {
    try {
      final bookmarks = await getBookmarks(guestId: guestId);
      final bookmark = bookmarks.firstWhere(
        (bookmark) => bookmark['hotel_id'] == hotelId,
        orElse: () => {},
      );
      return bookmark['id'];
    } catch (e) {
      log('Error getting bookmark ID: $e');
      return null;
    }
  }
}