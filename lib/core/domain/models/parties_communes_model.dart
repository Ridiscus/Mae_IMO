part of 'index.dart';

class PartiesCommunesModel {
  final String? sol;
  final String? murs;
  final String? douche;
  final String? lavabo;
  final String? plafond;
  final String? robinet;
  final String? porteEntre;
  final String? interrupteur;
  final String? observationSol;
  final String? observationMurs;
  final String? observationDouche;
  final String? observationLavabo;
  final String? observationPlafond;
  final String? observationRobinet;
  final String? observationPorteEntre;
  final String? observationInterrupteur;

  PartiesCommunesModel({
    this.sol,
    this.murs,
    this.douche,
    this.lavabo,
    this.plafond,
    this.robinet,
    this.porteEntre,
    this.interrupteur,
    this.observationSol,
    this.observationMurs,
    this.observationDouche,
    this.observationLavabo,
    this.observationPlafond,
    this.observationRobinet,
    this.observationPorteEntre,
    this.observationInterrupteur,
  });

  PartiesCommunesModel copyWith({
    String? sol,
    String? murs,
    String? douche,
    String? lavabo,
    String? plafond,
    String? robinet,
    String? porteEntre,
    String? interrupteur,
    String? observationSol,
    String? observationMurs,
    String? observationDouche,
    String? observationLavabo,
    String? observationPlafond,
    String? observationRobinet,
    String? observationPorteEntre,
    String? observationInterrupteur,
  }) => PartiesCommunesModel(
    sol: sol ?? this.sol,
    murs: murs ?? this.murs,
    douche: douche ?? this.douche,
    lavabo: lavabo ?? this.lavabo,
    plafond: plafond ?? this.plafond,
    robinet: robinet ?? this.robinet,
    porteEntre: porteEntre ?? this.porteEntre,
    interrupteur: interrupteur ?? this.interrupteur,
    observationSol: observationSol ?? this.observationSol,
    observationMurs: observationMurs ?? this.observationMurs,
    observationDouche: observationDouche ?? this.observationDouche,
    observationLavabo: observationLavabo ?? this.observationLavabo,
    observationPlafond: observationPlafond ?? this.observationPlafond,
    observationRobinet: observationRobinet ?? this.observationRobinet,
    observationPorteEntre: observationPorteEntre ?? this.observationPorteEntre,
    observationInterrupteur:
    observationInterrupteur ?? this.observationInterrupteur,
  );

  factory PartiesCommunesModel.fromJson(String str) =>
      PartiesCommunesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PartiesCommunesModel.fromMap(Map<String, dynamic> json) => PartiesCommunesModel(
    sol: json["sol"],
    murs: json["murs"],
    douche: json["douche"],
    lavabo: json["lavabo"],
    plafond: json["plafond"],
    robinet: json["robinet"],
    porteEntre: json["porte_entre"],
    interrupteur: json["interrupteur"],
    observationSol: json["observation_sol"],
    observationMurs: json["observation_murs"],
    observationDouche: json["observation_douche"],
    observationLavabo: json["observation_lavabo"],
    observationPlafond: json["observation_plafond"],
    observationRobinet: json["observation_robinet"],
    observationPorteEntre: json["observation_porte_entre"],
    observationInterrupteur: json["observation_interrupteur"],
  );

  Map<String, dynamic> toMap() => {
    "sol": sol,
    "murs": murs,
    "douche": douche,
    "lavabo": lavabo,
    "plafond": plafond,
    "robinet": robinet,
    "porte_entre": porteEntre,
    "interrupteur": interrupteur,
    "observation_sol": observationSol,
    "observation_murs": observationMurs,
    "observation_douche": observationDouche,
    "observation_lavabo": observationLavabo,
    "observation_plafond": observationPlafond,
    "observation_robinet": observationRobinet,
    "observation_porte_entre": observationPorteEntre,
    "observation_interrupteur": observationInterrupteur,
  };
}
