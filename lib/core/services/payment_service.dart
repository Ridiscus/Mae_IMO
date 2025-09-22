import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';
import '../domain/requests/index.dart';

abstract interface class PaymentService {
  Future<ApiResponse<List<PaymentHistoryModel>>> paymentHistory({
    required int tenantId,
  });

  Future<ApiResponse<Map<String, dynamic>>> makePayment({
    required int tenantId,
    required MakePaymentRequest request,
  });
}

class PaymentServiceImpl implements PaymentService {
  final ApiClient apiClient;

  PaymentServiceImpl({required this.apiClient});

  @override
  Future<ApiResponse<List<PaymentHistoryModel>>> paymentHistory({
    required int tenantId,
  }) async {
    final response = await apiClient.get(
      Endpoints.paymentsHistory(tenantId),
      fromJson: (res) {
        var items = List<PaymentHistoryModel>.from(
          (res['locataire']['paiements'] ?? []).map(
            (x) => PaymentHistoryModel.fromMap(x),
          ),
        );
        items.sort(
          (a, b) => (b.createdAt?.toIso8601String() ?? "").compareTo(
            (a.createdAt?.toIso8601String() ?? ""),
          ),
        );
        return items;
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> makePayment({
    required int tenantId,
    required MakePaymentRequest request,
  }) async {
    final response = await apiClient.post(
      Endpoints.makePayment(tenantId),
      data: request.toMultipart(),
    );

    if (response.success) {
      return ApiResponse.success(
        message: response.data['message'] ?? "Paiement enregistré avec succès",
      );
    }
    return ApiResponse.error(
      message: response.message ?? "Erreur lors du paiement",
    );
  }
}
