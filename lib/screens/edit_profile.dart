import 'package:flutter/material.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:lodgix/services/guest_service.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Delay initialization to ensure Provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Call debug method to see storage state
    userProvider.debugUserDataLoading();
    
    // Debug print to see what data is available
    print('=== EDIT PROFILE INITIALIZATION ===');
    print('Full Name: "${userProvider.fullName}"');
    print('Email: "${userProvider.email}"');
    print('Address: "${userProvider.address}"');
    print('Phone: "${userProvider.phoneNumber}"');
    print('User ID: ${userProvider.userId}');
    print('Is Logged In: ${userProvider.isLoggedIn}');
    print('===================================');
    
    // Pre-fill the form with existing user data
    _nameController.text = userProvider.fullName.isNotEmpty 
        ? userProvider.fullName 
        : '';
    _emailController.text = userProvider.email.isNotEmpty 
        ? userProvider.email 
        : '';
    _addressController.text = userProvider.address.isNotEmpty 
        ? userProvider.address 
        : '';
    _phoneController.text = userProvider.phoneNumber.isNotEmpty 
        ? userProvider.phoneNumber 
        : '';

    // Force UI update
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? Colors.grey[200] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: readOnly ? Border.all(color: Colors.grey[300]!) : null,
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: readOnly ? Colors.grey[600] : Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: readOnly ? Colors.grey[500] : Color(0xFF0A3D62),
                        size: 20,
                      ),
                      onPressed: readOnly ? null : onSuffixTap,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Validate fields
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your full name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    try {
      print('=== UPDATING PROFILE ===');
      print('User ID: ${userProvider.userId}');
      print('Full Name: ${_nameController.text.trim()}');
      print('Email: ${_emailController.text.trim()}');
      print('Address: ${_addressController.text.trim()}');
      print('Phone: ${_phoneController.text.trim()}');
      print('=== END OF UPDATE DATA ===');

      // Update profile in database
      final response = await GuestService.updateGuestProfile(
        guestId: userProvider.userId!,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      if (response != null && response['status'] == 'success') {
        // Update local user provider data
        await userProvider.updateUserProfile(
          fullName: _nameController.text.trim(),
          address: _addressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF0A3D62),
          ),
        );
        Navigator.pop(context);
      } else {
        final errorMessage = response?['message'] ?? 'Failed to update profile';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Profile update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Show loading if user data is not ready
          if (!userProvider.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF0A3D62)),
                  SizedBox(height: 16),
                  Text('Please log in to edit your profile'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: userProvider.profileImagePath.isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(userProvider.profileImagePath),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: userProvider.profileImagePath.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFF0A3D62),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image picker coming soon!'),
                                  backgroundColor: Color(0xFF0A3D62),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  suffixIcon: Icons.lock,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true, // Make email read-only
                  hintText: 'Email cannot be changed',
                ),
                
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  suffixIcon: Icons.location_on,
                  hintText: 'Enter your address',
                  maxLines: 2,
                ),
                
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  suffixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  hintText: 'Enter your phone number',
                ),
                
                SizedBox(height: 40),
                
                // Update Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A3D62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}