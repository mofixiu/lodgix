import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lodgix/services/guest_service.dart';
import 'package:lodgix/widgets/customButton.dart';
import 'package:lodgix/screens/login.dart';

class OTPVerification extends StatefulWidget {
  final String email;
  final String fullName;

  const OTPVerification({
    super.key,
    required this.email,
    required this.fullName,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;
  
  Timer? _timer;
  int _countdownSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _startCountdown() {
    setState(() {
      _countdownSeconds = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
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
      print('=== VERIFYING OTP ===');
      print('Email: ${widget.email}');
      print('OTP: $otpCode');

      final response = await GuestService.verifyOTP(
        email: widget.email,
        otp: otpCode,
      );

      print('=== OTP VERIFICATION RESPONSE ===');
      print('Response: $response');

      if (response != null && response['status'] == 'success') {
        print('OTP verification successful');
        _showSuccessDialog();
      } else {
        final errorMessage = response?['message'] ?? 'OTP verification failed';
        print('OTP verification failed: $errorMessage');
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      print('OTP verification error: $e');
      _showErrorSnackBar('Failed to verify OTP. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      print('=== RESENDING OTP ===');
      print('Email: ${widget.email}');

      final response = await GuestService.resendOTP(email: widget.email);

      print('=== RESEND OTP RESPONSE ===');
      print('Response: $response');

      if (response != null && response['status'] == 'success') {
        _showSuccessSnackBar('New OTP sent to your email');
        
        // Clear current OTP
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        
        // Restart countdown
        _startCountdown();
      } else {
        final errorMessage = response?['message'] ?? 'Failed to resend OTP';
        print('Resend OTP failed: $errorMessage');
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      print('Resend OTP error: $e');
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
              Expanded(
                child: Text(
                  'Account Verified!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello ${widget.fullName}!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A3D62),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your email has been verified successfully. You can now log in with your credentials.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A3D62),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size(double.infinity, 45),
              ),
              child: Text(
                'Go to Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
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
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
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
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 16),
            
            Text(
              'We sent a 6-digit verification code to',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 8),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF0A3D62).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.email,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A3D62),
                ),
                textAlign: TextAlign.center,
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
                    color: _controllers[index].text.isNotEmpty
                        ? Color(0xFF0A3D62).withOpacity(0.05)
                        : Colors.white,
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
                      
                      // Auto-verify when all fields are filled
                      if (otpCode.length == 6) {
                        Future.delayed(Duration(milliseconds: 500), () {
                          if (mounted && otpCode.length == 6) {
                            _verifyOTP();
                          }
                        });
                      }
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
            
            SizedBox(height: 30),
            
            // Resend OTP Section
            Column(
              children: [
                Text(
                  "Didn't receive the code?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                
                SizedBox(height: 8),
                
                if (!_canResend) ...[
                  Text(
                    'Resend available in $_countdownSeconds seconds',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ] else ...[
                  Text(
                    'You can now request a new code',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                    ),
                  ),
                ],
                
                SizedBox(height: 12),
                
                TextButton(
                  onPressed: (_canResend && !_isResending) ? _resendOTP : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isResending ? 'Resending...' : 'Resend OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: (_canResend && !_isResending) 
                          ? Color(0xFF0A3D62) 
                          : Colors.grey[400],
                      decoration: (_canResend && !_isResending)
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
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