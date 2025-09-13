import 'dart:developer' as console;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show NavigatorState;
import 'package:flutter/widgets.dart' show GlobalKey;
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart' show PrettyDioLogger;

import '../manager/token_manager.dart';
import 'api_error_handler.dart';
import 'api_response.dart';

class LogoutRedirectConfig {
  final String routeName;
  final GlobalKey<NavigatorState> navigatorKey;

  LogoutRedirectConfig({required this.routeName, required this.navigatorKey});

  void redirect() {
    navigatorKey.currentContext?.goNamed(routeName);
  }
}

class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;
  final LogoutRedirectConfig? logoutRedirectConfig;

  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
    bool enableLogging = kDebugMode,
    TokenManager? tokenManager,
    this.logoutRedirectConfig,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: Duration(milliseconds: connectTimeout),
           receiveTimeout: Duration(milliseconds: receiveTimeout),
           headers: headers,
         ),
       ),
       _tokenManager = tokenManager ?? TokenManager() {
    _dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
        requestBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          var hasUserToken = await _tokenManager.hasUserToken();
          if (hasUserToken) {
            var token = await _tokenManager.getUserToken();
            options.headers["Authorization"] = "Bearer $token";
            options.headers["Content-Type"] = "application/json";
            await _tokenManager.storeUserToken(token!);
          }
          handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenManager.removeUserToken();
            logoutRedirectConfig?.redirect();
            // showToast(
            //   msg: "Vous n'êtes pas autorisé à effectuer cette action !",
            // );
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic res)? fromJson,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(message: ApiErrorHandler.handleError<T>(e));
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return ApiResponse.error(
        message: e.toString(),
        errorType: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(message: ApiErrorHandler.handleError<T>(e));
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return ApiResponse.error(
        message: e.toString(),
        errorType: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(message: ApiErrorHandler.handleError<T>(e));
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return ApiResponse.error(
        message: e.toString(),
        errorType: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(message: ApiErrorHandler.handleError<T>(e));
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return ApiResponse.error(
        message: e.toString(),
        errorType: 'UNEXPECTED_ERROR',
      );
    }
  }

  ApiResponse<T> _processResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      return ApiResponse.error(
        message: 'Erreur de réponse',
        statusCode: response.statusCode,
        errorType: 'RESPONSE_ERROR',
      );
    }

    try {
      final T? data =
          fromJson != null &&
                  response.data != null &&
                  response.data['data'] != null
              ? fromJson(response.data['data'] ?? (response.data as dynamic))
              : response.data as dynamic;

      final message = response.data?['message'];
      console.log(message ?? "", name: "message");

      return ApiResponse.success(data: data, message: message);
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      return ApiResponse.error(
        message: 'Erreur de conversion des données: ${e.toString()}',
        statusCode: response.statusCode,
        errorType: 'DATA_PARSING_ERROR',
      );
    }
  }
}
