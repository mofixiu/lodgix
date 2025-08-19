import 'package:flutter/material.dart';
import 'package:lodgix/providers/user_provider.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Debug: Print user data
    print('=== DASHBOARD LOGIN CHECK ===');
    print('Is logged in: ${userProvider.isLoggedIn}');
    print('Username: ${userProvider.username}');
    print('Email: ${userProvider.email}');
    print('Full Name: ${userProvider.fullName}');
    print('Token: ${userProvider.token}');
    print('===========================');

    if (!userProvider.isLoggedIn) {
      // Redirect to login if not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
              SizedBox(height: 10),
              SizedBox(
                height: 235,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HotelDetails(
                                  hotelName: hotel['name'],
                                  location: hotel['location'],
                                  price: hotel['price'],
                                  rating: hotel['rating'],
                                  image: hotel['image'],
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
                                    image: AssetImage(hotel['image']),
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
                                    hotel['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    hotel['location'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "₦${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0A3D62),
                                        ),
                                      ),
                                      Spacer(),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${hotel['rating']}/5',
                                            style: TextStyle(fontSize: 14),
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
                  },
                ),
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
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return Column(
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
                        Text(
                          city['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
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
              SizedBox(height: 10),
              SizedBox(
                height: 235,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HotelDetails(
                                  hotelName: hotel['name'],
                                  location: hotel['location'],
                                  price: hotel['price'],
                                  rating: hotel['rating'],
                                  image: hotel['image'],
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
                                    image: AssetImage(hotel['image']),
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
                                    hotel['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    hotel['location'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "₦${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
                                      Spacer(),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${hotel['rating']}/5',
                                            style: TextStyle(fontSize: 14),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
