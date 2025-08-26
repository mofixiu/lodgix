import 'package:flutter/material.dart';
import 'package:lodgix/services/booking_service.dart';
import 'package:lodgix/screens/payment.dart'; // For BookedHotelsManager

class BookingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  // Getters
  List<Map<String, dynamic>> get bookings => List.unmodifiable(_bookings);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasBookings => _bookings.isNotEmpty;
  int get bookingCount => _bookings.length;
  bool get hasInitialized => _hasInitialized;

  // Load bookings for a specific user
  Future<void> loadBookings(int userId, {bool forceRefresh = false}) async {
    // Always load if forcing refresh, not initialized, or no data
    if (!forceRefresh && _hasInitialized && _bookings.isNotEmpty && !_isLoading) {
      print('Bookings already loaded and not forcing refresh, returning cached data');
      return;
    }

    print('Loading bookings for user: $userId (forceRefresh: $forceRefresh, hasInitialized: $_hasInitialized, bookingsCount: ${_bookings.length})');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch bookings from database using the correct API path
      print('Making API call to fetch bookings...');
      final databaseBookings = await BookingService.getUserBookings(userId);
      
      print('Received ${databaseBookings.length} bookings from database');
      print('Raw database bookings response: $databaseBookings');
      
      // Debug each booking
      for (int i = 0; i < databaseBookings.length; i++) {
        print('Booking $i: ${databaseBookings[i]}');
        print('Total amount for booking $i: ${databaseBookings[i]['total_amount']}');
      }
      
      // Also get local bookings for backward compatibility
      final localBookings = BookedHotelsManager.getBookedHotels();
      print('Local bookings: ${localBookings.length}');
      
      // Combine both lists (database first, then local)
      _bookings = [...databaseBookings, ...localBookings];
      _hasInitialized = true;
      _errorMessage = null;
      
      print('Successfully loaded ${_bookings.length} total bookings (${databaseBookings.length} from database, ${localBookings.length} local)');
    } catch (e) {
      print('Error loading bookings: $e');
      _errorMessage = 'Failed to load bookings: $e';
      
      // Fallback to local bookings only
      try {
        final localBookings = BookedHotelsManager.getBookedHotels();
        _bookings = localBookings;
        _hasInitialized = true; // Still mark as initialized
        print('Loaded ${localBookings.length} local bookings as fallback');
      } catch (localError) {
        print('Error loading local bookings: $localError');
        _bookings = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new booking
  Future<Map<String, dynamic>?> createBooking({
    required int guestId,
    required int roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required double totalAmount,
    required String paymentStatus,
    String status = 'Booked',
  }) async {
    print('Creating booking for user: $guestId');
    
    try {
      final response = await BookingService.createBooking(
        guestId: guestId,
        roomId: roomId,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        totalAmount: totalAmount,
        paymentStatus: paymentStatus,
        status: status,
      );

      if (response != null && response['status'] == 'success') {
        // Add to local list immediately for instant UI update
        final newBooking = response['data'];
        _bookings.insert(0, newBooking); // Add to beginning (most recent first)
        notifyListeners();
        
        print('Booking created successfully');
        return response;
      } else {
        print('Failed to create booking: ${response?['message']}');
        return response;
      }
    } catch (e) {
      print('Error creating booking: $e');
      return {
        'status': 'error',
        'message': 'Failed to create booking: $e'
      };
    }
  }

  // Create a payment record
  Future<Map<String, dynamic>?> createPayment({
    required int bookingId,
    required double amount,
    required String method,
    required String status,
  }) async {
    print('Creating payment for booking: $bookingId');
    
    try {
      final response = await BookingService.createPayment(
        bookingId: bookingId,
        amount: amount,
        method: method,
        status: status,
      );

      if (response != null && response['status'] == 'success') {
        // Update the booking in local list with payment info
        final bookingIndex = _bookings.indexWhere((booking) => booking['id'] == bookingId);
        if (bookingIndex != -1) {
          _bookings[bookingIndex] = {
            ..._bookings[bookingIndex],
            'payment_status': status,
            'payment_method': method,
          };
          notifyListeners();
        }
        
        print('Payment created successfully');
        return response;
      } else {
        print('Failed to create payment: ${response?['message']}');
        return response;
      }
    } catch (e) {
      print('Error creating payment: $e');
      return {
        'status': 'error',
        'message': 'Failed to create payment: $e'
      };
    }
  }

  // Add a local booking (for backward compatibility)
  void addLocalBooking(Map<String, dynamic> bookingData) {
    print('Adding local booking');
    
    // Check if already exists
    bool alreadyExists = _bookings.any((booking) => 
      booking['name'] == bookingData['name'] && 
      booking['location'] == bookingData['location']
    );
    
    if (!alreadyExists) {
      _bookings.insert(0, bookingData);
      
      // Also add to BookedHotelsManager for persistence
      BookedHotelsManager.addBookedHotel(bookingData);
      
      notifyListeners();
      print('Local booking added successfully');
    } else {
      print('Booking already exists, skipping...');
    }
  }

  // Update booking status
  void updateBookingStatus(int bookingId, String newStatus) {
    final bookingIndex = _bookings.indexWhere((booking) => booking['id'] == bookingId);
    if (bookingIndex != -1) {
      _bookings[bookingIndex] = {
        ..._bookings[bookingIndex],
        'status': newStatus,
      };
      notifyListeners();
      print('Updated booking $bookingId status to $newStatus');
    }
  }

  // Update payment status
  void updatePaymentStatus(int bookingId, String newPaymentStatus) {
    final bookingIndex = _bookings.indexWhere((booking) => booking['id'] == bookingId);
    if (bookingIndex != -1) {
      _bookings[bookingIndex] = {
        ..._bookings[bookingIndex],
        'payment_status': newPaymentStatus,
      };
      notifyListeners();
      print('Updated booking $bookingId payment status to $newPaymentStatus');
    }
  }

  // Get bookings by status
  List<Map<String, dynamic>> getBookingsByStatus(String status) {
    return _bookings.where((booking) => booking['status'] == status).toList();
  }

  // Get upcoming bookings
  List<Map<String, dynamic>> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      try {
        if (booking['check_in_date'] != null) {
          final checkInDate = DateTime.parse(booking['check_in_date'].toString());
          return checkInDate.isAfter(now);
        }
        return false;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get past bookings
  List<Map<String, dynamic>> getPastBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      try {
        if (booking['check_out_date'] != null) {
          final checkOutDate = DateTime.parse(booking['check_out_date'].toString());
          return checkOutDate.isBefore(now);
        }
        return false;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Clear all bookings (for logout)
  void clearBookings() {
    try {
      _bookings.clear();
      _isLoading = false;
      _errorMessage = null;
      _hasInitialized = false;
      print('Bookings cleared successfully');
      
      // Schedule notifyListeners for after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      print('Error clearing bookings: $e');
      // Don't rethrow, just log the error
    }
  }

  // Refresh bookings
  Future<void> refreshBookings(int userId) async {
    await loadBookings(userId, forceRefresh: true);
  }

  // Remove a booking (if needed)
  void removeBooking(int bookingId) {
    _bookings.removeWhere((booking) => booking['id'] == bookingId);
    notifyListeners();
    print('Removed booking: $bookingId');
  }

  // Add an auto-loading getter that ensures data is loaded
  Future<void> ensureBookingsLoaded(int userId) async {
    if (!_hasInitialized || _bookings.isEmpty) {
      print('Auto-loading bookings for user: $userId');
      // Don't call notifyListeners immediately, schedule it for after build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await loadBookings(userId);
      });
    }
  }
}