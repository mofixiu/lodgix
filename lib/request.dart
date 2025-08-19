import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

const host = "https://enjoyed-kid-amusing.ngrok-free.app";
// const host = "http://172.20.10.6:3000";
const baseUrl = "$host"; // NO /api suffix

class RequestService {
  static final Dio _dio = Dio();
  static String? _authToken;
  static bool _isInitialized = false;

  static void initialize() {
    if (_isInitialized) return;
    
    _dio.options.baseUrl = baseUrl; // Just the host
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST: ${options.method} ${baseUrl}${options.path}');
          log('DATA: ${options.data}');
          
          // Only add auth token for protected routes (those starting with /api)
          if (_authToken != null && options.path.startsWith('/api')) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          log('RESPONSE DATA: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          log('ERROR: ${error.message}');
          log('ERROR RESPONSE: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
    
    _isInitialized = true;
    log('RequestService initialized with baseUrl: $baseUrl');
  }

  static bool get isInitialized => _isInitialized;

  static Future<Map<String, dynamic>?> post(String path, Map<String, dynamic> data) async {
    if (!_isInitialized) {
      initialize();
    }
    
    try {
      log('Making POST request to: $path');
      final response = await _dio.post(path, data: data);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      
      return null;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response!.data}');
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      log('General error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> get(String path) async {
    if (!_isInitialized) {
      initialize();
    }
    
    try {
      final response = await _dio.get(path);
      
      if (response.statusCode == 200) {
        return response.data;
      }
      
      return null;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response!.data}');
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      log('General error: $e');
      rethrow;
    }
  }

  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    try {
      final box = await Hive.openBox('auth');
      await box.put('token', token);
      log('Auth token saved');
    } catch (e) {
      log('Error saving auth token: $e');
    }
  }

  static Future<void> loadAuthToken() async {
    try {
      final box = await Hive.openBox('auth');
      _authToken = box.get('token');
      if (_authToken != null) {
        log('Auth token loaded');
      }
    } catch (e) {
      log('Error loading auth token: $e');
    }
  }

  static Future<void> clearAuthToken() async {
    _authToken = null;
    try {
      final box = await Hive.openBox('auth');
      await box.delete('token');
      log('Auth token cleared');
    } catch (e) {
      log('Error clearing auth token: $e');
    }
  }
}

// Backward compatibility functions
Future<Map<String, dynamic>?> post(String path, Map<String, dynamic> data) {
  return RequestService.post(path, data);
}

Future<Map<String, dynamic>?> get(String path) {
  return RequestService.get(path);
}

Future<void> setAuthToken(String token) {
  return RequestService.setAuthToken(token);
}

Future<void> loadAuthToken() {
  return RequestService.loadAuthToken();
}

Future<void> clearAuthToken() {
  return RequestService.clearAuthToken();
}




