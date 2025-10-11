part of 'index.dart';

class InventoryDetailModel {
  final TenantModel? locataire;
  final EstateModel? bien;
  final EstateLocationResponseModel? etatsLieu;

  InventoryDetailModel({this.locataire, this.bien, this.etatsLieu});

  InventoryDetailModel copyWith({
    TenantModel? locataire,
    EstateModel? bien,
    EstateLocationResponseModel? etatsLieu,
  }) =>
      InventoryDetailModel(
        locataire: locataire ?? this.locataire,
        bien: bien ?? this.bien,
        etatsLieu: etatsLieu ?? this.etatsLieu,
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
        etatsLieu:
            json["etats_lieu"] == null
                ? null
                : EstateLocationResponseModel.fromMap(json["etats_lieu"]),
      );

  Map<String, dynamic> toMap() => {
    "locataire": locataire?.toMap(),
    "bien": bien?.toMap(),
    "etats_lieu": etatsLieu?.toMap(),
  };
}
