import 'package:flutter/material.dart';
import 'package:lodgix/services/hotel_service.dart';

class HotelProvider with ChangeNotifier {
  // Hotel data lists
  List<Map<String, dynamic>> _allHotels = [];
  List<Map<String, dynamic>> _nearbyHotels = [];
  List<Map<String, dynamic>> _highestRatedHotels = [];
  
  // Loading states
  bool _isLoadingHotels = false;
  bool _hasLoadedHotels = false;
  
  // Error state
  String? _errorMessage;
  
  // Cache timestamp for refresh logic
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 10);

  // Track if we're currently in a loading operation to prevent multiple calls
  bool _isCurrentlyLoading = false;

  // Getters
  List<Map<String, dynamic>> get allHotels => _allHotels;
  List<Map<String, dynamic>> get nearbyHotels => _nearbyHotels;
  List<Map<String, dynamic>> get highestRatedHotels => _highestRatedHotels;
  bool get isLoadingHotels => _isLoadingHotels;
  bool get hasLoadedHotels => _hasLoadedHotels;
  String? get errorMessage => _errorMessage;
  
  // Check if cache is still valid
  bool get isCacheValid {
    if (_lastLoadTime == null) return false;
    return DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  // Load hotels from database with caching
  Future<void> loadHotels({bool forceRefresh = false}) async {
    // Prevent multiple simultaneous loading operations
    if (_isCurrentlyLoading) {
      print('Hotel loading already in progress, skipping...');
      return;
    }

    // Return cached data if valid and not forcing refresh
    if (!forceRefresh && _hasLoadedHotels && isCacheValid && _allHotels.isNotEmpty) {
      print('=== USING CACHED HOTEL DATA ===');
      print('- All hotels: ${_allHotels.length}');
      print('- Nearby hotels: ${_nearbyHotels.length}');
      print('- Highest rated: ${_highestRatedHotels.length}');
      return;
    }

    _isCurrentlyLoading = true;
    
    // Use post frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLoadingHotels) {
        _isLoadingHotels = true;
        _errorMessage = null;
        notifyListeners();
      }
    });

    try {
      print('=== LOADING HOTELS FROM DATABASE ===');
      
      // Get all hotels
      final allHotels = await HotelService.getAllHotels();
      print('Loaded ${allHotels.length} hotels from database');
      
      // Get hotels for different sections
      final lagosHotels = await HotelService.getHotelsByCity('Lagos');
      
      // Use post frame callback to update UI safely
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Update state
        _allHotels = allHotels;
        _nearbyHotels = lagosHotels.isNotEmpty ? lagosHotels : allHotels.take(5).toList();
        
        // Sort by rating for highest rated (assuming rating field exists or use default)
        _highestRatedHotels = List.from(allHotels);
        _highestRatedHotels.sort((a, b) => (b['rating'] ?? 4.5).compareTo(a['rating'] ?? 4.5));
        _highestRatedHotels = _highestRatedHotels.take(5).toList();
        
        _hasLoadedHotels = true;
        _lastLoadTime = DateTime.now();
        _isLoadingHotels = false;
        _errorMessage = null;
        _isCurrentlyLoading = false;
        
        notifyListeners();
        
        print('Hotels loaded successfully:');
        print('- All hotels: ${_allHotels.length}');
        print('- Nearby hotels: ${_nearbyHotels.length}');
        print('- Highest rated: ${_highestRatedHotels.length}');
      });
      
    } catch (e) {
      print('Error loading hotels: $e');
      
      // Use post frame callback to update error state safely
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoadingHotels = false;
        _errorMessage = 'Failed to load hotels. Please check your connection.';
        _isCurrentlyLoading = false;
        
        // Don't clear existing data on error if we have some
        if (_allHotels.isEmpty) {
          _allHotels = [];
          _nearbyHotels = [];
          _highestRatedHotels = [];
        }
        
        notifyListeners();
      });
    }
  }

  // Force refresh hotels
  Future<void> refreshHotels() async {
    await loadHotels(forceRefresh: true);
  }

  // Get hotels by city with caching
  Future<List<Map<String, dynamic>>> getHotelsByCity(String city) async {
    try {
      // If we have all hotels loaded, filter locally first
      if (_hasLoadedHotels && _allHotels.isNotEmpty) {
        final localResults = _allHotels.where((hotel) => 
          hotel['city']?.toString().toLowerCase().contains(city.toLowerCase()) == true ||
          hotel['location']?.toString().toLowerCase().contains(city.toLowerCase()) == true
        ).toList();
        
        // If we found local results, return them
        if (localResults.isNotEmpty) {
          print('Found ${localResults.length} hotels for $city in cache');
          return localResults;
        }
      }
      
      // Otherwise fetch from API
      print('Fetching hotels for $city from API');
      return await HotelService.getHotelsByCity(city);
    } catch (e) {
      print('Error getting hotels by city: $e');
      return [];
    }
  }

  // Search hotels with caching
  Future<List<Map<String, dynamic>>> searchHotels(String query) async {
    try {
      // If we have all hotels loaded, search locally first
      if (_hasLoadedHotels && _allHotels.isNotEmpty && query.isNotEmpty) {
        final searchQuery = query.toLowerCase();
        final localResults = _allHotels.where((hotel) => 
          hotel['name']?.toString().toLowerCase().contains(searchQuery) == true ||
          hotel['city']?.toString().toLowerCase().contains(searchQuery) == true ||
          hotel['location']?.toString().toLowerCase().contains(searchQuery) == true ||
          hotel['address']?.toString().toLowerCase().contains(searchQuery) == true
        ).toList();
        
        // If we found local results, return them
        if (localResults.isNotEmpty) {
          print('Found ${localResults.length} search results for "$query" in cache');
          return localResults;
        }
      }
      
      // Otherwise fetch from API
      print('Searching hotels for "$query" from API');
      return await HotelService.searchHotels(query);
    } catch (e) {
      print('Error searching hotels: $e');
      return [];
    }
  }

  // Clear cache (useful for logout or data refresh)
  void clearCache() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _allHotels = [];
      _nearbyHotels = [];
      _highestRatedHotels = [];
      _hasLoadedHotels = false;
      _lastLoadTime = null;
      _errorMessage = null;
      _isLoadingHotels = false;
      _isCurrentlyLoading = false;
      notifyListeners();
    });
  }

  // Get hotel by ID from cache first
  Map<String, dynamic>? getHotelById(int hotelId) {
    if (_hasLoadedHotels && _allHotels.isNotEmpty) {
      try {
        return _allHotels.firstWhere((hotel) => hotel['id'] == hotelId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Initialize hotels - safe method to call from initState
  void initializeHotels() {
    if (!_hasLoadedHotels && !_isCurrentlyLoading) {
      // Schedule loading for after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadHotels();
      });
    }
  }
}