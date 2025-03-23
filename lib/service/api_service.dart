import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://yourapi.com/api", // Change this to your API base URL
    connectTimeout: const Duration(seconds: 10), // Timeout after 10 seconds
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  ));

  ApiService() {
    // Add interceptors for logging
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// **GET request**
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: queryParams);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw ApiException("Bad Request: ${response.data}");
      case 401:
        throw ApiException("Unauthorized: ${response.data}");
      case 403:
        throw ApiException("Forbidden: ${response.data}");
      case 404:
        throw ApiException("Not Found: ${response.data}");
      case 500:
        throw ApiException("Server Error: ${response.data}");
      default:
        throw ApiException("Unexpected Error: ${response.data}");
    }
  }

  ApiException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException("Request timed out. Please try again.");
    } else if (error.type == DioExceptionType.badResponse) {
      return ApiException("Bad response: ${error.response?.data}");
    } else if (error.type == DioExceptionType.cancel) {
      return ApiException("Request was cancelled.");
    } else if (error.type == DioExceptionType.connectionError) {
      return ApiException("No internet connection.");
    } else {
      return ApiException("Something went wrong: ${error.message}");
    }
  }
}

/// **Custom Exception Class**
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
