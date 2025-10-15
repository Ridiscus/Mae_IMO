import 'package:maelys_imo/core/domain/models/index.dart';
 import 'package:maelys_imo/core/domain/requests/index.dart';

import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';

abstract interface class InventoryService {
  Future<ApiResponse<InventoryModelResponse>> inventoryList();

  Future<ApiResponse<InventoryDetailModel>> inventoryDetail({
    required String id,
  });

  Future<ApiResponse<dynamic>> generateCodeEtatLieux(
    GenerateCodeEtatLieuxRequest request,
  );

  Future<ApiResponse<dynamic>> verifyCodeEtatLieux(
    VerifyCodeEtatLieuxRequest request,
  );

  Future<ApiResponse<dynamic>> saveEstateLocation(
    SaveEstateLocationRequest request,
  );
}

class InventoryServiceImpl implements InventoryService {
  final ApiClient apiClient;

  InventoryServiceImpl({required this.apiClient});

  @override
  Future<ApiResponse<InventoryModelResponse>> inventoryList() async {
    final response = await apiClient.get(
      Endpoints.inventories,
      fromJson: (res) {
        return InventoryModelResponse.fromMap(res);
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<InventoryDetailModel>> inventoryDetail({
    required String id,
  }) async {
    final response = await apiClient.get(
      Endpoints.inventoriesShow(id),
      fromJson: (res) {
        return InventoryDetailModel.fromMap(res);
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<dynamic>> generateCodeEtatLieux(
    GenerateCodeEtatLieuxRequest request,
  ) async {
    final response = await apiClient.post(
      Endpoints.generateCodeEtatLieux,
      data: request.toJson(),
    );
    return response;
  }

  @override
  Future<ApiResponse<dynamic>> verifyCodeEtatLieux(
    VerifyCodeEtatLieuxRequest request,
  ) async {
    final response = await apiClient.post(
      Endpoints.verifyCodeEtatLieux,
      data: request.toJson(),
    );
    return response;
  }

  @override
  Future<ApiResponse<dynamic>> saveEstateLocation(
    SaveEstateLocationRequest request,
  ) async {
    final response = await apiClient.post(
      Endpoints.saveEstateLocation,
      data: request.toJson(),
    );
    return response;
  }
}
