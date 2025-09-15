part of 'index.dart';

enum UserType {
  tenant('tenant'),
  locataire('locataire'),
  collectionAgent('collection_agent'),
  unknown('unknown');

  const UserType(this.value);

  final String value;

  static UserType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'locataire':
      case 'tenant':
        return UserType.tenant;
      case 'collection_agent':
      case 'agent':
        return UserType.collectionAgent;
      default:
        return UserType.unknown;
    }
  }
}

abstract class UserModel {
  final int? id;
  final String? codeId;
  final String? name;
  final String? prenom;
  final String? email;
  final dynamic passwordResetToken;
  final dynamic passwordResetExpires;
  final String? contact;
  final dynamic profileImage;
  final String? agenceId;
  final dynamic proprietaireId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Propriété pour le polymorphisme
  UserType get userType;

  const UserModel({
    this.id,
    this.codeId,
    this.name,
    this.prenom,
    this.email,
    this.passwordResetToken,
    this.passwordResetExpires,
    this.contact,
    this.profileImage,
    this.agenceId,
    this.proprietaireId,
    this.createdAt,
    this.updatedAt,
  });

  // Méthodes communes pour la sérialisation JSON
  String toJson() => json.encode(toMap());

  // Méthodes abstraites à implémenter par les classes dérivées
  Map<String, dynamic> toMap();

  // Factory polymorphe pour créer le bon type d'utilisateur
  static UserModel fromMap(Map<String, dynamic> json) {
    final userTypeString = json['user_type'] ?? json['type'];
    final userType = UserType.fromString(userTypeString);

    switch (userType) {
      case UserType.tenant:
        return TenantModel.fromMap(json);
      case UserType.collectionAgent:
        return CollectionAgentModel.fromMap(json);
      case UserType.unknown:
      default:
        // Si le type n'est pas spécifié, on essaie de deviner selon les champs présents
        if (json.containsKey('bien_id') || json.containsKey('piece')) {
          return TenantModel.fromMap(json);
        } else if (json.containsKey('commune') ||
            json.containsKey('date_naissance')) {
          return CollectionAgentModel.fromMap(json);
        }
        // Par défaut, on retourne un TenantModel
        return TenantModel.fromMap(json);
    }
  }

  // Factory polymorphe depuis JSON string
  static UserModel fromJson(String jsonString) {
    return UserModel.fromMap(json.decode(jsonString));
  }

  // Getters utilitaires communs
  String get fullName => '${name ?? ''} ${prenom ?? ''}'.trim();

  bool get hasProfileImage => profileImage != null;

  // Méthodes utilitaires pour le polymorphisme
  bool get isTenant => userType == UserType.tenant;

  bool get isCollectionAgent => userType == UserType.collectionAgent;

  bool get isUnknownType => userType == UserType.unknown;

  // Cast sécurisé vers TenantModel
  TenantModel? asTenant() {
    return isTenant ? this as TenantModel : null;
  }

  // Cast sécurisé vers CollectionAgentModel
  CollectionAgentModel? asCollectionAgent() {
    return isCollectionAgent ? this as CollectionAgentModel : null;
  }

  // Méthode pour exécuter une action selon le type
  T when<T>({
    required T Function(TenantModel tenant) onTenant,
    required T Function(CollectionAgentModel agent) onCollectionAgent,
    required T Function(UserModel user) onUnknown,
  }) {
    switch (userType) {
      case UserType.tenant:
        return onTenant(this as TenantModel);
      case UserType.collectionAgent:
        return onCollectionAgent(this as CollectionAgentModel);
      case UserType.unknown:
      default:
        return onUnknown(this);
    }
  }

  // Méthode utilitaire pour les champs communs dans toMap()
  Map<String, dynamic> getBaseMap() => {
    "id": id,
    "code_id": codeId,
    "name": name,
    "prenom": prenom,
    "email": email,
    "password_reset_token": passwordResetToken,
    "password_reset_expires": passwordResetExpires,
    "contact": contact,
    "profile_image": profileImage,
    "agence_id": agenceId,
    "proprietaire_id": proprietaireId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  // Méthode utilitaire pour parser les champs communs depuis JSON
  static Map<String, dynamic> parseBaseFields(Map<String, dynamic> json) => {
    'id': json["id"],
    'codeId': json["code_id"],
    'name': json["name"],
    'prenom': json["prenom"],
    'email': json["email"],
    'passwordResetToken': json["password_reset_token"],
    'passwordResetExpires': json["password_reset_expires"],
    'contact': json["contact"] ??  json["telephone"],
    'profileImage': json["profile_image"],
    'agenceId': json["agence_id"],
    'proprietaireId': json["proprietaire_id"],
    'createdAt':
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    'updatedAt':
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  };
}
