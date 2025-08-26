import 'package:flutter/material.dart';
import 'package:lodgix/widgets/customButton.dart';
import 'package:lodgix/screens/bookedScreen.dart';
import 'package:lodgix/services/booking_service.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BookedHotelsManager {
  static List<Map<String, dynamic>> _bookedHotels = [];
  
  static void addBookedHotel(Map<String, dynamic> hotelData) {
    print('Adding booked hotel: ${hotelData['name']}');
    bool alreadyBooked = _bookedHotels.any((hotel) => 
        hotel['name'] == hotelData['name'] && 
        hotel['location'] == hotelData['location']);
    
    if (!alreadyBooked) {
      _bookedHotels.add(hotelData);
      print('Hotel added. Total local bookings: ${_bookedHotels.length}');
    } else {
      print('Hotel already exists in local bookings');
    }
  }
  
  static List<Map<String, dynamic>> getBookedHotels() {
    print('Returning ${_bookedHotels.length} local booked hotels');
    return List.from(_bookedHotels);
  }
  
  static void removeBookedHotel(Map<String, dynamic> hotelData) {
    _bookedHotels.removeWhere((hotel) => 
        hotel['name'] == hotelData['name'] && 
        hotel['location'] == hotelData['location']);
    print('Hotel removed. Total local bookings: ${_bookedHotels.length}');
  }
  
  static void clearAll() {
    _bookedHotels.clear();
    print('All local bookings cleared');
  }
}

class Payment extends StatefulWidget {
  final String hotelName;
  final String location;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final int rooms;
  final double totalPrice;
  final String image;
  final int? hotelId; // This is correct

  const Payment({
    Key? key,
    required this.hotelName,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.rooms,
    required this.totalPrice,
    required this.image,
    this.hotelId, // This is correct
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedPaymentMethod = 'arrival';
  bool _isProcessing = false;

  Widget _buildPaymentMethod({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPaymentMethod == value
                ? Color(0xFF0A3D62)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedPaymentMethod == value
              ? Color(0xFF0A3D62).withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedPaymentMethod == value
                    ? Color(0xFF0A3D62)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: selectedPaymentMethod == value
                    ? Colors.white
                    : Colors.grey[600],
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue!;
                });
              },
              activeColor: Color(0xFF0A3D62),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Get user provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      print('=== BOOKING CONFIRMATION DEBUG ===');
      print('User logged in: ${userProvider.isLoggedIn}');
      print('User ID: ${userProvider.userId}');
      print('Hotel ID: ${widget.hotelId}');
      print('Payment Method: $selectedPaymentMethod');
      print('================================');

      if (!userProvider.isLoggedIn || userProvider.userId == null) {
        _showErrorDialog('Please log in to complete your booking');
        return;
      }

      if (widget.hotelId == null) {
        _showErrorDialog('Hotel information is missing. Please try again.');
        return;
      }

      // Get available rooms for the hotel
      print('Getting available rooms for hotel: ${widget.hotelId}');
      final availableRooms = await BookingService.getAvailableRooms(
        hotelId: widget.hotelId!,
        checkInDate: widget.checkInDate,
        checkOutDate: widget.checkOutDate,
      );

      if (availableRooms.isEmpty) {
        _showErrorDialog('No rooms available for the selected dates. Please choose different dates.');
        return;
      }

      // Select the first available room (you can implement room selection logic here)
      final selectedRoom = availableRooms.first;
      final roomId = selectedRoom['id'];
      
      print('Selected room ID: $roomId');

      // Determine payment status based on method
      String paymentStatus = selectedPaymentMethod == 'arrival' ? 'Unpaid' : 'Paid';
      String paymentMethod = selectedPaymentMethod == 'arrival' ? 'Cash' : 'Bank Transfer';

      print('Creating booking...');
      // Create booking in database
      final bookingResponse = await BookingService.createBooking(
        guestId: userProvider.userId!,
        roomId: roomId,
        checkInDate: widget.checkInDate,
        checkOutDate: widget.checkOutDate,
        totalAmount: widget.totalPrice,
        paymentStatus: paymentStatus,
      );

      if (bookingResponse == null || bookingResponse['status'] != 'success') {
        _showErrorDialog('Failed to create booking. Please try again.');
        return;
      }

      print('Booking created successfully');
      final bookingId = bookingResponse['data']['id'];

      // Create payment record
      print('Creating payment record...');
      final paymentResponse = await BookingService.createPayment(
        bookingId: bookingId,
        amount: widget.totalPrice,
        method: paymentMethod,
        status: 'Completed',
      );

      if (paymentResponse == null || paymentResponse['status'] != 'success') {
        print('Warning: Payment record creation failed, but booking was successful');
      }

      // Also add to local storage for immediate display
      Map<String, dynamic> bookedHotelData = {
        'name': widget.hotelName,
        'location': widget.location,
        'rating': 4.5,
        'price': widget.totalPrice.toInt(),
        'image': widget.image,
        'checkInDate': widget.checkInDate.toIso8601String(),
        'checkOutDate': widget.checkOutDate.toIso8601String(),
        'guests': widget.guests,
        'rooms': widget.rooms,
        'paymentMethod': selectedPaymentMethod,
        'bookingDate': DateTime.now().toIso8601String(),
        'bookingId': bookingId,
      };

      BookedHotelsManager.addBookedHotel(bookedHotelData);

      print('Booking process completed successfully');
      _showSuccessDialog(paymentMethod);

    } catch (e) {
      print('Error during booking confirmation: $e');
      _showErrorDialog('An error occurred while processing your booking. Please try again.');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Booking Failed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String paymentMethodText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your booking has been confirmed successfully.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF0A3D62).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Hotel: ${widget.hotelName}'),
                    Text('Payment Method: $paymentMethodText'),
                    Text('Total: ₦${widget.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                    Text('Check-in: ${widget.checkInDate.day}/${widget.checkInDate.month}/${widget.checkInDate.year}'),
                    Text('Check-out: ${widget.checkOutDate.day}/${widget.checkOutDate.month}/${widget.checkOutDate.year}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to DateSelect
                Navigator.of(context).pop(); // Go back to HotelDetails
                
                // Navigate to booked screen to show the new booking
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Booked(),
                  ),
                );
              },
              child: Text(
                'View Bookings',
                style: TextStyle(
                  color: Color(0xFF0A3D62),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to DateSelect
                Navigator.of(context).pop(); // Go back to HotelDetails
                Navigator.of(context).pop(); // Go back to main screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A3D62),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Summary Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                widget.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.hotel, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.hotelName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.location,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),

                        // Booking Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Check-in', style: TextStyle(color: Colors.grey[600])),
                            Text('${widget.checkInDate.day}/${widget.checkInDate.month}/${widget.checkInDate.year}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Check-out', style: TextStyle(color: Colors.grey[600])),
                            Text('${widget.checkOutDate.day}/${widget.checkOutDate.month}/${widget.checkOutDate.year}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Guests', style: TextStyle(color: Colors.grey[600])),
                            Text('${widget.guests} guest${widget.guests > 1 ? 's' : ''}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rooms', style: TextStyle(color: Colors.grey[600])),
                            Text('${widget.rooms} room${widget.rooms > 1 ? 's' : ''}'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Duration', style: TextStyle(color: Colors.grey[600])),
                            Text('${widget.checkOutDate.difference(widget.checkInDate).inDays} night${widget.checkOutDate.difference(widget.checkInDate).inDays > 1 ? 's' : ''}'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '₦${widget.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A3D62),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Payment Method Section
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildPaymentMethod(
                    value: 'arrival',
                    title: 'Payment on Arrival',
                    subtitle: 'Pay when you check in at the hotel',
                    icon: Icons.location_on,
                  ),

                  _buildPaymentMethod(
                    value: 'transfer',
                    title: 'Bank Transfer',
                    subtitle: 'Transfer directly to hotel account',
                    icon: Icons.account_balance,
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(20),
            child: CustomButton(
              ontap: _isProcessing ? null : _confirmBooking,
              data: _isProcessing ? 'Processing...' : 'Confirm Booking',
              textcolor: Colors.white,
              backgroundcolor: _isProcessing ? Colors.grey : Color(0xFF0A3D62),
              width: double.infinity,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}