import 'package:flutter/material.dart';
import 'package:lodgix/screens/bookmarks.dart';
import 'package:lodgix/screens/payment.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';
  
const primaryColor = Color(0xFF0A3D62);

class Hotel {
  final String name;
  final String city;
  final String country;
  final double rating;
  final int reviews;
  final double price;
  final String image;

  Hotel({
    required this.name,
    required this.city,
    required this.country,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
  });

  // Factory constructor to convert from Map to Hotel object
  factory Hotel.fromMap(Map<String, dynamic> map) {
    // Extract city and country from location string (e.g., "Victoria Island, Lagos")
    final locationParts = map['location'].toString().split(', ');
    final city = locationParts.isNotEmpty ? locationParts[0] : '';
    final country = locationParts.length > 1 ? locationParts[1] : 'Nigeria';

    return Hotel(
      name: map['name'] ?? '',
      city: city,
      country: country,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: 2830, // Default since your map doesn't include reviews
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
  List<Map<String, dynamic>> get hotelsData {
    // Get booked hotels from the manager and combine with sample data
    List<Map<String, dynamic>> bookedHotels = BookedHotelsManager.getBookedHotels();
    
    // If no booked hotels, show sample data
    if (bookedHotels.isEmpty) {
      return [
        {
          'name': 'No bookings yet',
          'location': 'Start booking hotels to see them here',
          'rating': 0.0,
          'price': 0,
          'image': 'assets/images/raddison.png',
        },
      ];
    }
    
    return bookedHotels;
  }

  // Convert hotel data to Hotel objects
  List<Hotel> get hotels => hotelsData.map((map) => Hotel.fromMap(map)).toList();

  Widget _buildHotelTile(Hotel h) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
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
                Text(
                  h.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
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
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${h.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.bookmark,
                    color: primaryColor, size: 22), // Changed to filled bookmark since these are booked
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatReviews(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.bookmarks_rounded, color: Lodgix.getTextColor(context)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Bookmarks()));
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (_, i) => _buildHotelTile(hotels[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}