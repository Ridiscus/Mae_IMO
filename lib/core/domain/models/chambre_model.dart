part of 'index.dart';

class ChambreModel {
  final String? nom;
  final String? sol;
  final String? murs;
  final String? plafond;
  final String? observationSol;
  final String? observationMurs;
  final String? observationPlafond;

  ChambreModel({
    this.nom,
    this.sol,
    this.murs,
    this.plafond,
    this.observationSol,
    this.observationMurs,
    this.observationPlafond,
  });

  ChambreModel copyWith({
    String? nom,
    String? sol,
    String? murs,
    String? plafond,
    String? observationSol,
    String? observationMurs,
    String? observationPlafond,
  }) => ChambreModel(
    nom: nom ?? this.nom,
    sol: sol ?? this.sol,
    murs: murs ?? this.murs,
    plafond: plafond ?? this.plafond,
    observationSol: observationSol ?? this.observationSol,
    observationMurs: observationMurs ?? this.observationMurs,
    observationPlafond: observationPlafond ?? this.observationPlafond,
  );

  factory ChambreModel.fromJson(String str) => ChambreModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChambreModel.fromMap(Map<String, dynamic> json) => ChambreModel(
    nom: json["nom"],
    sol: json["sol"],
    murs: json["murs"],
    plafond: json["plafond"],
    observationSol: json["observation_sol"],
    observationMurs: json["observation_murs"],
    observationPlafond: json["observation_plafond"],
  );

  Map<String, dynamic> toMap() => {
    "nom": nom,
    "sol": sol,
    "murs": murs,
    "plafond": plafond,
    "observation_sol": observationSol,
    "observation_murs": observationMurs,
    "observation_plafond": observationPlafond,
  };
}
