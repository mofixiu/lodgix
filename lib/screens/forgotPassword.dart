import 'package:flutter/material.dart';
import 'package:lodgix/screens/otpforgotpassword.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/customButton.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int _selectedIndex = 0;

  Widget _contactOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xFF0A3D62) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Color(0xFF0A3D62) : Colors.grey, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
                Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Select which contact details should we use",
            style: TextStyle(
              fontSize: 17.5,
              color: Colors.black,
            ),
          ),
          const Text(
            "to reset your password ",
            style: TextStyle(
              fontSize: 17.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          _contactOption(
            index: 0,
            icon: Icons.sms,
            title: "via SMS",
            subtitle: "+9705994*****99",
          ),
          _contactOption(
            index: 1,
            icon: Icons.email,
            title: "via Email",
            subtitle: "shady*****@gmail.com",
          ),
          Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                ontap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPForgotPassword(),
                    ),
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