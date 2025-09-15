import 'package:maelys_imo/core/api_manager/api_client.dart';
import 'package:maelys_imo/core/api_manager/api_response.dart';
import 'package:maelys_imo/core/api_manager/endpoints.dart';
import 'package:maelys_imo/core/domain/models/index.dart';

abstract class TenantService {
  Future<ApiResponse<List<TenantItemModel>>> tenantByStatus({
    required String status,
  });

  Future<ApiResponse<TenantDetailModel>> showDetailTenant({
    required dynamic id,
  });
}

class TenantServiceImpl implements TenantService {
  final ApiClient apiClient;

  TenantServiceImpl({required this.apiClient});

  @override
  Future<ApiResponse<List<TenantItemModel>>> tenantByStatus({
    required String status,
  }) async {
    final response = await apiClient.get(
      Endpoints.tenantByStatus(status),
      fromJson: (res) {
        if (res is List) {
          return res.map((item) => TenantItemModel.fromMap(item)).toList();
        }
        return <TenantItemModel>[];
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<TenantDetailModel>> showDetailTenant({required id}) async {
    final response = await apiClient.get(
      Endpoints.showDetailTenant(id),
      fromJson: (res) {
        return TenantDetailModel.fromMap(res);
      },
    );
    return response;
  }
}
