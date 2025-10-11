import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/models/responses/Inventorie_model_response.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';

import '../api_manager/api_client.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';

abstract interface class InventorieService {
  Future<ApiResponse<InventorieModelResponse>> inventorieList();

  Future<ApiResponse<InventoryDetailModel>> inventorieDetail({
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

  @override
  Future<ApiResponse<InventoryDetailModel>> inventorieDetail({
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
