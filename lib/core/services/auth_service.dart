import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';
import '../domain/requests/index.dart';
import '../manager/token_manager.dart';

abstract interface class AuthService {
  Future<ApiResponse<UserModel>> signIn({required LoginRequest dto});
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
}
