import 'package:flutter/material.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
    bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Forgot Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Lodgix.darkCardBackground)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/lock.png',
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Create your new password",
            style: TextStyle(
              fontSize: 17.5,
              color: Colors.black,
            ),
          ),
        
          const SizedBox(height: 24),
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
          
          Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                ontap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => congratulationsModal(context),
                  );
                },
                data: "Continue",
                textcolor: Colors.white,
                backgroundcolor: Color(0xFF0A3D62),
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
            ),
           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
Widget congratulationsModal(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    backgroundColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: CircleAvatar(radius: 6, backgroundColor: Color(0xFF0A3D62)),
              ),
              Positioned(
                left: 0,
                top: 40,
                child: CircleAvatar(radius: 10, backgroundColor: Color(0xFF0A3D62)),
              ),
              Positioned(
                right: 0,
                top: 40,
                child: CircleAvatar(radius: 8, backgroundColor: Color(0xFF0A3D62)),
              ),
              Positioned(
                left: 20,
                bottom: 0,
                child: CircleAvatar(radius: 7, backgroundColor: Color(0xFF0A3D62)),
              ),
              Positioned(
                right: 20,
                bottom: 0,
                child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF0A3D62)),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF0A3D62),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.check_box, color: Colors.white, size: 48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Congratulations !",
            style: TextStyle(
              color: Color(0xFF0A3D62),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your account is ready to use",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A3D62),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Go to Homepage",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}