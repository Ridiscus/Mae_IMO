part of 'index.dart';

class EstateLocationResponseModel {
  final EstateLocationModel? etatEntree;
  final EstateLocationModel? etatSortie;
  final ComptableInfoModel? comptable;

  EstateLocationResponseModel({
    this.etatEntree,
    this.etatSortie,
    this.comptable,
  });

  EstateLocationResponseModel copyWith({
    EstateLocationModel? etatEntree,
    EstateLocationModel? etatSortie,
    ComptableInfoModel? comptable,
  }) => EstateLocationResponseModel(
    etatEntree: etatEntree ?? this.etatEntree,
    etatSortie: etatSortie ?? this.etatSortie,
    comptable: comptable ?? this.comptable,
  );

  factory EstateLocationResponseModel.fromJson(String str) =>
      EstateLocationResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstateLocationResponseModel.fromMap(Map<String, dynamic> json) =>
      EstateLocationResponseModel(
        etatEntree:
            json["etat_lieu_entree"] == null
                ? null
                : EstateLocationModel.fromMap(json["etat_lieu_entree"]),
        etatSortie:
            json["etat_lieu_sortie"] == null
                ? null
                : EstateLocationModel.fromMap(json["etat_lieu_sortie"]),
        comptable:
            json["comptable"] == null
                ? null
                : ComptableInfoModel.fromJson(json["comptable"]),
      );

  Map<String, dynamic> toMap() => {
    "etat_lieu_entree": etatEntree?.toMap(),
    "etat_lieu_sortie": etatSortie?.toMap(),
    "comptable": comptable?.toMap(),
  };
}
