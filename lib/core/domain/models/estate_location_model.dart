part of 'index.dart';

class EstateLocationModel {
  final int? id;
  final String? typeBien;
  final String? communeBien;
  final String? presencePartie;
  final String? statusEtatEntre;
  final dynamic statusSorti;
  final PartiesCommunesModel? partiesCommunesModel;
  final List<ChambreModel>? chambreModels;
  final String? nombreCle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EstateLocationModel({
    this.id,
    this.typeBien,
    this.communeBien,
    this.presencePartie,
    this.statusEtatEntre,
    this.statusSorti,
    this.partiesCommunesModel,
    this.chambreModels,
    this.nombreCle,
    this.createdAt,
    this.updatedAt,
  });

  EstateLocationModel copyWith({
    int? id,
    String? typeBien,
    String? communeBien,
    String? presencePartie,
    String? statusEtatEntre,
    dynamic statusSorti,
    PartiesCommunesModel? PartiesCommunesModel,
    List<ChambreModel>? ChambreModels,
    String? nombreCle,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EstateLocationModel(
    id: id ?? this.id,
    typeBien: typeBien ?? this.typeBien,
    communeBien: communeBien ?? this.communeBien,
    presencePartie: presencePartie ?? this.presencePartie,
    statusEtatEntre: statusEtatEntre ?? this.statusEtatEntre,
    statusSorti: statusSorti ?? this.statusSorti,
    partiesCommunesModel: partiesCommunesModel ?? this.partiesCommunesModel,
    chambreModels: chambreModels ?? this.chambreModels,
    nombreCle: nombreCle ?? this.nombreCle,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory EstateLocationModel.fromJson(String str) =>
      EstateLocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstateLocationModel.fromMap(
    Map<String, dynamic> json,
  ) => EstateLocationModel(
    id: json["id"],
    typeBien: json["type_bien"],
    communeBien: json["commune_bien"],
    presencePartie: json["presence_partie"],
    statusEtatEntre: json["status_etat_entre"],
    statusSorti: json["status_sorti"],
    partiesCommunesModel:
        json["parties_communes"] == null
            ? null
            : PartiesCommunesModel.fromMap(json["parties_communes"]),
    chambreModels:
        json["chambres"] == null
            ? []
            : List<ChambreModel>.from(
              json["chambres"]!.map((x) => ChambreModel.fromMap(x)),
            ),
    nombreCle: json["nombre_cle"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "type_bien": typeBien,
    "commune_bien": communeBien,
    "presence_partie": presencePartie,
    "status_etat_entre": statusEtatEntre,
    "status_sorti": statusSorti,
    "parties_communes": partiesCommunesModel?.toMap(),
    "chambres":
        chambreModels == null
            ? []
            : List<dynamic>.from(chambreModels!.map((x) => x.toMap())),
    "nombre_cle": nombreCle,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
