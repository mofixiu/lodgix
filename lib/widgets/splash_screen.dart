import 'package:flutter/material.dart';
import 'package:lodgix/screens/login.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/providers/booking_provider.dart';
import 'package:lodgix/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _controller.forward();

    // Check authentication status and navigate accordingly
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);
      
      print('=== SPLASH SCREEN AUTH CHECK ===');
      print('Checking for existing user session...');

      // Initialize user data from storage (if exists)
      await userProvider.initializeUser();

      print('User logged in: ${userProvider.isLoggedIn}');
      print('User ID: ${userProvider.userId}');
      print('Username: ${userProvider.username}');
      print('Email: ${userProvider.email}');
      print('Full Name: ${userProvider.fullName}');
      print('Token exists: ${userProvider.token.isNotEmpty}');
      print('===============================');

      // Navigate based on authentication status
      if (userProvider.isLoggedIn && 
          userProvider.token.isNotEmpty && 
          userProvider.userId != null) {
        print('User is logged in, preloading data...');
        
        // Preload user data in background (don't wait for it)
        bookingProvider.loadBookings(userProvider.userId!).catchError((e) {
          print('Background booking load error: $e');
        });
        
        bookmarkProvider.loadBookmarks(userProvider.userId!).catchError((e) {
          print('Background bookmark load error: $e');
        });
        
        print('Navigating to Dashboard');
        _navigateToDashboard();
      } else {
        print('User not logged in or session invalid, navigating to Login');
        _navigateToLogin();
      }
    } catch (e) {
      print('Error during auth check: $e');
      // If there's an error, default to login screen
      _navigateToLogin();
    }
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Dashboard(),
      ),
    );
  }

  void _navigateToLogin() {
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Login(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 242, 239, 1.0), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with fade animation
            FadeTransition(
              opacity: _controller,
              child: Image.asset(
                "assets/images/lodgix splash.png",
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            
            SizedBox(height: 30),
            
            // Loading indicator
            FadeTransition(
              opacity: _controller,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A3D62)),
                strokeWidth: 3,
              ),
            ),
            
            SizedBox(height: 20),
            
            // Loading text
            FadeTransition(
              opacity: _controller,
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0A3D62),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
