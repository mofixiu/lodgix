import 'package:flutter/material.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/providers/hotel_provider.dart';
import 'package:lodgix/screens/bookmarks.dart';
import 'package:lodgix/screens/hotel_details.dart';
import 'package:lodgix/screens/hotel_search_screen.dart';
import 'package:lodgix/screens/login.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Use the safer initialization method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHotels();
    });
  }

  void _checkLoginStatus() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    print('=== DASHBOARD LOGIN CHECK ===');
    print('Is logged in: ${userProvider.isLoggedIn}');
    print('Username: ${userProvider.username}');
    print('Email: ${userProvider.email}');
    print('Full Name: ${userProvider.fullName}');
    print('Token: ${userProvider.token}');
    print('===========================');

    if (!userProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    }
  }

  // Safe hotel initialization method
  void _initializeHotels() {
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
    hotelProvider.initializeHotels();
  }

  // Refresh hotels (force reload)
  Future<void> _refreshHotels() async {
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
    await hotelProvider.refreshHotels();
  }

  List<Map<String, dynamic>> cities = [
    {'name': 'Lagos', 'image': 'assets/images/city.png'},
    {'name': 'Abuja', 'image': 'assets/images/city.png'},
    {'name': 'Port Harcourt', 'image': 'assets/images/city.png'},
    {'name': 'Ibadan', 'image': 'assets/images/city.png'},
    {'name': 'Enugu', 'image': 'assets/images/city.png'},
    {'name': 'Calabar', 'image': 'assets/images/city.png'},
    {'name': 'Kano', 'image': 'assets/images/city.png'},
    {'name': 'Owerri', 'image': 'assets/images/city.png'},
    {'name': 'Benin City', 'image': 'assets/images/city.png'},
    {'name': 'Abeokuta', 'image': 'assets/images/city.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      body: Consumer<HotelProvider>(
        builder: (context, hotelProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshHotels,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '   Current Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(width: 7),
                                Icon(Icons.location_on, color: Colors.black),
                                SizedBox(width: 5),
                                Text(
                                  'Lagos, Nigeria',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 7),
                                Text('👨', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 5),
                                Text(
                                  userProvider.fullName.isNotEmpty
                                      ? userProvider.fullName
                                      : 'Guest User',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.notifications),
                                color: Lodgix.getButtonColor(context),
                                iconSize: 30,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Bookmarks(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.bookmark),
                                color: Lodgix.getButtonColor(context),
                                iconSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelSearchScreen.withDefaultHotels(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Search hotel, location etc",
                                  style: TextStyle(
                                    color: Lodgix.getButtonColor(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Lodgix.getButtonColor(context),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hotels Near you',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HotelSearchScreen.withDefaultHotels(),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF0A3D62),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    
                    // Hotels Near You Section - Using Provider Data
                    _buildHotelSection(
                      hotels: hotelProvider.nearbyHotels,
                      isLoading: hotelProvider.isLoadingHotels,
                      errorMessage: hotelProvider.errorMessage,
                      emptyMessage: 'No hotels found',
                      emptyIcon: Icons.hotel_outlined,
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore by City',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF0A3D62),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildCitySection(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Highest Rated Hotels',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HotelSearchScreen.withDefaultHotels(),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF0A3D62),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    
                    // Highest Rated Hotels Section - Using Provider Data
                    _buildHotelSection(
                      hotels: Provider.of<HotelProvider>(context).highestRatedHotels,
                      isLoading: Provider.of<HotelProvider>(context).isLoadingHotels,
                      errorMessage: Provider.of<HotelProvider>(context).errorMessage,
                      emptyMessage: 'No rated hotels found',
                      emptyIcon: Icons.star_border,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  // Helper method to build hotel sections
  Widget _buildHotelSection({
    required List<Map<String, dynamic>> hotels,
    required bool isLoading,
    String? errorMessage,
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    if (isLoading) {
      return Container(
        height: 235,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A3D62)),
          ),
        ),
      );
    }

    if (hotels.isEmpty) {
      return Container(
        height: 235,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon,
                size: 50,
                color: Colors.grey[400],
              ),
              SizedBox(height: 10),
              Text(
                errorMessage ?? emptyMessage,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: _refreshHotels,
                child: Text(
                  'Tap to refresh',
                  style: TextStyle(
                    color: Color(0xFF0A3D62),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return _buildHotelCard(hotel);
        },
      )
    );
  }

  // Helper method to build individual hotel cards
  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetails(
              hotelName: hotel['name'] ?? 'Unknown Hotel',
              location: hotel['location'] ?? 'Unknown Location',
              price: (hotel['price_per_night'] ?? hotel['price'] ?? 75000).toInt(),
              rating: (hotel['rating'] ?? 4.5).toDouble(),
              image: hotel['hotel_image'] ?? hotel['image'] ?? 'assets/images/raddison.png',
              hotelId: hotel['id'], // Make sure this is an int, not a String
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                height: 128,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(hotel['hotel_image'] ?? hotel['image'] ?? 'assets/images/raddison.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 13.0,
                right: 13.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'] ?? 'Unknown Hotel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    hotel['location'] ?? 'Unknown Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "₦${(hotel['price_per_night'] ?? hotel['price'] ?? 75000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A3D62),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: 23,
                        width: 43,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${(hotel['rating'] ?? 4.5).toStringAsFixed(1)}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
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
    );
  }

  // Helper method to build city section
  Widget _buildCitySection() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return GestureDetector(
            onTap: () async {
              // Use provider method for city hotels
              final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
              final cityHotels = await hotelProvider.getHotelsByCity(city['name']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelSearchScreen(
                    hotels: cityHotels.map((hotel) => Hotel.fromMap(hotel)).toList(),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(city['image']),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    city['name'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
