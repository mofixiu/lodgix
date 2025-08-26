import 'package:flutter/material.dart';
import 'package:lodgix/screens/bookmarks.dart';
import 'package:lodgix/screens/payment.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/providers/booking_provider.dart'; // Add this import
import 'package:provider/provider.dart';
  
const primaryColor = Color(0xFF0A3D62);

class Hotel {
  final String name;
  final String city;
  final String country;
  final double rating;
  final int reviews;
  final double price;
  final String image;
  final String? status;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? paymentStatus;
  final int? bookingId;

  Hotel({
    required this.name,
    required this.city,
    required this.country,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
    this.status,
    this.checkInDate,
    this.checkOutDate,
    this.paymentStatus,
    this.bookingId,
  });

  // Factory constructor to convert from database booking data
  factory Hotel.fromBookingData(Map<String, dynamic> data) {
    // Add comprehensive debugging
    print('=== HOTEL DATA DEBUG ===');
    print('Raw booking data: $data');
    print('total_amount: ${data['total_amount']} (${data['total_amount'].runtimeType})');
    print('hotel_name: ${data['hotel_name']}');
    print('hotel_city: ${data['hotel_city']}');
    print('hotel_country: ${data['hotel_country']}');
    print('hotel_rating: ${data['hotel_rating']}');
    print('hotel_image: ${data['hotel_image']}');
    print('status: ${data['status']}');
    print('payment_status: ${data['payment_status']}');
    print('========================');

    // Parse dates
    DateTime? checkIn, checkOut;
    try {
      if (data['check_in_date'] != null) {
        checkIn = DateTime.parse(data['check_in_date'].toString());
      }
      if (data['check_out_date'] != null) {
        checkOut = DateTime.parse(data['check_out_date'].toString());
      }
    } catch (e) {
      print('Error parsing dates: $e');
    }

    // Better price parsing
    double price = 0.0;
    try {
      // Try multiple possible price fields
      if (data['total_amount'] != null) {
        price = (data['total_amount'] as num).toDouble();
        print('Using total_amount: $price');
      } else if (data['hotel_price'] != null) {
        price = (data['hotel_price'] as num).toDouble();
        print('Using hotel_price: $price');
      } else if (data['room_price'] != null) {
        price = (data['room_price'] as num).toDouble();
        print('Using room_price: $price');
      } else if (data['price'] != null) {
        price = (data['price'] as num).toDouble();
        print('Using price: $price');
      }
      print('Final price: $price');
    } catch (e) {
      print('Error parsing price: $e');
      price = 0.0;
    }

    return Hotel(
      name: data['hotel_name'] ?? data['name'] ?? 'Unknown Hotel',
      city: data['hotel_city'] ?? data['city'] ?? 'Unknown',
      country: data['hotel_country'] ?? data['country'] ?? 'Nigeria',
      rating: (data['hotel_rating'] as num?)?.toDouble() ?? 4.5,
      reviews: 2830, // Default since not in database
      price: price, // Use the properly parsed price
      image: data['hotel_image'] ?? data['image'] ?? 'assets/images/raddison.png',
      status: data['status'],
      checkInDate: checkIn,
      checkOutDate: checkOut,
      paymentStatus: data['payment_status'],
      bookingId: data['id'],
    );
  }

  // Factory constructor for local data (backward compatibility)
  factory Hotel.fromMap(Map<String, dynamic> map) {
    final locationParts = map['location']?.toString().split(', ') ?? [];
    final city = locationParts.isNotEmpty ? locationParts[0] : '';
    final country = locationParts.length > 1 ? locationParts[1] : 'Nigeria';

    return Hotel(
      name: map['name'] ?? '',
      city: city,
      country: country,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: 2830,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }
}

class Booked extends StatefulWidget {
  const Booked({super.key});

  @override
  State<Booked> createState() => _BookedState();
}

class _BookedState extends State<Booked> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    print('=== BOOKED SCREEN DEBUG ===');
    print('User logged in: ${userProvider.isLoggedIn}');
    print('User ID: ${userProvider.userId}');
    print('Bookings already loaded: ${bookingProvider.hasInitialized}');
    print('Current bookings count: ${bookingProvider.bookings.length}');
    print('=========================');

    if (userProvider.isLoggedIn && userProvider.userId != null) {
      // Only load if not already initialized or if we have no data
      if (!bookingProvider.hasInitialized || bookingProvider.bookings.isEmpty) {
        await bookingProvider.loadBookings(userProvider.userId!);
      }
    } else {
      print('User not logged in, loading local bookings only');
      // For non-logged in users, still try to load local bookings
      final localBookings = BookedHotelsManager.getBookedHotels();
      print('Local bookings found: ${localBookings.length}');
    }
  }

  String _formatReviews(int reviews) {
    if (reviews >= 1000) {
      return '${(reviews / 1000).toStringAsFixed(1)}k';
    }
    return reviews.toString();
  }

  Color _getStatusColorValue(String? status) {
    switch (status?.toLowerCase()) {
      case 'booked':
        return Colors.blue;
      case 'checked-in':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildHotelTile(Hotel h) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  h.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    color: primaryColor.withOpacity(.1),
                    child: const Icon(Icons.hotel, color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            h.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (h.status != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColorValue(h.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColorValue(h.status),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              h.status!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColorValue(h.status),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${h.city}, ${h.country}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${h.rating.toStringAsFixed(1)} (${_formatReviews(h.reviews)} reviews)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦${h.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Booking dates if available
          if (h.checkInDate != null && h.checkOutDate != null) ...[
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${h.checkInDate!.day}/${h.checkInDate!.month}/${h.checkInDate!.year}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-out',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${h.checkOutDate!.day}/${h.checkOutDate!.month}/${h.checkOutDate!.year}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (h.paymentStatus != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        h.paymentStatus!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: h.paymentStatus == 'Paid' ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmarks_rounded, color: Lodgix.getTextColor(context)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Bookmarks()));
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Lodgix.getTextColor(context)),
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
              if (userProvider.isLoggedIn && userProvider.userId != null) {
                bookingProvider.refreshBookings(userProvider.userId!);
              }
            },
          ),
        ],
        centerTitle: false,
        title: Text(
          "Recently Booked",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Lodgix.getTextColor(context),
          ),
        ),
      ),
      body: Consumer2<UserProvider, BookingProvider>(
        builder: (context, userProvider, bookingProvider, child) {
          // Add debug logging
          print('=== BUILD DEBUG ===');
          print('User logged in: ${userProvider.isLoggedIn}');
          print('User ID: ${userProvider.userId}');
          print('Provider loading: ${bookingProvider.isLoading}');
          print('Provider initialized: ${bookingProvider.hasInitialized}');
          print('Provider bookings count: ${bookingProvider.bookings.length}');
          print('Provider error: ${bookingProvider.errorMessage}');
          print('==================');

          // Don't call async methods during build - check if we need to load data
          if (userProvider.isLoggedIn && 
              userProvider.userId != null && 
              !bookingProvider.hasInitialized &&
              !bookingProvider.isLoading) {
            // Schedule loading for after this build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !bookingProvider.hasInitialized) {
                bookingProvider.loadBookings(userProvider.userId!);
              }
            });
          }

          // Handle not logged in case
          if (!userProvider.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please log in to view bookings',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Convert booking data to Hotel objects
          final bookingsList = bookingProvider.bookings
              .map((data) => Hotel.fromBookingData(data))
              .toList();
              
          print('Converted hotels count: ${bookingsList.length}');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookingProvider.errorMessage != null)
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bookingProvider.errorMessage!,
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              
              Expanded(
                child: bookingProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      )
                    : bookingsList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hotel_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No bookings yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start booking hotels to see them here',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (userProvider.isLoggedIn && userProvider.userId != null) {
                                      bookingProvider.refreshBookings(userProvider.userId!);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                  ),
                                  child: Text(
                                    'Refresh',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              // Header with count
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Text(
                                      '${bookingsList.length} booking${bookingsList.length == 1 ? '' : 's'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Bookings List
                              Expanded(
                                child: ListView.builder(
                                  itemCount: bookingsList.length,
                                  itemBuilder: (_, i) => _buildHotelTile(bookingsList[i]),
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}