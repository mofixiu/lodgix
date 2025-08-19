import 'package:flutter/material.dart';
import 'package:lodgix/screens/payment.dart';
import 'package:lodgix/widgets/customButton.dart';

class DateSelect extends StatefulWidget {
  final String hotelName;
  final String location;
  final int price;
  final double rating;
  final String image;

  const DateSelect({
    super.key,
    required this.hotelName,
    required this.location,
    required this.price,
    required this.rating,
    required this.image,
  });

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int guests = 1;
  int rooms = 1;
  bool isManualRoomChange = false; // Track if user manually changed rooms

  // Calculate minimum required rooms based on guests (2 guests per room)
  int get minimumRoomsRequired {
    return ((guests + 1) / 2).ceil(); // 2 guests per room, round up
  }

  // Auto-adjust rooms when guests change
  void _updateGuestsAndRooms(int newGuests) {
    setState(() {
      guests = newGuests;
      
      // Only auto-adjust rooms if user hasn't manually set them
      if (!isManualRoomChange) {
        rooms = minimumRoomsRequired;
      } else {
        // Ensure rooms is at least the minimum required
        if (rooms < minimumRoomsRequired) {
          rooms = minimumRoomsRequired;
        }
      }
    });
  }

  // Manual room change
  void _updateRooms(int newRooms) {
    setState(() {
      isManualRoomChange = true;
      rooms = newRooms;
    });
  }

  // Calculate total price
  double get totalPrice {
    if (checkInDate != null && checkOutDate != null) {
      int nights = checkOutDate!.difference(checkInDate!).inDays;
      return widget.price * nights * rooms.toDouble();
    }
    return 0.0;
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
          'Select Date',
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
                  // Check-in Date
                  Text(
                    'Check-in Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF0A3D62),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          checkInDate = picked;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Color(0xFF0A3D62),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            checkInDate != null
                                ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                                : 'Select check-in date',
                            style: TextStyle(
                              fontSize: 16,
                              color: checkInDate != null ? Colors.black87 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Check-out Date
                  Text(
                    'Check-out Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: checkInDate?.add(Duration(days: 1)) ?? DateTime.now().add(Duration(days: 1)),
                        firstDate: checkInDate?.add(Duration(days: 1)) ?? DateTime.now().add(Duration(days: 1)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF0A3D62),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          checkOutDate = picked;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Color(0xFF0A3D62),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            checkOutDate != null
                                ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                                : 'Select check-out date',
                            style: TextStyle(
                              fontSize: 16,
                              color: checkOutDate != null ? Colors.black87 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Guests & Rooms Section
                  Text(
                    'Guests & Rooms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Guests Counter
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Guests',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Number of guests (2 per room)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (guests > 1) {
                                  _updateGuestsAndRooms(guests - 1);
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF0A3D62)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xFF0A3D62),
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '$guests',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _updateGuestsAndRooms(guests + 1);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFF0A3D62),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Rooms Counter
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rooms',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Minimum ${minimumRoomsRequired} room${minimumRoomsRequired > 1 ? 's' : ''} required',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (rooms > minimumRoomsRequired) {
                                  _updateRooms(rooms - 1);
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: rooms > minimumRoomsRequired 
                                        ? Color(0xFF0A3D62) 
                                        : Colors.grey[400]!,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: rooms > minimumRoomsRequired 
                                      ? Color(0xFF0A3D62) 
                                      : Colors.grey[400],
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '$rooms',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _updateRooms(rooms + 1);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFF0A3D62),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Auto room calculation info
                  if (guests > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF0A3D62).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF0A3D62).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF0A3D62),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Rooms auto-adjusted for $guests guests (2 guests per room)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0A3D62),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  SizedBox(height: 40),
                  
                  // Summary Section with calculated price
                  if (checkInDate != null && checkOutDate != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF0A3D62).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Check-in:', style: TextStyle(color: Colors.grey[600])),
                              Text('${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Check-out:', style: TextStyle(color: Colors.grey[600])),
                              Text('${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration:', style: TextStyle(color: Colors.grey[600])),
                              Text('${checkOutDate!.difference(checkInDate!).inDays} nights'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Guests:', style: TextStyle(color: Colors.grey[600])),
                              Text('$guests guest${guests > 1 ? 's' : ''}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rooms:', style: TextStyle(color: Colors.grey[600])),
                              Text('$rooms room${rooms > 1 ? 's' : ''}'),
                            ],
                          ),
                          Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Price:', style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              )),
                              Text(
                                '₦${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A3D62),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Bottom Button
          Container(
            padding: EdgeInsets.all(20),
            child: CustomButton(
              ontap: () {
                if (checkInDate != null && checkOutDate != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payment(
                        hotelName: widget.hotelName,
                        location: widget.location,
                        checkInDate: checkInDate!,
                        checkOutDate: checkOutDate!,
                        guests: guests,
                        rooms: rooms,
                        totalPrice: totalPrice,
                        image: widget.image,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select check-in and check-out dates'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              data: 'Continue to Payment',
              textcolor: Colors.white,
              backgroundcolor: Color(0xFF0A3D62),
              width: double.infinity,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}