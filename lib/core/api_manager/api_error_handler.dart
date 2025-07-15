import 'package:dio/dio.dart';

class ApiErrorHandler<T> {
  static dynamic handleError<T>(error) {
    String? errorDescription;
    print("[ApiErrorHandler] error $error runtimeType: ${error.runtimeType}");
    if (error is Exception) {
      try {
        if (error is DioException) {
          print(
            "[ApiErrorHandler] error.response ${error.type} :${error.response.toString()}",
          );

          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "La demande au serveur API a été annulée";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Délai de réception du serveur API";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Délai d'envoi au serveur";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Délai de connexion avec le serveur API";
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              break;

            case DioExceptionType.badResponse:
              if ((error.response?.data is Map) &&
                  (error.response?.data as Map).containsKey("message") &&
                  ((error.response?.data as Map)["message"].toString())
                      .isNotEmpty) {
                final message = error.response?.data['message'];

                if (message.runtimeType == List) {
                  errorDescription = (message as List).firstOrNull;
                } else {
                  errorDescription = error.response?.data['message'];
                }
              }
              break;
            case DioExceptionType.connectionError:
              switch (error.response!.statusCode) {
                case 404:
                  errorDescription = "Format de donnée non valid";
                case 500:
                case 503:
                  errorDescription = "Une erreur est survenue";
                  break;
                default:
                  errorDescription =
                      "La connexion au serveur API a échoué en raison de la connexion internet";
              }
              break;
            case DioExceptionType.unknown:
              errorDescription =
                  "La connexion au serveur a échoué en raison de la connexion internet";
              break;
          }
        } else {
          errorDescription = "Une erreur inattendue s'est produite";
        }
      } on FormatException {
        errorDescription = "Une erreur inattendue s'est produite";
      }
    } else {
      errorDescription = "Une erreur inattendue s'est produite";
    }
    return errorDescription ?? "Une erreur est survenue !";
  }
}
