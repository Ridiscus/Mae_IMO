import 'package:maelys_imo/core/api_manager/api_client.dart';
import 'package:maelys_imo/core/api_manager/api_response.dart';
import 'package:maelys_imo/core/api_manager/endpoints.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';

abstract interface class ResetPasswordService {
  Future<ApiResponse<String>> forgotPassword({required ForgotPasswordRequest dto});
}

class ResetPasswordServiceImpl implements ResetPasswordService {
  final ApiClient apiClient;

  ResetPasswordServiceImpl({required this.apiClient});

  @override
  Future<ApiResponse<String>> forgotPassword({
    required ForgotPasswordRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.forgotPassword,
      data: dto.toJson(),
    );

    if (response.success) {
      return ApiResponse.success(
        message: response.data['message'] ?? "Un lien de réinitialisation a été envoyé à votre email",
        data: response.data['message'],
      );
    }
    return ApiResponse.error(
      message: response.message ?? "Erreur lors de l'envoi du lien de réinitialisation",
    );
  }
}
