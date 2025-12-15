part of 'index.dart';

class EstateModel {
  final int? id;
  final String? type;
  final String? numeroBien;
  final String? utilisation;
  final String? description;
  final String? superficie;
  final String? nombreChambres;
  final String? nombreDeToilettes;
  final String? garage;
  final String? avance;
  final String? caution;
  final String? frais;
  final String? montantTotal;
  final String? prix;
  final String? commune;
  final dynamic montantMajore;
  final String? dateFixe;
  final List<String>? images;
  final String? status;
  final String? agenceId;
  final String? proprietaireId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EstateModel({
    this.id,
    this.type,
    this.numeroBien,
    this.utilisation,
    this.description,
    this.superficie,
    this.nombreChambres,
    this.nombreDeToilettes,
    this.garage,
    this.avance,
    this.caution,
    this.frais,
    this.montantTotal,
    this.prix,
    this.commune,
    this.montantMajore,
    this.dateFixe,
    this.images,
    this.status,
    this.agenceId,
    this.proprietaireId,
    this.createdAt,
    this.updatedAt,
  });

  EstateModel copyWith({
    int? id,
    String? type,
    String? numeroBien,
    String? utilisation,
    String? description,
    String? superficie,
    String? nombreDeChambres,
    String? nombreDeToilettes,
    String? garage,
    String? avance,
    String? caution,
    String? frais,
    String? montantTotal,
    String? prix,
    String? commune,
    dynamic montantMajore,
    String? dateFixe,
    List<String>? images,
    String? status,
    String? agenceId,
    String? proprietaireId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EstateModel(
    id: id ?? this.id,
    type: type ?? this.type,
    numeroBien: numeroBien ?? this.numeroBien,
    utilisation: utilisation ?? this.utilisation,
    description: description ?? this.description,
    superficie: superficie ?? this.superficie,
    nombreChambres: nombreDeChambres ?? this.nombreChambres,
    nombreDeToilettes: nombreDeToilettes ?? this.nombreDeToilettes,
    garage: garage ?? this.garage,
    avance: avance ?? this.avance,
    caution: caution ?? this.caution,
    frais: frais ?? this.frais,
    montantTotal: montantTotal ?? this.montantTotal,
    prix: prix ?? this.prix,
    commune: commune ?? this.commune,
    montantMajore: montantMajore ?? this.montantMajore,
    dateFixe: dateFixe ?? this.dateFixe,
    images: images ?? this.images,
    status: status ?? this.status,
    agenceId: agenceId ?? this.agenceId,
    proprietaireId: proprietaireId ?? this.proprietaireId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory EstateModel.fromJson(String str) =>
      EstateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstateModel.fromMap(Map<String, dynamic> json) {
    json['images'] =
        json['images'] ??
        [
          json["image"],
          json["image1"],
          json["image2"],
          json["image3"],
          json["image4"],
          json["image5"],
        ].where((element) => element != null);

    return EstateModel(
      id: json["id"],
      type: json["type"],
      numeroBien: json["numero_bien"],
      utilisation: json["utilisation"],
      description: json["description"],
      superficie: json["superficie"],
      nombreChambres: json["nombre_de_chambres"],
      nombreDeToilettes: json["nombre_de_toilettes"],
      garage: json["garage"],
      avance: json["avance"],
      caution: json["caution"],
      frais: json["frais"],
      montantTotal: json["montant_total"],
      prix: json["prix"],
      commune: json["commune"],
      montantMajore: json["montant_majore"],
      dateFixe: json["date_fixe"],
      images:
          json["images"] == null
              ? []
              : List<String>.from(json["images"]!.map((x) => x)),
      status: json["status"],
      agenceId: json["agence_id"],
      proprietaireId: json["proprietaire_id"],
      createdAt:
          json["created_at"] == null
              ? null
              : DateTime.parse(json["created_at"]),
      updatedAt:
          json["updated_at"] == null
              ? null
              : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type,
    "numero_bien": numeroBien,
    "utilisation": utilisation,
    "description": description,
    "superficie": superficie,
    "nombre_de_chambres": nombreChambres,
    "nombre_de_toilettes": nombreDeToilettes,
    "garage": garage,
    "avance": avance,
    "caution": caution,
    "frais": frais,
    "montant_total": montantTotal,
    "prix": prix,
    "commune": commune,
    "montant_majore": montantMajore,
    "date_fixe": dateFixe,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "status": status,
    "agence_id": agenceId,
    "proprietaire_id": proprietaireId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
