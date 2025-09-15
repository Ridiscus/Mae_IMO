part of 'index.dart';

class TenantDetailModel {
  final TenantModel? locataire;
  final EstateModel? bien;
  final ProchainMoisAPayer? prochainMoisAPayer;

  TenantDetailModel({this.locataire, this.bien, this.prochainMoisAPayer});

  TenantDetailModel copyWith({
    TenantModel? locataire,
    EstateModel? bien,
    ProchainMoisAPayer? prochainMoisAPayer,
  }) => TenantDetailModel(
    locataire: locataire ?? this.locataire,
    bien: bien ?? this.bien,
    prochainMoisAPayer: prochainMoisAPayer ?? this.prochainMoisAPayer,
  );

  factory TenantDetailModel.fromJson(String str) =>
      TenantDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TenantDetailModel.fromMap(Map<String, dynamic> json) =>
      TenantDetailModel(
        locataire:
            json["locataire"] == null
                ? null
                : TenantModel.fromMap(json["locataire"]),
        bien: json["bien"] == null ? null : EstateModel.fromMap(json["bien"]),
        prochainMoisAPayer:
            json["prochain_mois_a_payer"] == null
                ? null
                : ProchainMoisAPayer.fromMap(json["prochain_mois_a_payer"]),
      );

  Map<String, dynamic> toMap() => {
    "locataire": locataire?.toMap(),
    "bien": bien?.toMap(),
    "prochain_mois_a_payer": prochainMoisAPayer?.toMap(),
  };
}


class ProchainMoisAPayer {
  final String? moisCouvert;
  final String? moisCouvertDisplay;
  final int? annee;
  final int? moisNumero;
  final String? montant;
  final bool? dejaPaye;

  ProchainMoisAPayer({
    this.moisCouvert,
    this.moisCouvertDisplay,
    this.annee,
    this.moisNumero,
    this.montant,
    this.dejaPaye,
  });

  ProchainMoisAPayer copyWith({
    String? moisCouvert,
    String? moisCouvertDisplay,
    int? annee,
    int? moisNumero,
    String? montant,
    bool? dejaPaye,
  }) => ProchainMoisAPayer(
    moisCouvert: moisCouvert ?? this.moisCouvert,
    moisCouvertDisplay: moisCouvertDisplay ?? this.moisCouvertDisplay,
    annee: annee ?? this.annee,
    moisNumero: moisNumero ?? this.moisNumero,
    montant: montant ?? this.montant,
    dejaPaye: dejaPaye ?? this.dejaPaye,
  );

  factory ProchainMoisAPayer.fromJson(String str) =>
      ProchainMoisAPayer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProchainMoisAPayer.fromMap(Map<String, dynamic> json) =>
      ProchainMoisAPayer(
        moisCouvert: json["mois_couvert"],
        moisCouvertDisplay: json["mois_couvert_display"],
        annee: json["annee"],
        moisNumero: json["mois_numero"],
        montant: json["montant"],
        dejaPaye: json["deja_paye"],
      );

  Map<String, dynamic> toMap() => {
    "mois_couvert": moisCouvert,
    "mois_couvert_display": moisCouvertDisplay,
    "annee": annee,
    "mois_numero": moisNumero,
    "montant": montant,
    "deja_paye": dejaPaye,
  };
}
