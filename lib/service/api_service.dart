// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  // Constructor for ApiService to initialize Dio with the necessary configurations
  ApiService() {
    _dio.options.baseUrl =
        'https://balitripapi.onrender.com'; // Your API's base URL
    _dio.options.connectTimeout =
        Duration(milliseconds: 5000); // 20 seconds timeout for connection
    _dio.options.receiveTimeout =
        Duration(milliseconds: 5000); // 20 seconds timeout for receiving data


    _dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              // Log the request
              print("Request: ${options.method} ${options.uri}");
              print("Headers: ${options.headers}");
              print("Body: ${options.data}");
              return handler.next(options); // Continue with the request
            },
            onResponse: (response, handler) {
              // Log the response
              print("Response: ${response.statusCode} ${response.requestOptions.uri}");
              print("Response Body: ${response.data}");
              return handler.next(response); // Continue with the response
            },
            onError: (DioError e, handler) {
              // Log the error
              print("Error: ${e.message}");
              if (e.response != null) {
                print("Error Response: ${e.response?.data}");
              }
              return handler.next(e); // Continue with the error
            },
          ),
        );        
  }


  // Login user
  Future<Response> loginUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/login', data: data);

      if (response.statusCode == 201) {
        print('Login successful: ${response.data}');
        return response; // Successful login
      } else {
        // Handle error response
        throw Exception('Failed to login. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');

      if (e is DioException) {
        // Check DioError and provide custom error messages
        if (e.response != null) {
          // Handle specific status codes
          if (e.response?.statusCode == 401) {
            throw Exception('Unauthorized: Invalid credentials');
          } else {
            throw Exception('API Error: ${e.response?.statusCode}');
          }
        } else {
          throw Exception(
              'Network Error: Please check your internet connection');
        }
      } else {
        throw Exception('Unknown error occurred');
      }
    }
  }

  // Register User
    Future<Response> registerUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register', data: data);

      if (response.statusCode == 201) {
        print('Registration successful: ${response.data}');
        return response; 
      } else {
        // Handle error response
        throw Exception('Failed to register. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');

      if (e is DioException) {
        // Check DioError and provide custom error messages
        if (e.response != null) {
          // Handle specific status codes
          if (e.response?.statusCode == 401) {
            throw Exception('Unauthorized: Invalid credentials');
          } else {
            throw Exception('API Error: ${e.response?.statusCode}');
          }
        } else {
          throw Exception(
              'Network Error: Please check your internet connection');
        }
      } else {
        throw Exception('Unknown error occurred');
      }
    }
  }

  // AHP Calculation
  Future<Response> ratePairWise(Map<String, dynamic> data) async {
    try {
      // Retrieve token from local storage (SharedPreferences in this case)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Replace 'auth_token' with the key you used

      final response = await _dio.post(
        '/ahp/rate-multiple', 
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add token to the Authorization header
          },
      ),
    );

      if (response.statusCode == 201) {
        print('AHP calculation successful: ${response.data}');
        return response; // Return the successful response
      } else {
        // Handle error response
        throw Exception('Failed. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during AHP calculation: $e');

      // Return an empty response in case of error, or rethrow the exception
      if (e is DioException) {
        if (e.response != null) {
          // If a DioException occurs with a response, return it
          return e.response!; // Ensure it's not null
        } else {
          // If no response, throw a generic error
          throw Exception('Unknown error occurred');
        }
      } else {
        // Handle other types of exceptions
        throw Exception('An unexpected error occurred');
      }
    }
  }


}
