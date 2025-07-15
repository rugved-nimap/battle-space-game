import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_game/network/interceptor/logging_interceptor.dart';
import 'package:flutter_game/utils/app_storage.dart';

class ApiClient {
  ApiClient._();

  static ApiClient instance = ApiClient._();

  late final Dio _dio;
  final String _baseurl = "https://battlespace.onrender.com/api";

  String get baseUrl => _baseurl;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseurl,
      headers: {
        if (AppStorage.valueFor(StorageKey.accessToken) != null) "Authorization": "Bearer ${AppStorage.valueFor(StorageKey.accessToken)}",
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ));


    _dio.interceptors.addAll([
      LoggingInterceptor(),
    ]);
  }

  void addHeaderToDio() {
    _dio.options.headers.addAll({"Authorization": "Bearer ${AppStorage.valueFor(StorageKey.accessToken)}"});
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic> query = const {}, Map? data}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: query, data: data);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  ///POST:
  ///
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(body));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  ///PUT
  ///
  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final response = await _dio.put(endpoint, data: jsonEncode(body));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  ///DELETE:
  ///
  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    try {
      final response = await _dio.delete(endpoint, data: body != null ? jsonEncode(body) : null);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> _handleError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionError) {
        return Future.error("Looks like you are not connected to internet.");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return Future.error("Server not reachable at this moment.Please try after sometime.");
      }
      if (e.type == DioExceptionType.sendTimeout) {
        return Future.error("Request timeout. Unable to send data to the server.");
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        return Future.error("Response timeout. The server is taking too long to send data.");
      }
      switch (e.response?.statusCode) {
        case 400:
          return Future.error(e.response?.data['message'] ?? "The request contains bad syntax or cannot be fulfilled");
        case 401:
          return Future.error(e.response?.data['message'] ?? "You are unauthorized to access this resource");
        case 403:
          return Future.error(e.response?.data['message'] ?? "You do not have the required permissions to access this resource.");
        case 500:
          return Future.error(e.response?.data['message'] ?? "Server not reachable at this moment. Please try after sometime.");
        case 502:
          return Future.error(e.response?.data['message'] ?? "Server not reachable at this moment. Please try after sometime.");
      }
      return Future.error(e.message ?? 'Something went wrong.Please Try Again');
    } else {
      return Future.error("Something went wrong. Please Try Again");
    }
  }
}
