import 'dart:convert';

import '../index.dart';

class InventorieModelResponse {
  final List<TenantItemModel>? locataires;
  final int? total;
  final EstateLocationResponseModel? etats_lieu;

  InventorieModelResponse({this.locataires, this.total, this.etats_lieu});

  InventorieModelResponse copyWith({
    List<TenantItemModel>? locataires,
    int? total,
    EstateLocationResponseModel? etats_lieu,
  }) => InventorieModelResponse(
    locataires: locataires ?? this.locataires,
    total: total ?? this.total,
    etats_lieu: etats_lieu ?? this.etats_lieu,
  );

  factory InventorieModelResponse.fromJson(String str) =>
      InventorieModelResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InventorieModelResponse.fromMap(Map<String, dynamic> json) =>
      InventorieModelResponse(
        locataires:
            json["locataires"] == null
                ? []
                : List<TenantItemModel>.from(
                  json["locataires"]!.map((x) => TenantItemModel.fromMap(x)),
                ),
        total: json["total"],
        etats_lieu:
            json["etats_lieu"] == null
                ? null
                : EstateLocationResponseModel.fromMap(json["etats_lieu"]),
      );

  Map<String, dynamic> toMap() => {
    "locataires":
        locataires == null
            ? []
            : List<dynamic>.from(locataires!.map((x) => x.toMap())),
    "total": total,
    "etats_lieu": etats_lieu?.toMap(),
  };
}
