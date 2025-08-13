import 'package:flutter/material.dart';
import 'package:lodgix/screens/dashboard.dart';
import 'package:lodgix/themes/theme.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "OTP Verification",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Lodgix.lightBorderColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "Enter the verification code sent to your email",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Lodgix.lightButtonBackground, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "Resend OTP in 30 secs",
                style: TextStyle(
                  color: Lodgix.lightBorderColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    String otp = controllers.map((c) => c.text).join();
                    if (otp.length == 6) {
                      print("OTP entered: $otp");
                      // Navigate to next screen or verify OTP
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("OTP Verified Successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter complete 6-digit OTP"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboard()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Lodgix.lightButtonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Clear all fields and resend OTP
                  for (var controller in controllers) {
                    controller.clear();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("OTP Resent Successfully!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Lodgix.lightBorderColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Lodgix.lightBorderColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}