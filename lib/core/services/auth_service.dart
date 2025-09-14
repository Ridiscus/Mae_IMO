import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';
import '../domain/requests/index.dart';
import '../manager/token_manager.dart';

abstract interface class AuthService {
  Future<ApiResponse<UserModel>> signIn({required LoginRequest dto});

  Future<ApiResponse<String>> updateEmail({required UpdateEmailRequest dto});

  Future<ApiResponse<String>> updatePassword({
    required UpdatePasswordRequest dto,
  });

  Future<ApiResponse<String>> updateProfileImage({
    required UpdateProfileImageRequest dto,
  });
}

class AuthServiceImpl implements AuthService {
  final String TAG = "auth_service";

  final ApiClient apiClient;
  final Endpoints endpoints;

  AuthServiceImpl({required this.apiClient, required this.endpoints});

  @override
  Future<ApiResponse<UserModel>> signIn({required LoginRequest dto}) async {
    final response = await apiClient.post(Endpoints.login, data: dto.toJson());

    if (response.success) {
      final res = response.data;
      var token = res['token'];
      var user = res['user'];
      TokenManager().storeUserToken(token);
      // Utilisation polymorphe : UserModel.fromMap détermine automatiquement le type
      return ApiResponse.success(
        data: UserModel.fromMap({...user, "user_type": res['user_type']}),
      );
    }
    return ApiResponse.error(message: response.message);
  }

  @override
  Future<ApiResponse<String>> updateEmail({
    required UpdateEmailRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.updateEmail,
      data: dto.toJson(),
    );

    if (response.success) {
      return ApiResponse.success(
        message: response.message ?? "Email mis à jour avec succès",
        data: response.data['new_email'],
      );
    }
    return ApiResponse.error(
      message: response.message ?? "Echèc de la mise à jour de l'email",
    );
  }

  @override
  Future<ApiResponse<String>> updatePassword({
    required UpdatePasswordRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.updatePassword,
      data: dto.toJson(),
    );

    if (response.success) {
      return ApiResponse.success(
        message:
            response.data['message'] ?? "Mot de passe mis à jour avec succès",
      );
    }
    return ApiResponse.error(
      message: response.message ?? "Echèc de la mise à jour du mot de passe",
    );
  }

  @override
  Future<ApiResponse<String>> updateProfileImage({
    required UpdateProfileImageRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.updateProfileImage,
      data: dto.toMultipart(),
    );

    if (response.success) {
      return ApiResponse.success(
        message:
            response.data['message'] ??
            "Photo de profil mise à jour avec succès",
        data: response.data['profile_image_url'],
      );
    }
    return ApiResponse.error(
      message: response.message ?? "Echèc de la mise à jour photo de profil",
    );
  }
}
