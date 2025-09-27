part of 'index.dart';

class InventoryDetailModel {
  final TenantModel? locataire;
  final EstateModel? bien;

  InventoryDetailModel({this.locataire, this.bien});

  InventoryDetailModel copyWith({TenantModel? locataire, EstateModel? bien}) =>
      InventoryDetailModel(
        locataire: locataire ?? this.locataire,
        bien: bien ?? this.bien,
      );

  factory InventoryDetailModel.fromJson(String str) =>
      InventoryDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InventoryDetailModel.fromMap(Map<String, dynamic> json) =>
      InventoryDetailModel(
        locataire:
            json["locataire"] == null
                ? null
                : TenantModel.fromMap(json["locataire"]),
        bien: json["bien"] == null ? null : EstateModel.fromMap(json["bien"]),
      );

  Map<String, dynamic> toMap() => {
    "locataire": locataire?.toMap(),
    "bien": bien?.toMap(),
  };
}
