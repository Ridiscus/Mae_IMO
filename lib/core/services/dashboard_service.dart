import 'dart:io';

import 'package:dio/dio.dart';
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
  Future<ApiResponse<CommercialDashboardModel>> commercialDashboard();
  Future<ApiResponse<List<AgencyModel>>> commercialAgences();
  Future<ApiResponse<List<OwnerModel>>> commercialOwners();
  Future<ApiResponse<List<PropertyModel>>> commercialProperties();
  Future<ApiResponse<String>> createAgency({
    required String name,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    required String rccm,
    required String dfe,
    File? rib,
    File? rccmFile,
    File? dfeFile,
    File? profileImage,
  });

  Future<ApiResponse<String>> createOwner({
    required String name,
    required String prenom,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    File? profileImage,
    File? cniFile,
  });

  Future<ApiResponse<String>> createAgencyProperty({
    required String agenceId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    File? mainImage,
    List<File?>? additionalImages,
  });

  Future<ApiResponse<String>> createOwnerProperty({
    required String ownerId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    File? mainImage,
    List<File?>? additionalImages,
  });

  Future<ApiResponse<String>> updateProperty({
    required dynamic propertyId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    String? paymentDay,
    File? mainImage,
    List<File?>? additionalImages,
  });

  Future<ApiResponse<String>> updateAgency({
    required dynamic id,
    required String name,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    required String rccm,
    required String dfe,
    File? rib,
    File? rccmFile,
    File? dfeFile,
    File? profileImage,
  });

  Future<ApiResponse<String>> updateOwner({
    required dynamic id,
    required String name,
    required String prenom,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    File? profileImage,
    File? cniFile,
    File? ribFile,
  });

  Future<ApiResponse<String>> deleteProperty(dynamic id);
  Future<ApiResponse<String>> deleteOwner(dynamic id);
  Future<ApiResponse<String>> deleteAgency(dynamic id);
}

class DashboardServiceImpl implements DashboardService {
  final ApiClient apiClient;

  DashboardServiceImpl({required this.apiClient});

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

  @override
  Future<ApiResponse<CommercialDashboardModel>> commercialDashboard() async {
    final response = await apiClient.get(
      Endpoints.commercialDashboard,
      fromJson: (res) {
        return CommercialDashboardModel.fromMap(res);
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<List<AgencyModel>>> commercialAgences() async {
    final response = await apiClient.get(
      Endpoints.commercialAgences,
      fromJson: (res) {
        return List<AgencyModel>.from(
          res["agences"].map((x) => AgencyModel.fromMap(x)),
        );
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<List<OwnerModel>>> commercialOwners() async {
    final response = await apiClient.get(
      Endpoints.commercialOwners,
      fromJson: (res) {
        return List<OwnerModel>.from(
          res["proprietaires"].map((x) => OwnerModel.fromMap(x)),
        );
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<List<PropertyModel>>> commercialProperties() async {
    final response = await apiClient.get(
      Endpoints.commercialProperties,
      fromJson: (res) {
        return List<PropertyModel>.from(
          res["biens"].map((x) => PropertyModel.fromMap(x)),
        );
      },
    );
    return response;
  }

  @override
  Future<ApiResponse<String>> createAgency({
    required String name,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    required String rccm,
    required String dfe,
    File? rib,
    File? rccmFile,
    File? dfeFile,
    File? profileImage,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'contact': contact,
      'commune': commune,
      'adresse': adresse,
      'rccm': rccm,
      'dfe': dfe,
      if (rib != null) 'rib': await MultipartFile.fromFile(rib.path),
      if (rccmFile != null)
        'rccm_file': await MultipartFile.fromFile(rccmFile.path),
      if (dfeFile != null)
        'dfe_file': await MultipartFile.fromFile(dfeFile.path),
      if (profileImage != null)
        'profile_image': await MultipartFile.fromFile(profileImage.path),
    });

    final response = await apiClient.post(
      Endpoints.commercialAgences,
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> createOwner({
    required String name,
    required String prenom,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    File? profileImage,
    File? cniFile,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'prenom': prenom,
      'email': email,
      'contact': contact,
      'commune': commune,
      'adresse': adresse,
      if (profileImage != null)
        'profil_image': await MultipartFile.fromFile(profileImage.path),
      if (cniFile != null) 'cni': await MultipartFile.fromFile(cniFile.path),
    });

    final response = await apiClient.post(
      Endpoints.commercialOwners,
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> createAgencyProperty({
    required String agenceId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    File? mainImage,
    List<File?>? additionalImages,
  }) async {
    final Map<String, dynamic> data = {
      "type": type,
      "utilisation": utilisation,
      "description": description,
      "superficie": superficie.toString(),
      "avance": avance.toString(),
      "caution": caution.toString(),
      "prix": prix.toString(),
      "commune": commune,
      "disponibilite": disponibilite,
      "agence_id": agenceId,
      "nombre_de_chambres": nombreDeChambres.toString(),
      "nombre_de_toilettes": nombreDeToilettes.toString(),
      "garage": garage ? "1" : "0",
      "frais": frais.toString(),
      if (video3d != null) "video_3d": video3d,
    };

    if (mainImage != null) {
      final file = await MultipartFile.fromFile(
        mainImage.path,
        filename: mainImage.path.split('/').last,
      );
      data["main_image"] = file;
      data["image1"] = file;
    }

    if (additionalImages != null) {
      for (int i = 0; i < additionalImages.length; i++) {
        final image = additionalImages[i];
        if (image != null) {
          data["additional_images${i + 1}"] = await MultipartFile.fromFile(
            image.path,
          );
        }
      }
    }

    final formData = FormData.fromMap(data);

    final response = await apiClient.post(
      Endpoints.commercialAgencyProperties(agenceId),
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> createOwnerProperty({
    required String ownerId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    File? mainImage,
    List<File?>? additionalImages,
  }) async {
    final Map<String, dynamic> data = {
      "type": type,
      "utilisation": utilisation,
      "description": description,
      "superficie": superficie.toString(),
      "avance": avance.toString(),
      "caution": caution.toString(),
      "prix": prix.toString(),
      "commune": commune,
      "disponibilite": disponibilite,
      "proprietaire_id": ownerId,
      "nombre_de_chambres": nombreDeChambres.toString(),
      "nombre_de_toilettes": nombreDeToilettes.toString(),
      "garage": garage ? "1" : "0",
      "frais": frais.toString(),
      if (video3d != null) "video_3d": video3d,
    };

    if (mainImage != null) {
      data["main_image"] = await MultipartFile.fromFile(
        mainImage.path,
        filename: mainImage.path.split('/').last,
      );
      data["image1"] = await MultipartFile.fromFile(
        mainImage.path,
        filename: mainImage.path.split('/').last,
      );
    }

    if (additionalImages != null) {
      for (int i = 0; i < additionalImages.length; i++) {
        final image = additionalImages[i];
        if (image != null) {
          data["additional_images${i + 1}"] = await MultipartFile.fromFile(
            image.path,
          );
        }
      }
    }

    final formData = FormData.fromMap(data);

    final response = await apiClient.post(
      Endpoints.commercialOwnerProperties(ownerId),
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  Future<ApiResponse<String>> updateProperty({
    required dynamic propertyId,
    required String type,
    required String utilisation,
    required String description,
    required double superficie,
    required int avance,
    required int caution,
    required double prix,
    required String commune,
    required String disponibilite,
    required int nombreDeChambres,
    required int nombreDeToilettes,
    required bool garage,
    required int frais,
    String? video3d,
    String? paymentDay,
    File? mainImage,
    List<File?>? additionalImages,
  }) async {
    final Map<String, dynamic> data = {
      "type": type,
      "utilisation": utilisation,
      "description": description,
      "superficie": superficie.toString(),
      "avance": avance.toString(),
      "caution": caution.toString(),
      "prix": prix.toString(),
      "commune": commune,
      "disponibilite": disponibilite,
      "nombre_de_chambres": nombreDeChambres.toString(),
      "nombre_de_toilettes": nombreDeToilettes.toString(),
      "garage": garage ? "1" : "0",
      "frais": frais.toString(),
      if (video3d != null && video3d.isNotEmpty) "video_3d": video3d,
      if (paymentDay != null && paymentDay.isNotEmpty) "date_fixe": paymentDay,
    };

    if (mainImage != null) {
      final file = await MultipartFile.fromFile(
        mainImage.path,
        filename: mainImage.path.split('/').last,
      );
      data["main_image"] = file;
      data["image1"] = file;
    }

    if (additionalImages != null) {
      for (int i = 0; i < additionalImages.length; i++) {
        final image = additionalImages[i];
        if (image != null) {
          data["additional_images${i + 1}"] = await MultipartFile.fromFile(
            image.path,
          );
        }
      }
    }

    final formData = FormData.fromMap(data);

    final response = await apiClient.post(
      Endpoints.updateProperty(propertyId),
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> updateAgency({
    required dynamic id,
    required String name,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    required String rccm,
    required String dfe,
    File? rib,
    File? rccmFile,
    File? dfeFile,
    File? profileImage,
  }) async {
    final Map<String, dynamic> fields = {
      'name': name,
      'email': email,
      'contact': contact,
      'commune': commune,
      'adresse': adresse,
      'rccm': rccm,
      'dfe': dfe,
    };

    if (rib != null) {
      fields['rib'] = await MultipartFile.fromFile(
        rib.path,
        filename: rib.path.split('/').last,
      );
      fields['rib_file'] = await MultipartFile.fromFile(
        rib.path,
        filename: rib.path.split('/').last,
      );
    }
    if (rccmFile != null) {
      fields['rccm_file'] = await MultipartFile.fromFile(
        rccmFile.path,
        filename: rccmFile.path.split('/').last,
      );
      fields['rccm'] = await MultipartFile.fromFile(
        rccmFile.path,
        filename: rccmFile.path.split('/').last,
      );
    }
    if (dfeFile != null) {
      fields['dfe_file'] = await MultipartFile.fromFile(
        dfeFile.path,
        filename: dfeFile.path.split('/').last,
      );
      fields['dfe'] = await MultipartFile.fromFile(
        dfeFile.path,
        filename: dfeFile.path.split('/').last,
      );
    }
    if (profileImage != null) {
      fields['profile_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
      fields['profil_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await apiClient.post(
      Endpoints.updateAgency(id),
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }

    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> updateOwner({
    required dynamic id,
    required String name,
    required String prenom,
    required String email,
    required String contact,
    required String commune,
    required String adresse,
    File? profileImage,
    File? cniFile,
    File? ribFile,
  }) async {
    // Construction impérative de la map pour garantir que les fichiers
    // sont bien traités avec await avant d'être passés à FormData.fromMap
    final Map<String, dynamic> fields = {
      'name': name,
      'prenom': prenom,
      'email': email,
      'contact': contact,
      'commune': commune,
      'adresse': adresse,
    };

    if (profileImage != null) {
      fields['profil_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
      fields['profile_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }
    if (cniFile != null) {
      fields['cni'] = await MultipartFile.fromFile(
        cniFile.path,
        filename: cniFile.path.split('/').last,
      );
      fields['cni_file'] = await MultipartFile.fromFile(
        cniFile.path,
        filename: cniFile.path.split('/').last,
      );
    }
    if (ribFile != null) {
      fields['rib'] = await MultipartFile.fromFile(
        ribFile.path,
        filename: ribFile.path.split('/').last,
      );
      fields['rib_file'] = await MultipartFile.fromFile(
        ribFile.path,
        filename: ribFile.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await apiClient.post(
      Endpoints.updateOwner(id),
      data: formData,
    );

    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<String>> deleteProperty(dynamic id) async {
    final response = await apiClient.delete(Endpoints.deleteProperty(id));
    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(message: response.message);
  }

  @override
  Future<ApiResponse<String>> deleteOwner(dynamic id) async {
    final response = await apiClient.delete(Endpoints.deleteOwner(id));
    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(message: response.message);
  }

  @override
  Future<ApiResponse<String>> deleteAgency(dynamic id) async {
    final response = await apiClient.delete(Endpoints.deleteAgency(id));
    if (response.success) {
      return ApiResponse.success(message: response.message);
    }
    return ApiResponse.error(message: response.message);
  }
}
