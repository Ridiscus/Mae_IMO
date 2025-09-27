part of 'index.dart';

class InitPaymentModel {
  final bool? success;
  final String? type;
  final CinetpayData? cinetpayData;
  final Paiement? paiement;

  InitPaymentModel({this.success, this.type, this.cinetpayData, this.paiement});

  InitPaymentModel copyWith({
    bool? success,
    String? type,
    CinetpayData? cinetpayData,
    Paiement? paiement,
  }) => InitPaymentModel(
    success: success ?? this.success,
    type: type ?? this.type,
    cinetpayData: cinetpayData ?? this.cinetpayData,
    paiement: paiement ?? this.paiement,
  );

  factory InitPaymentModel.fromJson(String str) =>
      InitPaymentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InitPaymentModel.fromMap(Map<String, dynamic> json) =>
      InitPaymentModel(
        success: json["success"],
        type: json["type"],
        cinetpayData:
            json["cinetpay_data"] == null
                ? null
                : CinetpayData.fromMap(json["cinetpay_data"]),
        paiement:
            json["paiement"] == null
                ? null
                : Paiement.fromMap(json["paiement"]),
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "type": type,
    "cinetpay_data": cinetpayData?.toMap(),
    "paiement": paiement?.toMap(),
  };
}

class CinetpayData {
  final String? apiKey;
  final String? siteId;
  final String? notifyUrl;
  final String? mode;
  final String? transactionId;
  final String? amount;
  final String? currency;
  final String? description;
  final String? customerName;
  final String? customerSurname;
  final String? customerPhoneNumber;
  final String? channels;
  final Metadata? metadata;

  CinetpayData({
    this.apiKey,
    this.siteId,
    this.notifyUrl,
    this.mode,
    this.transactionId,
    this.amount,
    this.currency,
    this.description,
    this.customerName,
    this.customerSurname,
    this.customerPhoneNumber,
    this.channels,
    this.metadata,
  });

  CinetpayData copyWith({
    String? apiKey,
    String? siteId,
    String? notifyUrl,
    String? mode,
    String? transactionId,
    String? amount,
    String? currency,
    String? description,
    String? customerName,
    String? customerSurname,
    String? customerPhoneNumber,
    String? channels,
    Metadata? metadata,
  }) => CinetpayData(
    apiKey: apiKey ?? this.apiKey,
    siteId: siteId ?? this.siteId,
    notifyUrl: notifyUrl ?? this.notifyUrl,
    mode: mode ?? this.mode,
    transactionId: transactionId ?? this.transactionId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    description: description ?? this.description,
    customerName: customerName ?? this.customerName,
    customerSurname: customerSurname ?? this.customerSurname,
    customerPhoneNumber: customerPhoneNumber ?? this.customerPhoneNumber,
    channels: channels ?? this.channels,
    metadata: metadata ?? this.metadata,
  );

  factory CinetpayData.fromJson(String str) =>
      CinetpayData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CinetpayData.fromMap(Map<String, dynamic> json) => CinetpayData(
    apiKey: json["api_key"],
    siteId: json["site_id"],
    notifyUrl: json["notify_url"],
    mode: json["mode"],
    transactionId: json["transaction_id"],
    amount: json["amount"],
    currency: json["currency"],
    description: json["description"],
    customerName: json["customer_name"],
    customerSurname: json["customer_surname"],
    customerPhoneNumber: json["customer_phone_number"],
    channels: json["channels"],
    metadata:
        json["metadata"] == null ? null : Metadata.fromMap(json["metadata"]),
  );

  Map<String, dynamic> toMap() => {
    "api_key": apiKey,
    "site_id": siteId,
    "notify_url": notifyUrl,
    "mode": mode,
    "transaction_id": transactionId,
    "amount": amount,
    "currency": currency,
    "description": description,
    "customer_name": customerName,
    "customer_surname": customerSurname,
    "customer_phone_number": customerPhoneNumber,
    "channels": channels,
    "metadata": metadata?.toMap(),
  };
}

class Metadata {
  final int? locataireId;
  final int? bienId;
  final String? moisCouvert;
  final String? montant;

  Metadata({this.locataireId, this.bienId, this.moisCouvert, this.montant});

  Metadata copyWith({
    int? locataireId,
    int? bienId,
    String? moisCouvert,
    String? montant,
  }) => Metadata(
    locataireId: locataireId ?? this.locataireId,
    bienId: bienId ?? this.bienId,
    moisCouvert: moisCouvert ?? this.moisCouvert,
    montant: montant ?? this.montant,
  );

  factory Metadata.fromJson(String str) => Metadata.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Metadata.fromMap(Map<String, dynamic> json) => Metadata(
    locataireId: json["locataire_id"],
    bienId: json["bien_id"],
    moisCouvert: json["mois_couvert"],
    montant: json["montant"],
  );

  Map<String, dynamic> toMap() => {
    "locataire_id": locataireId.toString(),
    "bien_id": bienId.toString(),
    "mois_couvert": moisCouvert.toString(),
    "montant": montant.toString(),
  };
}

class Paiement {
  final int? id;
  final int? montant;
  final DateTime? datePaiement;
  final String? moisCouvert;
  final String? methodePaiement;
  final String? statut;
  final String? reference;
  final String? transactionId;
  final String? proofPath;
  final int? locataireId;
  final int? bienId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Paiement({
    this.id,
    this.montant,
    this.datePaiement,
    this.moisCouvert,
    this.methodePaiement,
    this.statut,
    this.reference,
    this.transactionId,
    this.proofPath,
    this.locataireId,
    this.bienId,
    this.createdAt,
    this.updatedAt,
  });

  Paiement copyWith({
    int? id,
    int? montant,
    DateTime? datePaiement,
    String? moisCouvert,
    String? methodePaiement,
    String? statut,
    String? reference,
    String? transactionId,
    String? proofPath,
    int? locataireId,
    int? bienId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Paiement(
    id: id ?? this.id,
    montant: montant ?? this.montant,
    datePaiement: datePaiement ?? this.datePaiement,
    moisCouvert: moisCouvert ?? this.moisCouvert,
    methodePaiement: methodePaiement ?? this.methodePaiement,
    statut: statut ?? this.statut,
    reference: reference ?? this.reference,
    transactionId: transactionId ?? this.transactionId,
    proofPath: proofPath ?? this.proofPath,
    locataireId: locataireId ?? this.locataireId,
    bienId: bienId ?? this.bienId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Paiement.fromJson(String str) => Paiement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Paiement.fromMap(Map<String, dynamic> json) => Paiement(
    id: json["id"],
    montant: json["montant"],
    datePaiement:
        json["date_paiement"] == null
            ? null
            : DateTime.parse(json["date_paiement"]),
    moisCouvert: json["mois_couvert"],
    methodePaiement: json["methode_paiement"],
    statut: json["statut"],
    reference: json["reference"],
    transactionId: json["transaction_id"],
    proofPath: json["proof_path"],
    locataireId: json["locataire_id"],
    bienId: json["bien_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "montant": montant,
    "date_paiement": datePaiement?.toIso8601String(),
    "mois_couvert": moisCouvert,
    "methode_paiement": methodePaiement,
    "statut": statut,
    "reference": reference,
    "transaction_id": transactionId,
    "proof_path": proofPath,
    "locataire_id": locataireId,
    "bien_id": bienId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
