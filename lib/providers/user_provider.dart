import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lodgix/providers/booking_provider.dart';
import 'package:lodgix/providers/bookmark_provider.dart';
import 'package:lodgix/request.dart' as RequestService;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _token = '';
  String _profileImagePath = "";
  int? _userId;
  String _email = '';
  String _fullName = '';
  String _joinDate = '';
  String _address = ''; // Add address field
  String _phoneNumber = ''; // Add phone number field
  bool _isInitialized = false;
  // ignore: unused_field
  bool _isLoggedIn = false; // Track login state

  // Hive box name
  static const String _boxName = 'user_data';
  late Box _userBox;

  // Getters
  String get username => _username;
  String get token => _token;
  String get profileImagePath => _profileImagePath;
  int? get userId => _userId; // Make nullable to avoid crashes
  String get email => _email;
  String get fullName => _fullName;
  String get joinDate => _joinDate;
  String get address => _address; // Add address getter
  String get phoneNumber => _phoneNumber; // Add phone number getter
  String get phone_number => _phoneNumber; // Alternative getter for consistency
  bool get isInitialized => _isInitialized;
  bool get hasValidUserData => _username.isNotEmpty && _email.isNotEmpty && _userId != null;
  bool get isLoggedIn => _token.isNotEmpty; // Getter for login state

  // Initialize Hive box
  Future<void> initHive() async {
    if (_isInitialized) return; // Prevent double initialization
    
    try {
      print('UserProvider: Starting Hive initialization...');
      _userBox = await Hive.openBox(_boxName);
      await loadUserData();
      _isInitialized = true;
      print('UserProvider: Hive initialization complete');
      notifyListeners(); // Add this to notify widgets
    } catch (e) {
      print('Error initializing UserProvider Hive: $e');
      try {
        _userBox = await Hive.openBox(_boxName);
        _isInitialized = true;
        print('UserProvider: Fallback initialization successful');
        notifyListeners(); // Add this
      } catch (fallbackError) {
        print('UserProvider: Fallback initialization failed: $fallbackError');
      }
    }
  }

  // Load user data from Hive
  Future<void> loadUserData() async {
    if (!_isInitialized) {
      print('UserProvider not initialized, cannot load data');
      return;
    }
    
    try {
      _username = _userBox.get('username', defaultValue: '') ?? '';
      _email = _userBox.get('email', defaultValue: '') ?? '';
      _fullName = _userBox.get('fullName', defaultValue: '') ?? '';
      _joinDate = _userBox.get('joinDate', defaultValue: '') ?? '';
      _profileImagePath = _userBox.get('profileImagePath', defaultValue: '') ?? '';
      _address = _userBox.get('address', defaultValue: '') ?? ''; // Load address
      _phoneNumber = _userBox.get('phoneNumber', defaultValue: '') ?? ''; // Load phone number
      _userId = _userBox.get('userId');
      
      print('User data loaded from Hive:');
      print('Username: "$_username"');
      print('Email: "$_email"');
      print('UserId: $_userId');
      print('Full Name: "$_fullName"');
      print('Join Date: "$_joinDate"');
      print('Address: "$_address"');
      print('Phone Number: "$_phoneNumber"');
      
      notifyListeners();
    } catch (e) {
      print('Error loading user data from Hive: $e');
    }
  }

  // Save user data to Hive
  Future<void> _saveUserData() async {
    if (!_isInitialized) {
      print('UserProvider not initialized, cannot save data');
      return;
    }
    
    try {
      // Save each field individually with explicit await
      await _userBox.put('username', _username);
      await _userBox.put('email', _email);
      await _userBox.put('fullName', _fullName);
      await _userBox.put('joinDate', _joinDate);
      await _userBox.put('profileImagePath', _profileImagePath);
      await _userBox.put('address', _address); // Save address
      await _userBox.put('phoneNumber', _phoneNumber); // Save phone number
      
      if (_userId != null) {
        await _userBox.put('userId', _userId!);
      }
      
      // Force Hive to flush to disk
      await _userBox.flush();
      
      print('User data saved to Hive successfully');
      print('Saved username: $_username');
      print('Saved email: $_email');
      print('Saved userId: $_userId');
      print('Saved fullName: $_fullName');
      print('Saved joinDate: $_joinDate');
      print('Saved address: $_address');
      print('Saved phoneNumber: $_phoneNumber');
    } catch (e) {
      print('Error saving user data to Hive: $e');
    }
  }

  // Public wrapper for _saveUserData
  Future<void> saveUserData() async {
    await _saveUserData();
  }

  // Individual setters
  void setUsername(String username) {
    _username = username;
    _saveUserData();
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setProfileImagePath(String path) {
    _profileImagePath = path;
    _saveUserData();
    notifyListeners();
  }

  void setUserId(int? userId) {
    _userId = userId;
    _saveUserData();
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    _saveUserData();
    notifyListeners();
  }

  void setFullName(String fullName) {
    _fullName = fullName;
    _saveUserData();
    notifyListeners();
  }

  void setJoinDate(String joinDate) {
    _joinDate = joinDate;
    _saveUserData();
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    _saveUserData();
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    _saveUserData();
    notifyListeners();
  }

  // Set all user data at once - Updated with new fields
  Future<void> setUserData({
    required String username,
    required String token,
    required String email,
    int? userId,
    required String fullName,
    String? joinDate,
    String? address,
    String? phoneNumber,
  }) async {
    print('=== SETTING USER DATA ===');
    print('Username: $username');
    print('Email: $email');
    print('UserId: $userId');
    print('Full Name: $fullName');
    print('Join Date: $joinDate');
    print('Address: $address');
    print('Phone Number: $phoneNumber');
    print('Token: ${token.isNotEmpty ? 'Present' : 'Not present'}');
    
    _username = username;
    _token = token;
    _email = email;
    _userId = userId;
    _fullName = fullName;
    
    if (joinDate != null) {
      _joinDate = joinDate;
    }
    if (address != null) {
      _address = address;
    }
    if (phoneNumber != null) {
      _phoneNumber = phoneNumber;
    }
    
    // Save the token to RequestService as well
    await RequestService.setAuthToken(token);
    
    // Save to Hive
    await _saveUserData();
    
    // Verify data was saved
    await Future.delayed(Duration(milliseconds: 100));
    await loadUserData();
    
    print('=== USER DATA SET COMPLETE ===');
    notifyListeners();
  }

  // Update user profile data (for edit profile functionality)
  Future<void> updateUserProfile({
    String? fullName,
    String? email,
    String? address,
    String? phoneNumber,
  }) async {
    bool hasChanges = false;
    
    if (fullName != null && fullName != _fullName) {
      _fullName = fullName;
      hasChanges = true;
    }
    
    if (email != null && email != _email) {
      _email = email;
      hasChanges = true;
    }
    
    if (address != null && address != _address) {
      _address = address;
      hasChanges = true;
    }
    
    if (phoneNumber != null && phoneNumber != _phoneNumber) {
      _phoneNumber = phoneNumber;
      hasChanges = true;
    }
    
    if (hasChanges) {
      await _saveUserData();
      notifyListeners();
      print('User profile updated successfully');
    }
  }

  // Add ONLY this method to your existing UserProvider class
  Future<void> initializeUser() async {
    try {
      print('=== INITIALIZING USER FROM STORAGE ===');
      
      // Try to load from SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      print('SharedPreferences check - Is logged in: $isLoggedIn');
      
      if (isLoggedIn) {
        _userId = prefs.getInt('user_id');
        _username = prefs.getString('username') ?? '';
        _email = prefs.getString('email') ?? '';
        _fullName = prefs.getString('full_name') ?? '';
        _token = prefs.getString('token') ?? '';
        _address = prefs.getString('address') ?? '';
        _phoneNumber = prefs.getString('phone_number') ?? '';
        
        print('Loaded from SharedPreferences:');
        print('- User ID: $_userId');
        print('- Full Name: "$_fullName"');
        print('- Email: "$_email"');
        print('- Address: "$_address"');
        print('- Phone: "$_phoneNumber"');
        
        // Set auth token for API requests
        if (_token.isNotEmpty) {
          await RequestService.setAuthToken(_token);
        }
      }
      
      // Also try to load from Hive as backup
      await loadUserData();
      
      print('=== USER INITIALIZATION COMPLETE ===');
      print('Final state:');
      print('- User ID: $_userId');
      print('- Full Name: "$_fullName"');
      print('- Email: "$_email"');
      print('- Address: "$_address"');
      print('- Phone: "$_phoneNumber"');
      print('- Is Logged In: $isLoggedIn');
      print('=====================================');
      
      notifyListeners();
    } catch (e) {
      print('Error initializing user: $e');
    }
  }

void _clearUserData() {
  print('Clearing in-memory user data...');
  _userId = null;
  _username = '';
  _email = '';
  _fullName = '';
  _token = '';
  _address = '';
  _phoneNumber = '';
  _profileImagePath = '';
  _joinDate = '';
  print('In-memory data cleared');
}


  Future<void> logout() async {
     await logoutUser();
 }

  // Debug method to print all Hive data
  void debugPrintHiveData() {
    if (!_isInitialized) {
      print('UserProvider not initialized yet');
      return;
    }
    
    print('=== HIVE DEBUG DATA ===');
    print('All keys in box: ${_userBox.keys.toList()}');
    print('Username: ${_userBox.get('username')}');
    print('Email: ${_userBox.get('email')}');
    print('Full Name: ${_userBox.get('fullName')}');
    print('Join Date: ${_userBox.get('joinDate')}');
    print('User ID: ${_userBox.get('userId')}');
    print('Profile Image: ${_userBox.get('profileImagePath')}');
    print('Address: ${_userBox.get('address')}');
    print('Phone Number: ${_userBox.get('phoneNumber')}');
    print('=== END HIVE DEBUG ===');
  }

  // Close Hive box when provider is disposed
  @override
  void dispose() {
    if (_isInitialized) {
      _userBox.close();
    }
    super.dispose();
  }

  // Test data persistence
  Future<void> testDataPersistence() async {
    print('=== TESTING DATA PERSISTENCE ===');
    
    // Save test data
    _username = 'testuser';
    _email = 'test@test.com';
    _userId = 123;
    _address = 'Test Address';
    _phoneNumber = '1234567890';
    await _saveUserData();
    
    // Clear memory
    _username = '';
    _email = '';
    _userId = null;
    _address = '';
    _phoneNumber = '';
    
    // Reload from Hive
    await loadUserData();
    
    print('After reload:');
    print('Username: "$_username"');
    print('Email: "$_email"');
    print('UserID: $_userId');
    print('Address: "$_address"');
    print('Phone Number: "$_phoneNumber"');
    
    if (_username == 'testuser' && _email == 'test@test.com' && _userId == 123 && _address == 'Test Address' && _phoneNumber == '1234567890') {
      print('✅ Data persistence test PASSED');
    } else {
      print('❌ Data persistence test FAILED');
    }
    print('=== END TEST ===');
  }

  // Debug method to print user provider state
  void debugPrintProviderState() {
    print('=== USER PROVIDER DEBUG ===');
    print('Username: "$_username"');
    print('Email: "$_email"'); 
    print('User ID: $_userId');
    print('Full Name: "$_fullName"');
    print('Join Date: "$_joinDate"');
    print('Address: "$_address"');
    print('Phone Number: "$_phoneNumber"');
    print('Is Initialized: $_isInitialized');
    print('Has Valid User Data: $hasValidUserData');
    print('=== END DEBUG ===');
  }

  // Add this method to your UserProvider for debugging:
  void debugPrintAllData() {
    print('=== USER PROVIDER DEBUG ===');
    print('Username: "$_username"');
    print('Email: "$_email"');
    print('Full Name: "$_fullName"');
    print('Address: "$_address"');
    print('Phone Number: "$_phoneNumber"');
    print('User ID: $_userId');
    print('Is Initialized: $_isInitialized');
    print('Is Logged In: $isLoggedIn');
    print('Join Date: "$_joinDate"');
    print('===========================');
  }

  // Update your existing loginUser method to save to SharedPreferences
  Future<void> loginUser({
    required int userId,
    required String username,
    required String email,
    required String fullName,
    required String token,
    String? address,
    String? phoneNumber,
  }) async {
    try {
      print('=== LOGIN USER DEBUG ===');
      print('User ID: $userId');
      print('Username: $username');
      print('Email: $email');
      print('Full Name: $fullName');
      print('Address: $address');
      print('Phone Number: $phoneNumber');
      print('Token: ${token.substring(0, 20)}...');
      print('========================');

      _userId = userId;
      _username = username;
      _email = email;
      _fullName = fullName;
      _token = token;
      _address = address ?? '';
      _phoneNumber = phoneNumber ?? '';

      // Save to both SharedPreferences and Hive
      await _saveUserData();
      
      // Also save to SharedPreferences for immediate access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setString('full_name', fullName);
      await prefs.setString('token', token);
      await prefs.setString('address', address ?? '');
      await prefs.setString('phone_number', phoneNumber ?? '');
      await prefs.setBool('is_logged_in', true);

      print('User data saved to storage');
      print('Address saved: "${_address}"');
      print('Phone saved: "${_phoneNumber}"');

      notifyListeners();
    } catch (e) {
      print('Error in loginUser: $e');
      rethrow;
    }
  }

  // Update the logoutUser method to be safer:

  Future<void> logoutUser({BuildContext? context}) async {
    try {
      print('=== STARTING LOGOUT PROCESS ===');
      print('Clearing all user data...');
      
      // Clear SharedPreferences (this is what splash screen checks)
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ SharedPreferences cleared');
      
      // Clear RequestService token
      await RequestService.clearAuthToken();
      print('✅ RequestService token cleared');
      
      // Clear Hive if initialized
      if (_isInitialized) {
        try {
          await _userBox.clear();
          print('✅ Hive data cleared');
        } catch (e) {
          print('Warning: Could not clear Hive data: $e');
        }
      }
      
      // Clear other providers if context is available - but don't call notifyListeners during logout
      if (context != null && context.mounted) {
        try {
          // Schedule provider clearing for after the current frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              final bookingProvider = Provider.of<BookingProvider?>(context, listen: false);
              if (bookingProvider != null) {
                bookingProvider.clearBookings();
                print('✅ Booking provider cleared');
              }
              
              final bookmarkProvider = Provider.of<BookmarkProvider?>(context, listen: false);
              if (bookmarkProvider != null) {
                bookmarkProvider.clearBookmarks();
                print('✅ Bookmark provider cleared');
              }
            } catch (e) {
              print('Note: Could not clear providers (this is okay): $e');
            }
          });
        } catch (e) {
          print('Note: Could not schedule provider clearing: $e');
        }
      }
      
      // Clear in-memory data
      _clearUserData();
      print('✅ In-memory data cleared');
      
      print('=== LOGOUT COMPLETED SUCCESSFULLY ===');
      
      // Schedule notifyListeners for after the current frame if we're in a build context
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      print('❌ Error during logout: $e');
      // Even if there's an error, clear in-memory data as fallback
      _clearUserData();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Add this method to help debug the address/phone issue:

  Future<void> debugUserDataLoading() async {
    print('=== DEBUG USER DATA LOADING ===');
    
    // Check SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences data:');
    print('- Full Name: "${prefs.getString('full_name')}"');
    print('- Email: "${prefs.getString('email')}"');
    print('- Address: "${prefs.getString('address')}"');
    print('- Phone: "${prefs.getString('phone_number')}"');
    
    // Check Hive data
    if (_isInitialized) {
      print('Hive data:');
      print('- Full Name: "${_userBox.get('fullName')}"');
      print('- Email: "${_userBox.get('email')}"');
      print('- Address: "${_userBox.get('address')}"');
      print('- Phone: "${_userBox.get('phoneNumber')}"');
    }
    
    // Check current provider state
    print('Current provider state:');
    print('- Full Name: "$_fullName"');
    print('- Email: "$_email"');
    print('- Address: "$_address"');
    print('- Phone: "$_phoneNumber"');
    print('==============================');
  }
}