import 'package:maelys_imo/core/domain/models/responses/Inventorie_model_response.dart';

import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';

abstract interface class InventorieService {
  Future<ApiResponse<InventorieModelResponse>> inventorieList();
}

class InventorieServiceImpl implements InventorieService {
  final ApiClient apiClient;

  InventorieServiceImpl({required this.apiClient});

  @override
  Future<ApiResponse<InventorieModelResponse>> inventorieList() async {
    final response = await apiClient.get(
      Endpoints.inventories,
      fromJson: (res) {
        return InventorieModelResponse.fromMap(res);
      },
    );
    return response;
  }
}
