import 'package:flutter/material.dart';
import 'package:lodgix/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String _selectedGender = 'Prefer not to say';
  final List<String> _genders = ['Male', 'Female', 'Prefer not to say'];

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
    
    // Pre-fill the form with existing user data
    _nameController.text = userProvider.fullName.isNotEmpty 
        ? userProvider.fullName 
        : '';
    _emailController.text = userProvider.email.isNotEmpty 
        ? userProvider.email 
        : '';
    _countryController.text = userProvider.address.isNotEmpty 
        ? userProvider.address 
        : '';
    _phoneController.text = userProvider.phoneNumber.isNotEmpty 
        ? userProvider.phoneNumber 
        : '';
    
    // Debug print to see what data is available
    print('=== EDIT PROFILE INITIALIZATION ===');
    print('Full Name: "${userProvider.fullName}"');
    print('Email: "${userProvider.email}"');
    print('Address: "${userProvider.address}"');
    print('Phone: "${userProvider.phoneNumber}"');
    print('User ID: ${userProvider.userId}');
    print('Is Logged In: ${userProvider.isLoggedIn}');
    print('===================================');

    // Force UI update
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _countryController.dispose();
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add label
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
            onTap: onSuffixTap,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add label
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
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF0A3D62),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // void _selectDate() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2004, 3, 16),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: ColorScheme.light(
  //             primary: Color(0xFF0A3D62),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
    
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
  //     });
  //   }
  // }

  void _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0A3D62),
          ),
        ),
      );

      await userProvider.updateUserProfile(
        fullName: _nameController.text.trim(),
        // Don't update email since it's read-only
        address: _countryController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
      
      // Close loading dialog
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF0A3D62),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
              child: CircularProgressIndicator(
                color: Color(0xFF0A3D62),
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
                  controller: _countryController,
                  label: 'Address',
                  suffixIcon: Icons.location_on,
                  hintText: 'Enter your address',
                  onSuffixTap: () {
                    // TODO: Implement address picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Address picker coming soon!'),
                        backgroundColor: Color(0xFF0A3D62),
                      ),
                    );
                  },
                ),
                
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  suffixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  hintText: 'Enter your phone number',
                ),
                
                _buildDropdownField(
                  label: 'Gender',
                  value: _selectedGender,
                  items: _genders,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }
                  },
                ),
                
                SizedBox(height: 40),
                
                // Update Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A3D62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
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