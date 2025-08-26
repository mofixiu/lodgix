import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lodgix/screens/otp_verification.dart';
import 'package:lodgix/services/guest_service.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';

class Basicinfo extends StatefulWidget {
  final String email;
  final String password;

  const Basicinfo({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<Basicinfo> createState() => _BasicinfoState();
}

class _BasicinfoState extends State<Basicinfo> {
  List<XFile> _selectedIDDocuments = [];
  void _onIDDocumentSelected(List<XFile> images) {
    setState(() {
      _selectedIDDocuments = images;
    });
    print("Documents selected: ${images.length}");
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool _isLoading = false;

  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    @override

void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if ID document is selected
    if (_selectedIDDocuments.isEmpty) {
      _showErrorSnackBar('Please upload your ID document');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('=== STARTING REGISTRATION ===');
      print('Email: ${widget.email}');
      print('Full Name: ${fullNameController.text.trim()}');
      print('Phone: ${phoneNumberController.text.trim()}');
      print('Address: ${addressController.text.trim()}');
      print('ID Documents: ${_selectedIDDocuments.length}');

      final response = await GuestService.registerGuest(
        fullName: fullNameController.text.trim(),
        email: widget.email,
        password: widget.password,
        phoneNumber: phoneNumberController.text.trim(),
        address: addressController.text.trim(),
        idDocument: _selectedIDDocuments.isNotEmpty ? _selectedIDDocuments.first : null,
      );

      print('=== REGISTRATION RESPONSE ===');
      print('Response: $response');

      if (response != null && response['status'] == 'success') {
        print('Registration successful, navigating to OTP verification');
        // Navigate to OTP verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerification(
              email: widget.email,
              fullName: fullNameController.text.trim(),
            ),
          ),
        );
      } else {
        final errorMessage = response?['message'] ?? 'Registration failed';
        print('Registration failed: $errorMessage');
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      print('Registration error: $e');
      _showErrorSnackBar('Failed to register. Please check your internet connection and try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Basic Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Full Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
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
                              Icons.person_outline,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: fullNameController,
                                validator: _validateFullName,
                                decoration: InputDecoration(
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(
                                    color: Lodgix.darkBorderColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
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
                              Icons.phone_android_outlined,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: phoneNumberController,
                                inputFormatters: [PhoneNumberFormatter()],
                                validator: _validatePhoneNumber,
                                decoration: InputDecoration(
                                  hintText: "Enter Phone Number",
                                  hintStyle: TextStyle(
                                    color: Lodgix.darkBorderColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    Container(
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
                          vertical: 16.0,
                        ),
                        child: TextFormField(
                          controller: addressController,
                          maxLines: 2,
                          minLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Address",
                            hintStyle: TextStyle(
                              color: Lodgix.darkBorderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // ID Document Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID Document",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Upload ID Document (Required)",
                                style: TextStyle(
                                  color: Lodgix.darkBorderColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ImagePickerWidget(
                            onImagesSelected: _onIDDocumentSelected,
                            allowMultiple: false,
                            width: double.infinity,
                            height: 100,
                          ),
                          if (_selectedIDDocuments.isNotEmpty) ...[
                            SizedBox(height: 12),
                            Text(
                              "Document uploaded successfully",
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.005),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        await _submitRegistration();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all required fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    // onPressed: _selectedIDDocuments.isNotEmpty
                    //     ? () {
                    //         print("Form submitted with ${_selectedIDDocuments.length} documents");
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => OTP(),
                    //           ),
                    //         );
                    //       }
                    //     : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Lodgix.lightButtonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digitsOnly.length > 11
        ? digitsOnly.substring(0, 11)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limitedDigits.length; i++) {
      buffer.write(limitedDigits[i]);
      if (i == 2 || i == 5) buffer.write(' ');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}




String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name cannot be empty';
    }

    final nameParts = value.trim().split(RegExp(r'\s+'));
    if (nameParts.length < 2) {
      return 'Please enter your first and last name';
    }

    final validCharacters = RegExp(r"^[a-zA-Z\s'-]+$");
    if (!validCharacters.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes';
    }

    return null;
  }
  String? _validatePhoneNumber(String? value) {
    if (value == null   || value.isEmpty) {
      return 'Field cannot be empty';
    }

    final digitsOnly = value.replaceAll(' ', '');
    if (digitsOnly.length != 11) {
      return 'Phone number must be exactly 11 digits';
    }

    final validPhoneRegExp = RegExp(
      r'^(070|080|081|090|091|071|089|088|085|086)\d{8}$',
    );

    if (!validPhoneRegExp.hasMatch(digitsOnly)) {
      return 'Enter a valid phone number';
    }

    return null;
  }
