import 'package:flutter/material.dart';
import 'package:lodgix/services/bookmark_service.dart';

class BookmarkProvider with ChangeNotifier {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  // Getters
  List<Map<String, dynamic>> get bookmarks => List.unmodifiable(_bookmarks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasBookmarks => _bookmarks.isNotEmpty;
  int get bookmarkCount => _bookmarks.length;
  bool get hasInitialized => _hasInitialized;

  // Load bookmarks for a specific user
  Future<void> loadBookmarks(int userId, {bool forceRefresh = false}) async {
    // Don't reload if already loaded and not forcing refresh
    if (_hasInitialized && !forceRefresh && _bookmarks.isNotEmpty) {
      print('Bookmarks already loaded, skipping...');
      return;
    }

    print('Loading bookmarks for user: $userId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bookmarks = await BookmarkService.getBookmarks(guestId: userId);
      
      _bookmarks = bookmarks;
      _hasInitialized = true;
      _errorMessage = null;
      
      print('Successfully loaded ${_bookmarks.length} bookmarks');
    } catch (e) {
      print('Error loading bookmarks: $e');
      _errorMessage = 'Failed to load bookmarks: $e';
      _bookmarks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new bookmark
  Future<bool> addBookmark({
    required int hotelId,
    required int guestId,
  }) async {
    print('Adding bookmark for hotel: $hotelId, user: $guestId');
    
    try {
      final response = await BookmarkService.addBookmark(
        hotelId: hotelId,
        guestId: guestId,
      );

      if (response != null && response['status'] == 'success') {
        // Add to local list immediately for instant UI update
        final newBookmark = response['data'];
        _bookmarks.insert(0, newBookmark); // Add to beginning
        notifyListeners();
        
        print('Bookmark added successfully');
        return true;
      } else {
        print('Failed to add bookmark: ${response?['message']}');
        return false;
      }
    } catch (e) {
      print('Error adding bookmark: $e');
      return false;
    }
  }

  // Remove a bookmark
  Future<bool> removeBookmark({
    required int bookmarkId,
    int? hotelId, // Optional, for immediate UI update
  }) async {
    print('Removing bookmark with ID: $bookmarkId');
    
    try {
      final response = await BookmarkService.removeBookmark(
        bookmarkId: bookmarkId,
      );

      if (response != null && response['status'] == 'success') {
        // Remove from local list immediately for instant UI update
        _bookmarks.removeWhere((bookmark) => 
          bookmark['id'] == bookmarkId || 
          (hotelId != null && bookmark['hotel_id'] == hotelId)
        );
        notifyListeners();
        
        print('Bookmark removed successfully');
        return true;
      } else {
        print('Failed to remove bookmark: ${response?['message']}');
        return false;
      }
    } catch (e) {
      print('Error removing bookmark: $e');
      return false;
    }
  }

  // Check if a hotel is bookmarked
  bool isHotelBookmarked(int hotelId) {
    return _bookmarks.any((bookmark) => bookmark['hotel_id'] == hotelId);
  }

  // Get bookmark ID for a hotel
  int? getBookmarkId(int hotelId) {
    try {
      final bookmark = _bookmarks.firstWhere(
        (bookmark) => bookmark['hotel_id'] == hotelId,
      );
      return bookmark['id'];
    } catch (e) {
      return null;
    }
  }

  // Clear all bookmarks (for logout)
  void clearBookmarks() {
    try {
      _bookmarks.clear();
      print('Bookmarks cleared successfully');
      notifyListeners();
    } catch (e) {
      print('Error clearing bookmarks: $e');
      // Don't rethrow, just log the error
    }
  }

  // Refresh bookmarks
  Future<void> refreshBookmarks(int userId) async {
    await loadBookmarks(userId, forceRefresh: true);
  }

  // Update a specific bookmark (if needed)
  void updateBookmark(int bookmarkId, Map<String, dynamic> updatedData) {
    final index = _bookmarks.indexWhere((bookmark) => bookmark['id'] == bookmarkId);
    if (index != -1) {
      _bookmarks[index] = {..._bookmarks[index], ...updatedData};
      notifyListeners();
    }
  }
}