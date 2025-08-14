import 'package:flutter/material.dart';

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
      reviews: 0, // Default since your map doesn't include reviews
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }
}

// Keep your list of hotel maps
List<Map<String, dynamic>> hotelsData = [
  // Your existing hotel data
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

class HotelSearchScreen extends StatefulWidget {
  final List<Hotel> hotels;

  // Remove const and fix the constructor
  const HotelSearchScreen({
    super.key,
    this.hotels = const [],
  });

  // Add a factory constructor to handle the default conversion
  factory HotelSearchScreen.withDefaultHotels({Key? key}) {
    return HotelSearchScreen(
      key: key,
      hotels: hotelsData.map((map) => Hotel.fromMap(map)).toList(),
    );
  }

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  int _selectedFilter = 0;

  final List<String> filters = [
    'All Hotels',
    'Recommended',
    'Trending',
    'Top Rated',
    'Budget'
  ];

  List<Hotel> get _filtered {
    // This is the part that had the error
    List<Hotel> list = widget.hotels.where((h) {
      final q = _query.toLowerCase();
      return h.name.toLowerCase().contains(q) ||
          h.city.toLowerCase().contains(q) ||
          h.country.toLowerCase().contains(q);
    }).toList();

    // Adjust price filter ranges based on your actual price scale
    // Your prices are in thousands (₦85000) while the filter checks for 30-60
    switch (_selectedFilter) {
      case 1: // Recommended (example: rating >= 4.5)
        list = list.where((h) => h.rating >= 4.7).toList();
        break;
      case 2: // Trending (adjust for your price range)
        list = list.where((h) => h.price >= 50000 && h.price <= 90000).toList();
        break;
      case 3: // Top Rated (rating >= 4.7)
        list = list.where((h) => h.rating >= 4.7).toList();
        break;
      case 4: // Budget (adjust for your price range)
        list = list.where((h) => h.price < 70000).toList();
        break;
      default:
    }
    return list;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: List.generate(filters.length, (i) {
          final selected = i == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                filters[i],
                style: TextStyle(
                  color: selected ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              selected: selected,
              selectedColor: primaryColor,
              backgroundColor: primaryColor.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected ? primaryColor : primaryColor.withOpacity(.4),
                ),
              ),
              onSelected: (_) {
                setState(() => _selectedFilter = i);
              },
            ),
          );
        }),
      ),
    );
  }

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
                icon: Icon(Icons.bookmark_border,
                    color: primaryColor.withOpacity(.7), size: 22),
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
    final results = _filtered;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(.2)),
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              cursorColor: primaryColor,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, color: primaryColor),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                hintText: 'Search hotels',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterChips(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Text(
              'Total Results (${results.length})',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) => _buildHotelTile(results[i]),
            ),
          ),
        ],
      ),
    );
  }
}