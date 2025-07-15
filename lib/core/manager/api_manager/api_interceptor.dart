import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptor extends Interceptor {
  final bool enableLogging;
  
  ApiInterceptor({this.enableLogging = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableLogging) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableLogging) {
      _logResponse(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLogging) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    debugPrint('┌────────────────────────────────────────────');
    debugPrint('│ 🌐 REQUEST: ${options.method} ${options.uri}');
    debugPrint('│ Headers: ${options.headers}');
    debugPrint('│ Data: ${options.data}');
    debugPrint('└────────────────────────────────────────────');
  }

  void _logResponse(Response response) {
    debugPrint('┌────────────────────────────────────────────');
    debugPrint('│ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('│ Data: ${response.data}');
    debugPrint('└────────────────────────────────────────────');
  }

  void _logError(DioException err) {
    debugPrint('┌────────────────────────────────────────────');
    debugPrint('│ ❌ ERROR: ${err.type} ${err.requestOptions.uri}');
    debugPrint('│ Message: ${err.message}');
    debugPrint('│ Response: ${err.response?.data}');
    debugPrint('└────────────────────────────────────────────');
  }
}
