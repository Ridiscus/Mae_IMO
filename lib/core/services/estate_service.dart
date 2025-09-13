import '../api_manager/api_client.dart';
import '../api_manager/api_paginate_response.dart';
import '../api_manager/api_response.dart';
import '../api_manager/endpoints.dart';
import '../domain/models/index.dart';
import '../domain/requests/index.dart';

abstract interface class EstateService {
  Future<ApiResponse<List<EstateTypeModel>>> estatesType();

  Future<ApiResponse<EstateModel>> estatesDetail({required int id});

  Future<ApiResponse<ApiPaginateResponse<EstateModel>>> estatesAvailable({
    FilterEstateRequest? dto,
  });

  Future<ApiResponse<dynamic>> sendVisiteEstates({
    required VisiteEstateRequest dto,
  });
}

class EstateServiceImpl implements EstateService {
  final ApiClient apiClient;
  final Endpoints endpoints;

  EstateServiceImpl({required this.apiClient, required this.endpoints});

  @override
  Future<ApiResponse<List<EstateTypeModel>>> estatesType() async {
    final response = await apiClient.get(
      Endpoints.estateType,
      fromJson: (res) {
        return List<EstateTypeModel>.from(
          res.map((x) => EstateTypeModel.fromMap(x)),
        );
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<ApiPaginateResponse<EstateModel>>> estatesAvailable({
    FilterEstateRequest? dto,
  }) async {
    final response = await apiClient.get(
      Endpoints.estatesAvailable,
      queryParameters: dto?.toJson(),
      fromJson: (res) => ApiPaginateResponse<EstateModel>.fromMap(res),
    );
    return response;
  }

  @override
  Future<ApiResponse<EstateModel>> estatesDetail({required int id}) async {
    final response = await apiClient.get(
      Endpoints.estatesDetail(id),
      fromJson: (res) => EstateModel.fromMap(res),
    );
    return response;
  }

  @override
  Future<ApiResponse> sendVisiteEstates({
    required VisiteEstateRequest dto,
  }) async {
    final response = await apiClient.post(
      Endpoints.sendVisiteEstates,
      data: dto.toJson(),
    );
    return response;
  }
}
