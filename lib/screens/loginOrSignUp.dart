import 'package:flutter/material.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';

class LoginOrSignUp extends StatefulWidget {
  const LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    "Log in or sign up",
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              ontap: () {},
              data: "Continue",
              textcolor: Colors.white,
              backgroundcolor: Color(0xFF0A3D62),
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
          ),
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
         
        ],
      ),
    );
  }
}
