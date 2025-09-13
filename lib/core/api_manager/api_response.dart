class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  ApiResponse({required this.success, this.message, this.data});

  factory ApiResponse.success({T? data, String? message, int? statusCode}) {
    return ApiResponse(success: true, data: data, message: message ?? 'Succès');
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
    String? errorType,
  }) {
    return ApiResponse(
      success: false,
      message: message ?? 'Une erreur est survenue',
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
