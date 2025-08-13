import 'package:flutter/material.dart';
import 'package:lodgix/screens/otpScreen.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';

class Basicinfo extends StatefulWidget {
  const Basicinfo({super.key});

  @override
  State<Basicinfo> createState() => _BasicinfoState();
}

class _BasicinfoState extends State<Basicinfo> {
  List<XFile> _selectedIDDocuments = [];
  void _onIDDocumentSelected(List<XFile> images) {
    setState(() {
      _selectedIDDocuments = images;
    });
    print("Documents selected: ${images.length}"); // Add this for debugging
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (!RegExp(
                                    r'^\+?[0-9]{10,15}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
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
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedIDDocuments.isNotEmpty) {
                        // Proceed to OTP screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OTP()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please fill all fields and upload ID document",
                            ),
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
