
import 'dart:io' show SocketException;

import 'package:dio/dio.dart' show DioException, DioExceptionType;

import 'api_response.dart';

class ApiErrorHandler {
  static ApiResponse<T> handleError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse.timeoutError();
        
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return ApiResponse.connectionError();
        
      case DioExceptionType.badResponse:
        return _handleResponseError<T>(error.response?.data);
      case DioExceptionType.cancel:
        return ApiResponse.error(
          message: 'Requête annulée',
          errorType: 'REQUEST_CANCELLED',
        );
        
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ApiResponse.connectionError();
        }
        return ApiResponse.error(
          message: error.message,
          errorType: 'UNKNOWN_ERROR',
        );
    }
  }

  static ApiResponse<T> _handleResponseError<T>( dynamic data) {
    Map<String, dynamic> error = data as Map<String, dynamic>;
    String? message = error['message'];
    int? statusCode = error['StatusCode'];
    String? errorCode = error['error'];
    
    switch (statusCode) {
      case 400:
        return ApiResponse.error(
          message: message ?? 'Requête invalide',
          statusCode: statusCode,
          errorType: errorCode ?? 'BAD_REQUEST',
        );
      case 401:
        return ApiResponse.unauthorized();
      case 403:
        return ApiResponse.error(
          message: message ?? 'Accès refusé',
          statusCode: statusCode,
          errorType: errorCode ?? 'FORBIDDEN',
        );
      case 404:
        return ApiResponse.notFound();
      case 500:
      case 501:
      case 502:
      case 503:
        return ApiResponse.serverError();
      default:
        return ApiResponse.error(
          message: message ?? 'Erreur inconnue',
          statusCode: statusCode,
          errorType: errorCode ?? 'UNKNOWN_ERROR',
        );
    }
  }
}
