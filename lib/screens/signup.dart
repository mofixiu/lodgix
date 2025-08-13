import 'package:flutter/material.dart';
import 'package:lodgix/screens/basicInfo.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                      "Sign Up ",
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Email Address",
                            hintStyle: TextStyle(
                              color: Lodgix.darkBorderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),

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
                      Icon(Icons.lock, color: Colors.grey[600], size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

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
                      Icon(Icons.lock, color: Colors.grey[600], size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              color: Lodgix.darkBorderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Basicinfo()),
                  );
                },
                data: "Create Account",
                textcolor: Colors.white,
                backgroundcolor: Color(0xFF0A3D62),
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
    );
  }
}
