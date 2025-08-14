import 'package:flutter/material.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/screens/forgotPassword.dart';
import 'package:lodgix/screens/signup.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: TextStyle(
                              color: Lodgix.darkBorderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.visiblePassword,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(),
                    ),
                  );
                },
                data: "Login",
                textcolor: Colors.white,
                backgroundcolor: Color(0xFF0A3D62),
                width: MediaQuery.of(context).size.width,
                height: 50,
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
            
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   padding: const EdgeInsets.all(20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         child: Container(
            //           height: 60,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(color: Colors.grey[300]!, width: 1),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey.withOpacity(0.1),
            //                 spreadRadius: 1,
            //                 blurRadius: 3,
            //                 offset: Offset(0, 1),
            //               ),
            //             ],
            //           ),
            //           child: Center(
            //             child: Image.asset(
            //               "assets/images/google.png",
            //               width: 24,
            //               height: 24,
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 16),
            //       Expanded(
            //         child: Container(
            //           height: 60,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(color: Colors.grey[300]!, width: 1),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey.withOpacity(0.1),
            //                 spreadRadius: 1,
            //                 blurRadius: 3,
            //                 offset: Offset(0, 1),
            //               ),
            //             ],
            //           ),
            //           child: Center(
            //             child: Image.asset(
            //               "assets/images/facebook.png",
            //               width: 24,
            //               height: 24,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
    );
  }
}
