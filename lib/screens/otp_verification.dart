import 'package:flutter/material.dart';
import 'package:lodgix/services/guest_service.dart';
import 'package:lodgix/widgets/customButton.dart';
import 'package:lodgix/screens/login.dart';

class OTPVerification extends StatefulWidget {
  final String email;
  final String fullName;

  const OTPVerification({
    Key? key,
    required this.email,
    required this.fullName,
  }) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  void _onOtpDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    if (otpCode.length != 6) {
      _showErrorSnackBar('Please enter complete OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await GuestService.verifyOTP(
        email: widget.email,
        otp: otpCode,
      );

      if (response != null && response['status'] == 'success') {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar(response?['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to verify OTP. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isResending = true;
    });

    try {
      final response = await GuestService.resendOTP(email: widget.email);

      if (response != null && response['status'] == 'success') {
        _showSuccessSnackBar('New OTP sent to your email');
        // Clear current OTP
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      } else {
        _showErrorSnackBar(response?['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to resend OTP. Please try again.');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Account Created!'),
            ],
          ),
          content: Text('Your account has been created successfully. You can now log in with your credentials.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A3D62),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Go to Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify Email',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            
            // Email verification icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFF0A3D62).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.email_outlined,
                size: 50,
                color: Color(0xFF0A3D62),
              ),
            ),
            
            SizedBox(height: 30),
            
            Text(
              'Verify Your Email',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 16),
            
            Text(
              'We sent a verification code to',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 8),
            
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A3D62),
              ),
            ),
            
            SizedBox(height: 40),
            
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 45,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _controllers[index].text.isNotEmpty 
                          ? Color(0xFF0A3D62) 
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {});
                      _onOtpDigitChanged(value, index);
                    },
                  ),
                );
              }),
            ),
            
            SizedBox(height: 40),
            
            // Verify Button
            CustomButton(
              ontap: _isLoading ? null : _verifyOTP,
              data: _isLoading ? 'Verifying...' : 'Verify Email',
              textcolor: Colors.white,
              backgroundcolor: _isLoading ? Colors.grey : Color(0xFF0A3D62),
              width: double.infinity,
              height: 50,
            ),
            
            SizedBox(height: 20),
            
            // Resend OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: _isResending ? null : _resendOTP,
                  child: Text(
                    _isResending ? 'Resending...' : 'Resend',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0A3D62),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}