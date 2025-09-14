part of 'index.dart';

class TenantModel extends UserModel {
  // Propriétés spécifiques à TenantModel
  final String? piece;
  final String? adresse;
  final String? profession;
  final dynamic attestation;
  final dynamic image1;
  final dynamic image2;
  final dynamic image3;
  final dynamic image4;
  final String? status;
  final dynamic motif;
  final String? contrat;
  final int? bienId;
  final dynamic comptableId;
  final EstateModel? estate;
  final AgencyModel? agency;

  // Implémentation du polymorphisme
  @override
  UserType get userType => UserType.tenant;

  TenantModel({
    // Propriétés héritées de UserModel
    super.id,
    super.codeId,
    super.name,
    super.prenom,
    super.email,
    super.passwordResetToken,
    super.passwordResetExpires,
    super.contact,
    super.profileImage,
    super.agenceId,
    super.proprietaireId,
    super.createdAt,
    super.updatedAt,
    // Propriétés spécifiques à TenantModel
    this.piece,
    this.adresse,
    this.profession,
    this.attestation,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.status,
    this.motif,
    this.contrat,
    this.bienId,
    this.comptableId,
    this.estate,
    this.agency,
  });

  TenantModel copyWith({
    int? id,
    String? codeId,
    String? name,
    String? prenom,
    String? email,
    dynamic passwordResetToken,
    dynamic passwordResetExpires,
    String? contact,
    dynamic profileImage,
    String? agenceId,
    dynamic proprietaireId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? piece,
    String? adresse,
    String? profession,
    dynamic attestation,
    dynamic image1,
    dynamic image2,
    dynamic image3,
    dynamic image4,
    String? status,
    dynamic motif,
    String? contrat,
    int? bienId,
    dynamic comptableId,
    EstateModel? estate,
    AgencyModel? agency,
  }) => TenantModel(
    id: id ?? this.id,
    codeId: codeId ?? this.codeId,
    name: name ?? this.name,
    prenom: prenom ?? this.prenom,
    email: email ?? this.email,
    passwordResetToken: passwordResetToken ?? this.passwordResetToken,
    passwordResetExpires: passwordResetExpires ?? this.passwordResetExpires,
    contact: contact ?? this.contact,
    profileImage: profileImage ?? this.profileImage,
    agenceId: agenceId ?? this.agenceId,
    proprietaireId: proprietaireId ?? this.proprietaireId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    piece: piece ?? this.piece,
    adresse: adresse ?? this.adresse,
    profession: profession ?? this.profession,
    attestation: attestation ?? this.attestation,
    image1: image1 ?? this.image1,
    image2: image2 ?? this.image2,
    image3: image3 ?? this.image3,
    image4: image4 ?? this.image4,
    status: status ?? this.status,
    motif: motif ?? this.motif,
    contrat: contrat ?? this.contrat,
    bienId: bienId ?? this.bienId,
    comptableId: comptableId ?? this.comptableId,
    estate: estate ?? this.estate,
    agency: agency ?? this.agency,
  );

  factory TenantModel.fromJson(String str) =>
      TenantModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TenantModel.fromMap(Map<String, dynamic> json) {
    final baseFields = UserModel.parseBaseFields(json);
    return TenantModel(
      // Champs de base hérités
      id: baseFields['id'],
      codeId: baseFields['codeId'],
      name: baseFields['name'],
      prenom: baseFields['prenom'],
      email: baseFields['email'],
      passwordResetToken: baseFields['passwordResetToken'],
      passwordResetExpires: baseFields['passwordResetExpires'],
      contact: baseFields['contact'],
      profileImage: baseFields['profileImage'],
      agenceId: baseFields['agenceId'],
      proprietaireId: baseFields['proprietaireId'],
      createdAt: baseFields['createdAt'],
      updatedAt: baseFields['updatedAt'],
      // Champs spécifiques à TenantModel
      piece: json["piece"],
      adresse: json["adresse"],
      profession: json["profession"],
      attestation: json["attestation"],
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      image4: json["image4"],
      status: json["status"],
      motif: json["motif"],
      contrat: json["contrat"],
      bienId: json["bien_id"],
      comptableId: json["comptable_id"],
      estate: json["bien"] == null ? null : EstateModel.fromMap(json["bien"]),
      agency: json["agence"] == null ? null : AgencyModel.fromMap(json["agence"]),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = getBaseMap();
    baseMap.addAll({
      "user_type": userType.value,
      "piece": piece,
      "adresse": adresse,
      "profession": profession,
      "attestation": attestation,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "status": status,
      "motif": motif,
      "contrat": contrat,
      "bien_id": bienId,
      "comptable_id": comptableId,
      "bien": estate?.toMap(),
      "agence": agency?.toMap(),
    });
    return baseMap;
  }
}
