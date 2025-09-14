part of 'index.dart';

class PaymentHistoryModel {
  final int? id;
  final String? montant;
  final DateTime? datePaiement;
  final String? reference;
  final String? moisCouvert;
  final String? methodePaiement;
  final dynamic verifEspece;
  final dynamic transactionId;
  final String? statut;
  final String? proofPath;
  final int? locataireId;
  final int? bienId;
  final dynamic comptableId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdAtFormatted;

  PaymentHistoryModel({
    this.id,
    this.montant,
    this.datePaiement,
    this.reference,
    this.moisCouvert,
    this.methodePaiement,
    this.verifEspece,
    this.transactionId,
    this.statut,
    this.proofPath,
    this.locataireId,
    this.bienId,
    this.comptableId,
    this.createdAt,
    this.updatedAt,
    this.createdAtFormatted,
  });

  PaymentHistoryModel copyWith({
    int? id,
    String? montant,
    DateTime? datePaiement,
    String? reference,
    String? moisCouvert,
    String? methodePaiement,
    dynamic verifEspece,
    dynamic transactionId,
    String? statut,
    String? proofPath,
    int? locataireId,
    int? bienId,
    dynamic comptableId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdAtFormatted,
  }) => PaymentHistoryModel(
    id: id ?? this.id,
    montant: montant ?? this.montant,
    datePaiement: datePaiement ?? this.datePaiement,
    reference: reference ?? this.reference,
    moisCouvert: moisCouvert ?? this.moisCouvert,
    methodePaiement: methodePaiement ?? this.methodePaiement,
    verifEspece: verifEspece ?? this.verifEspece,
    transactionId: transactionId ?? this.transactionId,
    statut: statut ?? this.statut,
    proofPath: proofPath ?? this.proofPath,
    locataireId: locataireId ?? this.locataireId,
    bienId: bienId ?? this.bienId,
    comptableId: comptableId ?? this.comptableId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAtFormatted: createdAtFormatted ?? this.createdAtFormatted,
  );

  factory PaymentHistoryModel.fromJson(String str) =>
      PaymentHistoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentHistoryModel.fromMap(
    Map<String, dynamic> json,
  ) => PaymentHistoryModel(
    id: json["id"],
    montant: json["montant"],
    datePaiement:
        json["date_paiement"] == null
            ? null
            : DateTime.parse(json["date_paiement"]),
    reference: json["reference"],
    moisCouvert: json["mois_couvert"],
    methodePaiement: json["methode_paiement"],
    verifEspece: json["verif_espece"],
    transactionId: json["transaction_id"],
    statut: json["statut"],
    proofPath: json["proof_path"],
    locataireId: json["locataire_id"],
    bienId: json["bien_id"],
    comptableId: json["comptable_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAtFormatted: json["created_at_formatted"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "montant": montant,
    "date_paiement":
        "${datePaiement!.year.toString().padLeft(4, '0')}-${datePaiement!.month.toString().padLeft(2, '0')}-${datePaiement!.day.toString().padLeft(2, '0')}",
    "reference": reference,
    "mois_couvert": moisCouvert,
    "methode_paiement": methodePaiement,
    "verif_espece": verifEspece,
    "transaction_id": transactionId,
    "statut": statut,
    "proof_path": proofPath,
    "locataire_id": locataireId,
    "bien_id": bienId,
    "comptable_id": comptableId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at_formatted": createdAtFormatted,
  };
}
