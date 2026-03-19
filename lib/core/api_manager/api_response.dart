class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic errors;

  ApiResponse({required this.success, this.message, this.data, this.errors});

  factory ApiResponse.success({T? data, String? message, int? statusCode}) {
    return ApiResponse(success: true, data: data, message: message ?? 'Succès');
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
    String? errorType,
    dynamic errors,
  }) {
    return ApiResponse(
      success: false,
      message: message ?? 'Une erreur est survenue',
      errors: errors,
    );
  }

  factory ApiResponse.connectionError() {
    return ApiResponse(
      success: false,
      message: 'Problème de connexion internet',
    );
  }

  factory ApiResponse.timeoutError() {
    return ApiResponse(
      success: false,
      message: 'La requête a pris trop de temps',
    );
  }

  factory ApiResponse.serverError() {
    return ApiResponse(success: false, message: 'Erreur serveur');
  }

  factory ApiResponse.unauthorized() {
    return ApiResponse(success: false, message: 'Non autorisé');
  }

  factory ApiResponse.notFound() {
    return ApiResponse(success: false, message: 'Ressource non trouvée');
  }
}
