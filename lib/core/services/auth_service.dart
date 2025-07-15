import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';
import '../domain/requests/index.dart';
import '../manager/token_manager.dart';

final String TAG = "[auth_service.dart]";

abstract interface class AuthService {
  Future<ApiResponse<AccountModel>> signIn({required LoginRequest dto});
}

class AuthServiceImpl implements AuthService {
  final ApiClient apiClient;
  final Endpoints endpoints;

  AuthServiceImpl({required this.apiClient, required this.endpoints});

  @override
  Future<ApiResponse<AccountModel>> signIn({required LoginRequest dto}) async {
    final response = await apiClient.post(
      Endpoints.login,
      data: dto.toJson(),
      fromJson: (res) {
        var token = res['jwt'];
        var user = res['user'];
        TokenManager().storeUserToken(token);
        return AccountModel.fromMap(user);
      },
    );
    return response;
  }
}
