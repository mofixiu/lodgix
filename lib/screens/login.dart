import 'package:flutter/material.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/screens/forgotPassword.dart';
import 'package:lodgix/screens/signup.dart';
import 'package:lodgix/services/guest_service.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';
import 'package:provider/provider.dart';
import 'package:lodgix/providers/user_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('=== STARTING LOGIN ===');
      print('Email: ${emailController.text.trim()}');

      final response = await GuestService.loginGuest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('=== LOGIN RESPONSE ===');
      print('Response: $response');

      if (response != null && response['status'] == 'success') {
        // Extract user data from response with null checks
        final data = response['data'];
        if (data != null) {
          final token = data['token'];
          final guestData = data['guest'];
          
          if (token != null && guestData != null) {
            print('Login successful!');
            print('Token: $token');
            print('Guest data: $guestData');

            // Save user data to provider
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            
            // Call setUserData and await it properly
            await userProvider.setUserData(
              username: guestData['email'] ?? '',
              token: token,
              email: guestData['email'] ?? '',
              userId: guestData['id'],
              fullName: guestData['full_name'] ?? '',
              joinDate: guestData['created_at'] ?? DateTime.now().toString(),
              address: guestData['address'] ?? '', // Make sure this matches your backend field
              phoneNumber: guestData['phone_number'] ?? '', // Make sure this matches your backend field
            );

            // Debug: Print user provider state after setting data
            userProvider.debugPrintHiveData();

            // Show success message
            _showSuccessSnackBar('Login successful! Welcome back!');

            // Navigate to dashboard
            if (mounted) { // Check if widget is still mounted
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            }
          } else {
            _showErrorSnackBar('Invalid response format');
            return;
          }
        } else {
          _showErrorSnackBar('Invalid response data');
          return;
        }
      } else {
        final errorMessage = response?['message'] ?? 'Login failed';
        print('Login failed: $errorMessage');
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      print('Login error: $e');
      _showErrorSnackBar('Failed to login. Please check your credentials and try again.');
    } finally {
      if (mounted) { // Check if widget is still mounted
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/loginImage.png",
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "Navigate the World, \n Book Your Bliss",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Lodgix.lightBorderColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Lodgix.darkBorderColor, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Lodgix.darkBorderColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Lodgix.darkBorderColor, thickness: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              
              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Email Address",
                              hintStyle: TextStyle(
                                color: Lodgix.darkBorderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              errorStyle: TextStyle(fontSize: 0), // Hide error text to save space
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              
              // Password Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle: TextStyle(
                                color: Lodgix.darkBorderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              errorStyle: TextStyle(fontSize: 0), // Hide error text to save space
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             
              // Login Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  ontap: _isLoading ? null : _handleLogin,
                  data: _isLoading ? "Logging in..." : "Login",
                  textcolor: Colors.white,
                  backgroundcolor: _isLoading ? Colors.grey : Color(0xFF0A3D62),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                ),
              ),
              
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CircularProgressIndicator(
                    color: Color(0xFF0A3D62),
                  ),
                ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.003),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0A3D62),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Lodgix.darkBorderColor, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Lodgix.darkBorderColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Lodgix.darkBorderColor, thickness: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
             Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    );
                  },
                  data: "Create An Account",
                  textcolor: Colors.white,
                  backgroundcolor: Color(0xFF0A3D62),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                ),
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                "By Continuing, you agree to our",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Terms of Service",
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  SizedBox(width: 4),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
