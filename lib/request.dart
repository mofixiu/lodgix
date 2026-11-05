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
          
          // Send the token whenever we have one; every route the app calls
          // (/users/..., /guests/...) may need it.
          if (_authToken != null) {
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

  static Future<Map<String, dynamic>?> patch(String path, Map<String, dynamic> data) async {
    if (!_isInitialized) {
      initialize();
    }
    
    try {
      log('Making PATCH request to: $path');
      log('PATCH data: $data');
      
      final response = await _dio.patch(path, data: data);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('PATCH response: ${response.data}');
        return response.data;
      }
      
      return null;
    } on DioException catch (e) {
      log('PATCH DioException: ${e.message}');
      if (e.response != null) {
        log('PATCH Error response: ${e.response!.data}');
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      log('PATCH General error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> put(String path, Map<String, dynamic> data) async {
    if (!_isInitialized) {
      initialize();
    }
    
    try {
      log('Making PUT request to: $path');
      log('PUT data: $data');
      
      final response = await _dio.put(path, data: data);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('PUT response: ${response.data}');
        return response.data;
      }
      
      return null;
    } on DioException catch (e) {
      log('PUT DioException: ${e.message}');
      if (e.response != null) {
        log('PUT Error response: ${e.response!.data}');
        return e.response!.data;
      }
      rethrow;
    } catch (e) {
      log('PUT General error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> delete(String endpoint) async {
    try {
      if (!isInitialized) {
        throw Exception('RequestService not initialized');
      }

      log('DELETE Request to: $baseUrl$endpoint');
      
      final response = await _dio.delete(
        endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (_authToken != null) 'Authorization': 'Bearer $_authToken',
          },
        ),
      );

      log('DELETE Response: ${response.data}');
      return response.data;
    } catch (e) {
      log('DELETE Error: $e');
      rethrow;
    }
  }

  static Future<void> setAuthToken(String token) async {
    try {
      _authToken = token;
      log('Auth token set');
      
      // Save to Hive for persistence
      final box = await Hive.openBox('auth');
      await box.put('token', token);
      log('Auth token saved to storage');
    } catch (e) {
      log('Error setting auth token: $e');
    }
  }

  static Future<void> loadAuthToken() async {
    try {
      final box = await Hive.openBox('auth');
      _authToken = box.get('token');
      if (_authToken != null) {
        log('Auth token loaded from storage');
      } else {
        log('No auth token found in storage');
      }
    } catch (e) {
      log('Error loading auth token: $e');
    }
  }

  static Future<void> clearAuthToken() async {
    try {
      _authToken = null;
      log('Auth token cleared from memory');
      
      final box = await Hive.openBox('auth');
      await box.delete('token');
      log('Auth token cleared from storage');
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

Future<Map<String, dynamic>?> patch(String path, Map<String, dynamic> data) {
  return RequestService.patch(path, data);
}

Future<Map<String, dynamic>?> put(String path, Map<String, dynamic> data) {
  return RequestService.put(path, data);
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




