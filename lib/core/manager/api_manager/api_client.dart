import 'package:dio/dio.dart';
import '../token_manager.dart';
import 'api_error_handler.dart';
import 'api_interceptor.dart';
import 'api_response.dart';

class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;

  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
    bool enableLogging = true,
    TokenManager? tokenManager,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: Duration(milliseconds: connectTimeout),
           receiveTimeout: Duration(milliseconds: receiveTimeout),
           headers: headers,
         ),
       ),
       _tokenManager = tokenManager ?? TokenManager() {
    _dio.interceptors.add(ApiInterceptor(enableLogging: enableLogging));
    _loadStoredToken();
  }

  /// Charge le token stocké s'il existe
  Future<void> _loadStoredToken() async {
    final token = await _tokenManager.getUserToken();
    if (token != null) {
      addAuthToken(token);
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
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
      return ApiErrorHandler.handleError<T>(e);
    } catch (e) {
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
      return ApiErrorHandler.handleError<T>(e);
    } catch (e) {
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
      return ApiErrorHandler.handleError<T>(e);
    } catch (e) {
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
      return ApiErrorHandler.handleError<T>(e);
    } catch (e) {
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
          fromJson != null && response.data != null
              ? fromJson(response.data)
              : response.data as dynamic;

      return ApiResponse.success(data: data, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(
        message: 'Erreur de conversion des données: ${e.toString()}',
        statusCode: response.statusCode,
        errorType: 'DATA_PARSING_ERROR',
      );
    }
  }

  /// Ajoute le token d'authentification aux en-têtes et le stocke
  Future<void> addAuthToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    await _tokenManager.storeUserToken(token);
  }

  /// Supprime le token d'authentification des en-têtes et du stockage
  Future<void> removeAuthToken() async {
    _dio.options.headers.remove('Authorization');
    await _tokenManager.removeUserToken();
  }

  /// Vérifie si un token est stocké
  Future<bool> hasToken() async {
    return await _tokenManager.hasUserToken();
  }
}
