import 'package:maelys_imo/core/domain/requests/index.dart';

import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';

abstract interface class DashboardService {
  Future<ApiResponse<TenantDashboardModel>> tenantDashboard();

  Future<ApiResponse<String>> contactAgency({
    required ContactAgencyRequest dto,
  });

  Future<ApiResponse<AgentDashboardModel>> agentDashboard();
}

class DashboardServiceImpl implements DashboardService {
  final ApiClient apiClient;
  final Endpoints endpoints;

  DashboardServiceImpl({required this.apiClient, required this.endpoints});

  @override
  Future<ApiResponse<TenantDashboardModel>> tenantDashboard() async {
    final response = await apiClient.get(
      Endpoints.tenantDashboard,
      fromJson: (res) {
        return TenantDashboardModel.fromMap(res);
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<String>> contactAgency({
    required ContactAgencyRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.contactAgency,
      data: dto.toJson(),
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(message: response.message);
  }

  @override
  Future<ApiResponse<AgentDashboardModel>> agentDashboard() async {
    final response = await apiClient.get(
      Endpoints.agentDashboard,
      fromJson: (res) {
        return AgentDashboardModel.fromMap(res);
      },
    );
    return response;
  }
}
