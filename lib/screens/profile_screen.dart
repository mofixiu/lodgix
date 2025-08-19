import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/screens/edit_profile.dart';
import 'package:lodgix/screens/login.dart';
import 'package:lodgix/screens/notifications.dart';
import 'package:lodgix/widgets/bottomNavBar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Debug: Print user data
    print('=== PROFILE SCREEN USER DATA ===');
    print('Is logged in: ${userProvider.isLoggedIn}');
    print('Username: ${userProvider.username}');
    print('Email: ${userProvider.email}');
    print('Full Name: ${userProvider.fullName}');
    print('User ID: ${userProvider.userId}');
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

  void _showLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 20),
              Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        
                        // Properly logout using UserProvider
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        await userProvider.logout();
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Show loading if user data is not ready
          if (!userProvider.isLoggedIn) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 23, right: 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.3),
                        //     spreadRadius: 2,
                        //     blurRadius: 8,
                        //     offset: Offset(0, 3),
                        //   ),
                        // ],
                      ),
                      child: ClipOval(
                        child: userProvider.profileImagePath.isNotEmpty
                            ? Image.asset(
                                userProvider.profileImagePath,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar();
                                },
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        userProvider.fullName.isNotEmpty 
                            ? userProvider.fullName 
                            : 'Guest User',
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        userProvider.email.isNotEmpty 
                            ? userProvider.email 
                            : 'No email available',
                        style: TextStyle(
                          fontSize: 16, 
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                // Show additional user info if available
                if (userProvider.joinDate.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Member since ${_formatJoinDate(userProvider.joinDate)}',
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Divider(color: Colors.grey[700], thickness: 1),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfile()),
                    );
                  },
                  child: _buildProfileMenuItem(
                    icon: Icons.person,
                    title: "Edit Profile",
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                _buildProfileMenuItem(
                  icon: Icons.wallet,
                  title: "Payment",
                  color: Colors.black,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notifications()),
                    );
                  },
                  child: _buildProfileMenuItem(
                    icon: Icons.notifications_active,
                    title: "Notifications",
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                _buildProfileMenuItem(
                  icon: Icons.security_outlined,
                  title: "Security",
                  color: Colors.black,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                _buildProfileMenuItem(
                  icon: Icons.info_sharp,
                  title: "Help",
                  color: Colors.black,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                
                GestureDetector(
                  onTap: () {
                    _showLogoutBottomSheet();
                  },
                  child: _buildProfileMenuItem(
                    icon: Icons.logout,
                    title: "Log Out",
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 80,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          if (title != "Log Out")
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
        ],
      ),
    );
  }

  String _formatJoinDate(String joinDate) {
    try {
      final date = DateTime.parse(joinDate);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Recently';
    }
  }
}

