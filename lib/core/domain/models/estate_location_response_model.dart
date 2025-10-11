part of 'index.dart';

class EstateLocationResponseModel {
  final EstateLocationModel? etatEntree;
  final EstateLocationModel? etatSortie;

  EstateLocationResponseModel({this.etatEntree, this.etatSortie});

  EstateLocationResponseModel copyWith({
    EstateLocationModel? etatEntree,
    EstateLocationModel? etatSortie,
  }) => EstateLocationResponseModel(
    etatEntree: etatEntree ?? this.etatEntree,
    etatSortie: etatSortie ?? this.etatSortie,
  );

  factory EstateLocationResponseModel.fromJson(String str) =>
      EstateLocationResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstateLocationResponseModel.fromMap(Map<String, dynamic> json) =>
      EstateLocationResponseModel(
        etatEntree:
            json["etat_entree"] == null
                ? null
                : EstateLocationModel.fromMap(json["etat_entree"]),
        etatSortie:
            json["etat_sortie"] == null
                ? null
                : EstateLocationModel.fromMap(json["etat_sortie"]),
      );

  Map<String, dynamic> toMap() => {
    "etat_entree": etatEntree?.toMap(),
    "etat_sortie": etatSortie?.toMap(),
  };
}
