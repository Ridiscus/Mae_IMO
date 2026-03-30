part of 'index.dart';

class OwnerModel {
  final int? id;
  final String? codeId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? residence;
  final String? contact;
  final String? identityFile;
  final String? ribFile;
  final String? choixPaiement;
  final String? pourcentage;
  final String? profilImage;
  final String? contrat;
  final String? gestion;
  final String? diaspora;
  final String? lastBalanceUpdate;
  final int? agenceId;
  final String? createdAt;
  final String? updatedAt;
  final String? commercialId;
  final bool hasManagementAgents;

  const OwnerModel({
    this.id,
    this.codeId,
    this.firstName,
    this.lastName,
    this.email,
    this.residence,
    this.contact,
    this.identityFile,
    this.ribFile,
    this.choixPaiement,
    this.pourcentage,
    this.profilImage,
    this.contrat,
    this.gestion,
    this.diaspora,
    this.lastBalanceUpdate,
    this.agenceId,
    this.createdAt,
    this.updatedAt,
    this.commercialId,
    this.hasManagementAgents = false,
  });

  String? get fullName => " ${lastName ?? ''} ${firstName ?? ''}".trim();

  OwnerModel copyWith({
    int? id,
    String? codeId,
    String? firstName,
    String? lastName,
    String? email,
    String? residence,
    String? contact,
    String? identityFile,
    String? ribFile,
    String? choixPaiement,
    String? pourcentage,
    String? profilImage,
    String? contrat,
    String? gestion,
    String? diaspora,
    String? lastBalanceUpdate,
    int? agenceId,
    String? createdAt,
    String? updatedAt,
    String? commercialId,
    bool? hasManagementAgents,
  }) => OwnerModel(
    id: id ?? this.id,
    codeId: codeId ?? this.codeId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    residence: residence ?? this.residence,
    contact: contact ?? this.contact,
    identityFile: identityFile ?? this.identityFile,
    ribFile: ribFile ?? this.ribFile,
    choixPaiement: choixPaiement ?? this.choixPaiement,
    pourcentage: pourcentage ?? this.pourcentage,
    profilImage: profilImage ?? this.profilImage,
    contrat: contrat ?? this.contrat,
    gestion: gestion ?? this.gestion,
    diaspora: diaspora ?? this.diaspora,
    lastBalanceUpdate: lastBalanceUpdate ?? this.lastBalanceUpdate,
    agenceId: agenceId ?? this.agenceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    commercialId: commercialId ?? this.commercialId,
    hasManagementAgents: hasManagementAgents ?? this.hasManagementAgents,
  );

  factory OwnerModel.fromJson(String str) =>
      OwnerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OwnerModel.fromMap(Map<String, dynamic> json) => OwnerModel(
    id: json['id'] as int?,
    codeId: json['code_id'] as String?,
    firstName: json['prenom'] as String?,
    lastName: json['name'] as String?,
    email: json['email'] as String?,
    residence: json['commune'] as String?,
    contact: json['contact'] as String?,
    identityFile: json['cni'] as String?,
    ribFile: json['rib'] as String?,
    choixPaiement: json['choix_paiement'] as String?,
    pourcentage: json['pourcentage']?.toString(),
    profilImage: json['profil_image'] as String?,
    contrat: json['contrat'] as String?,
    gestion: json['gestion'] as String?,
    diaspora: json['diaspora'] as String?,
    lastBalanceUpdate: json['last_balance_update'] as String?,
    agenceId: json['agence_id'] as int?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    commercialId: json['commercial_id'] as String?,
    hasManagementAgents: (json['gestion'] as String?) != 'proprietaire',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'code_id': codeId,
    'prenom': firstName,
    'name': lastName,
    'email': email,
    'commune': residence,
    'contact': contact,
    'cni': identityFile,
    'rib': ribFile,
    'choix_paiement': choixPaiement,
    'pourcentage': pourcentage,
    'profil_image': profilImage,
    'contrat': contrat,
    'gestion': gestion,
    'diaspora': diaspora,
    'last_balance_update': lastBalanceUpdate,
    'agence_id': agenceId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'commercial_id': commercialId,
    'has_management_agents': hasManagementAgents,
  };
}
