import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lodgix/request.dart';

class GuestService {
  static const String _baseUrl = '/users';

  // Register guest with OTP verification and file upload
  static Future<Map<String, dynamic>?> registerGuest({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    XFile? idDocument,
  }) async {
    try {
      log('=== GUEST REGISTRATION WITH FILE DEBUG ===');
      log('Full Name: $fullName');
      log('Email: $email');
      log('Phone: $phoneNumber');
      log('Address: $address');
      log('ID Document: ${idDocument?.path ?? 'None'}');
      
      // Ensure service is initialized
      if (!RequestService.isInitialized) {
        log('Initializing RequestService...');
        RequestService.initialize();
      }
      
      log('Calling URL: $baseUrl$_baseUrl/guests');
      
      // Create FormData for file upload
      FormData formData = FormData.fromMap({
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'address': address,
      });

      // Add ID document if provided
      if (idDocument != null) {
        String fileName = idDocument.path.split('/').last;
        formData.files.add(MapEntry(
          'id_document',
          await MultipartFile.fromFile(
            idDocument.path,
            filename: fileName,
          ),
        ));
        log('Added ID document to form data: $fileName');
      }

      log('FormData fields: ${formData.fields}');
      log('FormData files: ${formData.files.length}');

      // Use Dio directly for file upload
      final dio = Dio();
      dio.options.baseUrl = baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 60); // Longer timeout for file upload
      dio.options.receiveTimeout = const Duration(seconds: 60);

      final response = await dio.post(
        '$_baseUrl/guests',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );
      
      log('Response received: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['status'] == 'success') {
          log('Registration successful!');
          return response.data;
        }
      }
      
      log('Registration failed: ${response.data?['message']}');
      return response.data;
    } catch (e) {
      log('Registration error: $e');
      if (e is DioException && e.response != null) {
        log('Error response: ${e.response!.data}');
        return e.response!.data;
      }
      rethrow;
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>?> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      log('Verifying OTP for: $email');
      
      // Ensure service is initialized
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final data = {
        'email': email,
        'otp': otp,
      };

      final response = await RequestService.post('$_baseUrl/guests/verify-email', data);
      
      if (response != null && response['status'] == 'success') {
        log('OTP verified successfully');
        return response;
      }
      
      return response;
    } catch (e) {
      log('Error verifying OTP: $e');
      rethrow;
    }
  }

  // Resend OTP
  static Future<Map<String, dynamic>?> resendOTP({
    required String email,
  }) async {
    try {
      log('Resending OTP for: $email');
      
      // Ensure service is initialized
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final data = {
        'email': email,
      };

      final response = await RequestService.post('$_baseUrl/guests/resend-otp', data);
      
      if (response != null && response['status'] == 'success') {
        log('OTP resent successfully');
        return response;
      }
      
      return response;
    } catch (e) {
      log('Error resending OTP: $e');
      rethrow;
    }
  }

  // Guest login
  static Future<Map<String, dynamic>?> loginGuest({
    required String email,
    required String password,
  }) async {
    try {
      log('Logging in guest: $email');
      
      // Ensure service is initialized
      if (!RequestService.isInitialized) {
        RequestService.initialize();
      }
      
      final data = {
        'email': email,
        'password': password,
      };

      final response = await RequestService.post('$_baseUrl/guest/login', data);
      
      if (response != null && response['status'] == 'success') {
        log('Guest login successful');
        
        // Save the token
        final token = response['data']['token'];
        if (token != null) {
          await RequestService.setAuthToken(token);
          log('Token saved successfully');
        }
        
        return response;
      }
      
      log('Login failed: ${response?['message']}');
      return response;
    } catch (e) {
      log('Error logging in guest: $e');
      rethrow;
    }
  }
}