import 'package:flutter/material.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<Map<String, dynamic>> hotels = [
    {
      'name': 'Grand Plaza Hotel',
      'location': 'Victoria Island, Lagos',
      'rating': 4.8,
      'price': 85000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Luxury Suites Abuja',
      'location': 'Maitama, Abuja',
      'rating': 4.6,
      'price': 75000,
      'image': 'assets/images/1.png',
    },
    {
      'name': 'Ocean View Resort',
      'location': 'Lekki, Lagos',
      'rating': 4.9,
      'price': 120000,
      'image': 'assets/images/2.png',
    },
    {
      'name': 'City Center Inn',
      'location': 'Ikeja, Lagos',
      'rating': 4.3,
      'price': 45000,
      'image': 'assets/images/3.png',
    },
    {
      'name': 'Presidential Villa',
      'location': 'Asokoro, Abuja',
      'rating': 4.7,
      'price': 95000,
      'image': 'assets/images/4.png',
    },
    {
      'name': 'Boutique Hotel Lagos',
      'location': 'Ikoyi, Lagos',
      'rating': 4.5,
      'price': 68000,
      'image': 'assets/images/5.png',
    },
    {
      'name': 'Garden Paradise',
      'location': 'Garki, Abuja',
      'rating': 4.4,
      'price': 55000,
      'image': 'assets/images/6.png',
    },
    {
      'name': 'Skyline Tower Hotel',
      'location': 'Maryland, Lagos',
      'rating': 4.6,
      'price': 78000,
      'image': 'assets/images/1.png',
    },
    {
      'name': 'Royal Court Suites',
      'location': 'Wuse 2, Abuja',
      'rating': 4.8,
      'price': 89000,
      'image': 'assets/images/2.png',
    },
    {
      'name': 'Beachfront Resort',
      'location': 'Ajah, Lagos',
      'rating': 4.2,
      'price': 65000,
      'image': 'assets/images/raddison.png',
    },
  ];

// Replace your _buildHotelCard method with this updated version:

Widget _buildHotelCard(Map<String, dynamic> hotel, int index) {
  return Container(
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
        // Hotel Image
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  hotel['image'],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.hotel,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              // Bookmark icon in top right
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.bookmark,
                      color: Color(0xFF0A3D62),
                      size: 18,
                    ),
                    onPressed: () {
                      // Remove from bookmarks functionality
                      setState(() {
                        hotels.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Removed from bookmarks'),
                          backgroundColor: Color(0xFF0A3D62),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hotel Details
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel name
                    Text(
                      hotel['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    
                    // Location
                    Text(
                      hotel['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                
                
                // Rating and Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 2),
                        Text(
                          '${hotel['rating']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    
                    // Price
                    Text(
                      "₦${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3D62),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: TextStyle(color: Lodgix.getTextColor(context)),
        ),
      ),
      body:
          hotels.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No bookmarks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start exploring and save your favorite hotels',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                          '${hotels.length} saved hotels',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hotels List
                  Expanded(
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75, // Adjust this to control card height
                      ),
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        return _buildHotelCard(hotels[index], index);
                      },
                    ),
                  ),
                ],
              ),

      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
