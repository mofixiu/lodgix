import 'package:flutter/material.dart';
import 'package:lodgix/screens/DateSelect.dart';
import 'package:lodgix/widgets/customButton.dart';
// import 'package:lodgix/services/bookmark_service.dart';
// import 'package:lodgix/services/user_session.dart';
import 'package:lodgix/providers/user_provider.dart'; // Add this import
import 'package:provider/provider.dart'; // Add this import
import 'package:lodgix/providers/bookmark_provider.dart';

class HotelDetails extends StatefulWidget {
  final String hotelName;
  final String location;
  final int price;
  final double rating;
  final String image;
  final int? hotelId;

  const HotelDetails({
    super.key,
    required this.hotelName,
    required this.location,
    required this.price,
    required this.rating,
    required this.image,
    this.hotelId,
  });

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  bool isInteriorSelected = true;
  int currentImageIndex = 1;
  int totalImages = 7;
  bool isFavorited = false;
  bool isLoadingFavorite = false;
  int? currentBookmarkId;

  // Your existing text variables...
  String text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  String text2 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.';
  String get _fullText => text2;
  String get _shortText => text;
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    // Delay the bookmark check to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBookmarkStatus();
    });
  }

  // Check if this hotel is already bookmarked - UPDATED VERSION
  Future<void> _checkBookmarkStatus() async {
    if (!mounted) return;
    
    if (widget.hotelId == null) return;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
      
      if (!userProvider.isLoggedIn || userProvider.userId == null) {
        return;
      }

      // Load bookmarks if not already loaded
      if (!bookmarkProvider.hasInitialized) {
        await bookmarkProvider.loadBookmarks(userProvider.userId!);
      }

      // Check if this hotel is bookmarked
      final isBookmarked = bookmarkProvider.isHotelBookmarked(widget.hotelId!);
      final bookmarkId = bookmarkProvider.getBookmarkId(widget.hotelId!);
      
      if (mounted) {
        setState(() {
          isFavorited = isBookmarked;
          currentBookmarkId = bookmarkId;
        });
      }
    } catch (e) {
      print('Error checking bookmark status: $e');
    }
  }

  // Toggle favorite status - UPDATED VERSION
  Future<void> _toggleFavorite() async {
    if (!mounted) return;
    
    if (widget.hotelId == null) {
      _showSnackBar('Hotel ID not available', isError: true);
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn || userProvider.userId == null) {
      _showSnackBar('Please log in to bookmark hotels', isError: true);
      return;
    }

    final userId = userProvider.userId!;

    if (mounted) {
      setState(() {
        isLoadingFavorite = true;
      });
    }

    try {
      bool success = false;
      
      if (isFavorited && currentBookmarkId != null) {
        // Remove bookmark
        success = await bookmarkProvider.removeBookmark(
          bookmarkId: currentBookmarkId!,
          hotelId: widget.hotelId!,
        );
        
        if (success) {
          if (mounted) {
            setState(() {
              isFavorited = false;
              currentBookmarkId = null;
            });
          }
          _showSnackBar('Removed from bookmarks');
        } else {
          _showSnackBar('Failed to remove bookmark', isError: true);
        }
      } else {
        // Add bookmark
        success = await bookmarkProvider.addBookmark(
          hotelId: widget.hotelId!,
          guestId: userId,
        );

        if (success) {
          final newBookmarkId = bookmarkProvider.getBookmarkId(widget.hotelId!);
          if (mounted) {
            setState(() {
              isFavorited = true;
              currentBookmarkId = newBookmarkId;
            });
          }
          _showSnackBar('Added to bookmarks');
        } else {
          _showSnackBar('Failed to add bookmark', isError: true);
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      _showSnackBar('An error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoadingFavorite = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // Check before showing SnackBar
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Hotel Image Section
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Back button and action buttons
                      Positioned(
                        top: 50,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.share,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(8), // Same padding as share icon
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: isLoadingFavorite
                                      ? SizedBox(
                                          width: 20, // Same size as share icon
                                          height: 20, // Same size as share icon
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                          ),
                                        )
                                      : GestureDetector( // Use GestureDetector instead of IconButton
                                          onTap: _toggleFavorite,
                                          child: Icon(
                                            isFavorited ? Icons.favorite : Icons.favorite_border,
                                            color: Colors.red,
                                            size: 20, // Same size as share icon
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Image counter
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '$currentImageIndex/$totalImages',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hotel Details Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel name and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.hotelName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 18),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Price
                      Row(
                        children: [
                          Text(
                            "₦${widget.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A3D62),
                            ),
                          ),
                          const Text(
                            " per night",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Interior/Exterior Toggle
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isInteriorSelected = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isInteriorSelected ? const Color(0xFF0A3D62) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Interior',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isInteriorSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isInteriorSelected = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isInteriorSelected ? const Color(0xFF0A3D62) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Exterior',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isInteriorSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Image Gallery
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final imageNumber = index + 1;
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/$imageNumber.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // About the Hotel section
                      const Text(
                        'About the Hotel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _showMore ? _fullText : _shortText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMore = !_showMore;
                          });
                        },
                        child: Text(
                          _showMore ? 'Read less' : 'Read more',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Details Section
                      Text("Details", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Amenities Grid
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // First Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.wifi,
                                          color: Colors.blue,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Free Wifi",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.pool,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Swimming Pool",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.restaurant,
                                          color: Colors.orange,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Restaurant",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.purple[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.local_parking,
                                          color: Colors.purple,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Parking",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Second Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Gym",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.teal[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.spa,
                                          color: Colors.teal,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Spa",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.indigo[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.room_service,
                                          color: Colors.indigo,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Room Service",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.access_time,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "24-hours Open",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //Map placeholder
                            
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Image.asset(
                                'assets/images/map.png',
                                fit: BoxFit.contain,
                                height: 200,
                                width: double.maxFinite,
                              ),
                            ),
                      const SizedBox(height: 120),
                    ],
                    
                  ),
                ),
              ],
            ),
          ),
          
          // Book Hotel Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateSelect(
                      hotelName: widget.hotelName,
                      location: widget.location,
                      price: widget.price,
                      rating: widget.rating,
                      image: widget.image,
                      hotelId: widget.hotelId, // Add this line to pass the hotel ID
                    ),
                  ),
                );
              },
              data: 'Book Hotel',
              textcolor: Colors.white,
              backgroundcolor: Color(0xFF0A3D62),
              width: double.maxFinite,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
