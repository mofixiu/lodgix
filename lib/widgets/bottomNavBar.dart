import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lodgix/screens/bookedScreen.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/screens/profile_screen.dart';
import 'package:lodgix/screens/savedScreen.dart';
import 'package:lodgix/themes/theme.dart'; 

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return; 

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const Dashboard();
        break;
      case 1:
        nextPage = const Booked();
        break;
      case 2:
        nextPage = const Saved();
        break;
      case 3:
        nextPage = const Profile();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme-aware colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Lodgix.darkCardBackground 
        : Lodgix.lightCardBackground;
    final selectedItemColor = Lodgix.lightButtonBackground;
    final unselectedItemColor = Colors.grey[600];

    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _navigate(context, index),
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.bookBookmark), label: "Booked"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.heart), label: "Saved"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.person), label: "Profile"),
        ],
      ),
    );
  }
}
