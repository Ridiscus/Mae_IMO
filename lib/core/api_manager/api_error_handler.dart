import 'dart:developer' as console;
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

final String TAG = 'ApiErrorHandler';
final int LEVEL = 1;

class ApiErrorHandler<T> {
  static dynamic handleError<T>(error) {
    String? errorDescription;
    developer.log("error $error runtimeType: ${error.runtimeType}", name: TAG);
    if (error is Exception) {
      try {
        if (error is DioException) {
          developer.log(
            "error type: ${error.type} data :${error.response?.data.toString()}",
            name: TAG,
            level: LEVEL,
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
              break;

            case DioExceptionType.badResponse:
              var data = error.response?.data;

              if ((data is Map) &&
                  (data.containsKey("message") || data.containsKey("errors"))) {
                console.log(data['message'], name: TAG);

                final message = data['message'];
                Map? errors = data['errors'];
                errorDescription = (message ?? '').toString();

                if (errors != null) {
                  var error = errors.values.firstOrNull[0] ?? '';
                  errorDescription = "$errorDescription $error";
                }
              }
              break;
            case DioExceptionType.connectionError:
              if (error.response != null) {
                switch (error.response!.statusCode) {
                  case 404:
                    errorDescription = "Format de donnée non valide";
                    break;
                  case 500:
                  case 503:
                    errorDescription = "Une erreur est survenue";
                    break;
                  default:
                    errorDescription =
                        "La connexion au serveur API a échoué en raison de la connexion internet";
                }
              } else {
                errorDescription =
                    "Impossible de joindre le serveur. Veuillez vérifier votre connexion internet.";
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
    return (errorDescription ?? "Une erreur est survenue !").trim();
  }
}
