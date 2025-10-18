part of 'index.dart';


class QrCodeModel {
  final int? id;
  final int? locataireId;
  final dynamic paiementId;
  final String? code;
  final int? nombreMois;
  final String? moisCouverts;
  final String? qrCodePath;
  final String? montantTotal;
  final DateTime? expiresAt;
  final dynamic usedAt;
  final int? isArchived;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QrCodeModel({
    this.id,
    this.locataireId,
    this.paiementId,
    this.code,
    this.nombreMois,
    this.moisCouverts,
    this.qrCodePath,
    this.montantTotal,
    this.expiresAt,
    this.usedAt,
    this.isArchived,
    this.createdAt,
    this.updatedAt,
  });

  QrCodeModel copyWith({
    int? id,
    int? locataireId,
    dynamic paiementId,
    String? code,
    int? nombreMois,
    String? moisCouverts,
    String? qrCodePath,
    String? montantTotal,
    DateTime? expiresAt,
    dynamic usedAt,
    int? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      QrCodeModel(
        id: id ?? this.id,
        locataireId: locataireId ?? this.locataireId,
        paiementId: paiementId ?? this.paiementId,
        code: code ?? this.code,
        nombreMois: nombreMois ?? this.nombreMois,
        moisCouverts: moisCouverts ?? this.moisCouverts,
        qrCodePath: qrCodePath ?? this.qrCodePath,
        montantTotal: montantTotal ?? this.montantTotal,
        expiresAt: expiresAt ?? this.expiresAt,
        usedAt: usedAt ?? this.usedAt,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory QrCodeModel.fromJson(String str) => QrCodeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QrCodeModel.fromMap(Map<String, dynamic> json) => QrCodeModel(
    id: json["id"],
    locataireId: json["locataire_id"],
    paiementId: json["paiement_id"],
    code: json["code"],
    nombreMois: json["nombre_mois"],
    moisCouverts: json["mois_couverts"],
    qrCodePath: json["qr_code_path"],
    montantTotal: json["montant_total"],
    expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
    usedAt: json["used_at"],
    isArchived: json["is_archived"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "locataire_id": locataireId,
    "paiement_id": paiementId,
    "code": code,
    "nombre_mois": nombreMois,
    "mois_couverts": moisCouverts,
    "qr_code_path": qrCodePath,
    "montant_total": montantTotal,
    "expires_at": expiresAt?.toIso8601String(),
    "used_at": usedAt,
    "is_archived": isArchived,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
