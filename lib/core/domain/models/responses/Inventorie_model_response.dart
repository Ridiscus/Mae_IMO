import 'dart:convert';

import '../index.dart';

class InventorieModelResponse {
  final List<TenantItemModel>? locataires;
  final int? total;

  InventorieModelResponse({this.locataires, this.total});

  InventorieModelResponse copyWith({
    List<TenantItemModel>? locataires,
    int? total,
  }) => InventorieModelResponse(
    locataires: locataires ?? this.locataires,
    total: total ?? this.total,
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
      );

  Map<String, dynamic> toMap() => {
    "locataires":
        locataires == null
            ? []
            : List<dynamic>.from(locataires!.map((x) => x.toMap())),
    "total": total,
  };
}
