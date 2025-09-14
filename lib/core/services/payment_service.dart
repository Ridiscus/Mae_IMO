import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';

abstract interface class PaymentService {
  Future<ApiResponse<List<PaymentHistoryModel>>> paymentHistory({
    required int tenantId,
  });
}

class PaymentServiceImpl implements PaymentService {
  final ApiClient apiClient;
  final Endpoints endpoints;

  PaymentServiceImpl({required this.apiClient, required this.endpoints});

  @override
  Future<ApiResponse<List<PaymentHistoryModel>>> paymentHistory({
    required int tenantId,
  }) async {
    final response = await apiClient.get(
      Endpoints.paymentsHistory(tenantId),
      fromJson: (res) {
        return List<PaymentHistoryModel>.from(
          (res['locataire']['paiements'] ?? []).map(
            (x) => PaymentHistoryModel.fromMap(x),
          ),
        );
      },
    );
    return response;
  }
}
