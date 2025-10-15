part of '../index.dart';

class InventoryModelResponse {
  final List<TenantItemModel>? locataires;
  final int? total;
  final EstateLocationResponseModel? etats_lieu;

  InventoryModelResponse({this.locataires, this.total, this.etats_lieu});

  InventoryModelResponse copyWith({
    List<TenantItemModel>? locataires,
    int? total,
    EstateLocationResponseModel? etats_lieu,
  }) => InventoryModelResponse(
    locataires: locataires ?? this.locataires,
    total: total ?? this.total,
    etats_lieu: etats_lieu ?? this.etats_lieu,
  );

  factory InventoryModelResponse.fromJson(String str) =>
      InventoryModelResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InventoryModelResponse.fromMap(Map<String, dynamic> json) =>
      InventoryModelResponse(
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
