import 'package:flutter/material.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';

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

  void _handleSearch() {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      print("Searching for: $searchQuery");
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
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Ocean View Resort',
      'location': 'Lekki, Lagos',
      'rating': 4.9,
      'price': 120000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'City Center Inn',
      'location': 'Ikeja, Lagos',
      'rating': 4.3,
      'price': 45000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Presidential Villa',
      'location': 'Asokoro, Abuja',
      'rating': 4.7,
      'price': 95000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Boutique Hotel Lagos',
      'location': 'Ikoyi, Lagos',
      'rating': 4.5,
      'price': 68000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Garden Paradise',
      'location': 'Garki, Abuja',
      'rating': 4.4,
      'price': 55000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Skyline Tower Hotel',
      'location': 'Maryland, Lagos',
      'rating': 4.6,
      'price': 78000,
      'image': 'assets/images/raddison.png',
    },
    {
      'name': 'Royal Court Suites',
      'location': 'Wuse 2, Abuja',
      'rating': 4.8,
      'price': 89000,
      'image': 'assets/images/raddison.png',
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        " Current Location",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Lodgix.getTextColor(context),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
          
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Lodgix.getButtonColor(context),
                            size: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                          Text(
                            "Lagos, Nigeria",
                            style: TextStyle(
                              fontSize: 14,
                              color: Lodgix.getButtonColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          
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
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          
              Container(
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
                child: TextField(
                  // onTap: (){},
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search hotel, location etc",
                    hintStyle: TextStyle(
                      color: Lodgix.getButtonColor(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Lodgix.getButtonColor(context),
                      size: 24,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  onSubmitted: (value) => _handleSearch(),
                  textInputAction: TextInputAction.search,
                ),
              ),
          
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hotels Near You",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Lodgix.getTextColor(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all hotels screen
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: Lodgix.getButtonColor(context),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(hotels.length, (index) {
                    final hotel = hotels[index];
                    return Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 16),
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
                      child: InkWell(
                        onTap: () {
                          print("Selected hotel: ${hotel['name']}");
                          // Navigate to hotel details
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                  bottom: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  hotel['image'],
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 140,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.hotel,
                                        size: 40,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
          
                            // Content with padding
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hotel Name
                                  Text(
                                    hotel['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
          
                                  // Location
                                  Text(
                                    hotel['location'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
          
                                  // Price and Rating
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₦${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
          
                                      // Rating
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            child: Text(
                                              "${hotel['rating']}/5",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  }),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore by City",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Lodgix.getTextColor(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: Lodgix.getButtonColor(context),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(cities.length, (index) {
                    final city = cities[index];
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(city['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            city['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Highest Rated Hotels",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Lodgix.getTextColor(context),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: Lodgix.getButtonColor(context),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(hotels.length, (index) {
                    final hotel = hotels[index];
                    return Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 16),
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
                      child: InkWell(
                        onTap: () {
                          print("Selected hotel: ${hotel['name']}");
                          // Navigate to hotel details
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                  bottom: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  hotel['image'],
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 140,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.hotel,
                                        size: 40,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
          
                            // Content with padding
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hotel Name
                                  Text(
                                    hotel['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
          
                                  // Location
                                  Text(
                                    hotel['location'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
          
                                  // Price and Rating
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₦${hotel['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
          
                                      // Rating
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            child: Text(
                                              "${hotel['rating']}/5",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0,),
    );
  }
}
