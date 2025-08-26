import 'package:flutter/material.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/providers/bookmark_provider.dart'; // Add this import
import 'package:lodgix/screens/hotel_details.dart';
import 'package:provider/provider.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookmarks();
    });
  }

  Future<void> _loadBookmarks() async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
    
    print('=== BOOKMARKS LOADING DEBUG ===');
    print('User logged in: ${userProvider.isLoggedIn}');
    print('User ID from provider: ${userProvider.userId}');
    print('Bookmarks already loaded: ${bookmarkProvider.hasInitialized}');
    print('==============================');

    if (userProvider.isLoggedIn && userProvider.userId != null) {
      // Load bookmarks using provider
      await bookmarkProvider.loadBookmarks(userProvider.userId!);
    } else {
      print('User not logged in, showing empty bookmarks');
    }
  }

  Future<void> _removeBookmark(int bookmarkId, int index) async {
    if (!mounted) return;

    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A3D62)),
          ),
        ),
      );

      final success = await bookmarkProvider.removeBookmark(bookmarkId: bookmarkId);

      // Close loading dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed from bookmarks'),
              backgroundColor: Color(0xFF0A3D62),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove bookmark'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      print('Error removing bookmark: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while removing bookmark'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetails(
              hotelName: hotel['hotel_name'] ?? hotel['name'] ?? 'Unknown Hotel',
              location: hotel['hotel_location'] ?? hotel['location'] ?? 'Unknown Location',
              price: (hotel['hotel_price'] ?? hotel['price'] ?? 0).toInt(),
              rating: (hotel['hotel_rating'] ?? hotel['rating'] ?? 0.0).toDouble(),
              image: hotel['hotel_image'] ?? hotel['image'] ?? 'assets/images/raddison.png',
              hotelId: hotel['hotel_id'],
            ),
          ),
        ).then((_) {
          // Refresh bookmarks when returning (only if needed)
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
          if (userProvider.isLoggedIn && userProvider.userId != null) {
            bookmarkProvider.refreshBookmarks(userProvider.userId!);
          }
        });
      },
      child: Container(
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
                      hotel['hotel_image'] ?? hotel['image'] ?? 'assets/images/raddison.png',
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
                          _removeBookmark(hotel['id'], index);
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
                          hotel['hotel_name'] ?? hotel['name'] ?? 'Unknown Hotel',
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
                          hotel['hotel_location'] ?? hotel['location'] ?? 'Unknown Location',
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
                              '${(hotel['hotel_rating'] ?? hotel['rating'] ?? 4.5)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        
                        // Price
                        Text(
                          "₦${(hotel['hotel_price'] ?? hotel['price'] ?? 0).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per night",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A3D62),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Bookmarks',
          style: TextStyle(color: Lodgix.getTextColor(context)),
        ),
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              if (bookmarkProvider.hasBookmarks) {
                return IconButton(
                  onPressed: () {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    if (userProvider.isLoggedIn && userProvider.userId != null) {
                      bookmarkProvider.refreshBookmarks(userProvider.userId!);
                    }
                  },
                  icon: Icon(Icons.refresh),
                  tooltip: 'Refresh',
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, BookmarkProvider>(
        builder: (context, userProvider, bookmarkProvider, child) {
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
                    'Please log in to view bookmarks',
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

          return bookmarkProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A3D62)),
                  ),
                )
              : bookmarkProvider.bookmarks.isEmpty
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
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (userProvider.userId != null) {
                                bookmarkProvider.refreshBookmarks(userProvider.userId!);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A3D62),
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
                                '${bookmarkProvider.bookmarkCount} saved hotel${bookmarkProvider.bookmarkCount == 1 ? '' : 's'}',
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
                              childAspectRatio: 0.75,
                            ),
                            itemCount: bookmarkProvider.bookmarks.length,
                            itemBuilder: (context, index) {
                              return _buildHotelCard(bookmarkProvider.bookmarks[index], index);
                            },
                          ),
                        ),
                      ],
                    );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
