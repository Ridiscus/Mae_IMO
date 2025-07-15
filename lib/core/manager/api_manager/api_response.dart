

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final String? errorType;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
    this.errorType,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message ?? 'Succès',
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
    String? errorType,
  }) {
    return ApiResponse(
      success: false,
      message: message ?? 'Une erreur est survenue',
      statusCode: statusCode,
      errorType: errorType,
    );
  }

  factory ApiResponse.connectionError() {
    return ApiResponse(
      success: false,
      message: 'Problème de connexion internet',
      errorType: 'CONNECTION_ERROR',
    );
  }

  factory ApiResponse.timeoutError() {
    return ApiResponse(
      success: false,
      message: 'La requête a pris trop de temps',
      errorType: 'TIMEOUT_ERROR',
    );
  }

  factory ApiResponse.serverError() {
    return ApiResponse(
      success: false,
      message: 'Erreur serveur',
      statusCode: 500,
      errorType: 'SERVER_ERROR',
    );
  }

  factory ApiResponse.unauthorized() {
    return ApiResponse(
      success: false,
      message: 'Non autorisé',
      statusCode: 401,
      errorType: 'UNAUTHORIZED',
    );
  }

  factory ApiResponse.notFound() {
    return ApiResponse(
      success: false,
      message: 'Ressource non trouvée',
      statusCode: 404,
      errorType: 'NOT_FOUND',
    );
  }
}