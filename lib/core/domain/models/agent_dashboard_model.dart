part of 'index.dart';

class AgentDashboardModel {
  final int? totalLoyersPercus;
  final int? locatairesAJour;
  final int? locatairesEnRetard;
  final int? paiementsEnAttente;
  final int? etatsLieuEffectues;
  final String? moisCourant;

  AgentDashboardModel({
    this.totalLoyersPercus,
    this.locatairesAJour,
    this.locatairesEnRetard,
    this.paiementsEnAttente,
    this.etatsLieuEffectues,
    this.moisCourant,
  });

  AgentDashboardModel copyWith({
    int? totalLoyersPercus,
    int? locatairesAJour,
    int? locatairesEnRetard,
    int? paiementsEnAttente,
    int? etatsLieuEffectues,
    String? moisCourant,
  }) => AgentDashboardModel(
    totalLoyersPercus: totalLoyersPercus ?? this.totalLoyersPercus,
    locatairesAJour: locatairesAJour ?? this.locatairesAJour,
    locatairesEnRetard: locatairesEnRetard ?? this.locatairesEnRetard,
    paiementsEnAttente: paiementsEnAttente ?? this.paiementsEnAttente,
    etatsLieuEffectues: etatsLieuEffectues ?? this.etatsLieuEffectues,
    moisCourant: moisCourant ?? this.moisCourant,
  );

  factory AgentDashboardModel.fromJson(String str) =>
      AgentDashboardModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AgentDashboardModel.fromMap(Map<String, dynamic> json) =>
      AgentDashboardModel(
        totalLoyersPercus: json["total_loyers_percus"],
        locatairesAJour: json["locataires_a_jour"],
        locatairesEnRetard: json["locataires_en_retard"],
        paiementsEnAttente: json["paiements_en_attente"],
        etatsLieuEffectues: json["etats_lieu_effectues"],
        moisCourant: json["mois_courant"],
      );

  Map<String, dynamic> toMap() => {
    "total_loyers_percus": totalLoyersPercus,
    "locataires_a_jour": locatairesAJour,
    "locataires_en_retard": locatairesEnRetard,
    "paiements_en_attente": paiementsEnAttente,
    "etats_lieu_effectues": etatsLieuEffectues,
    "mois_courant": moisCourant,
  };
}
