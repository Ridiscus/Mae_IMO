# Guide d'utilisation polymorphe de UserModel

## Vue d'ensemble

Ce guide explique comment utiliser `UserModel` de manière polymorphe dans l'application Maelys-imo. Le polymorphisme permet de traiter différents types d'utilisateurs (`TenantModel`, `CollectionAgentModel`) de manière uniforme tout en conservant l'accès aux fonctionnalités spécifiques de chaque type.

## Architecture polymorphe

### Hiérarchie des classes

```
UserModel (abstract)
├── TenantModel (Locataires)
└── CollectionAgentModel (Agents de recouvrement)
```

### Enum UserType

```dart
enum UserType {
  tenant('tenant'),
  collectionAgent('collection_agent'),
  unknown('unknown');
}
```

## Utilisation de base

### 1. Authentification polymorphe

```dart
// Le service retourne UserModel, mais l'instance réelle dépend des données
final response = await authService.signIn(dto: loginRequest);
if (response.isSuccess) {
  UserModel user = response.data!;
  
  // Propriétés communes disponibles immédiatement
  print('Utilisateur: ${user.fullName}');
  print('Type: ${user.userType.value}');
  print('Email: ${user.email}');
}
```

### 2. Désérialisation polymorphe

```dart
// Depuis JSON - détection automatique du type
UserModel user = UserModel.fromJson(jsonString);

// Depuis Map - détection automatique du type  
UserModel user = UserModel.fromMap(jsonMap);
```

### 3. Traitement par type avec pattern matching

```dart
switch (user.userType) {
  case UserType.tenant:
    TenantModel tenant = user as TenantModel;
    print('Adresse: ${tenant.adresse}');
    print('Profession: ${tenant.profession}');
    break;
    
  case UserType.collectionAgent:
    CollectionAgentModel agent = user as CollectionAgentModel;
    print('Commune: ${agent.commune}');
    break;
    
  case UserType.unknown:
    print('Type d\'utilisateur inconnu');
    break;
}
```

## Méthodes utilitaires

### Vérification de type

```dart
// Vérifications booléennes
if (user.isTenant) {
  // Logique pour tenant
}

if (user.isCollectionAgent) {
  // Logique pour agent
}

if (user.isUnknownType) {
  // Gestion du type inconnu
}
```

### Cast sécurisé

```dart
// Cast sécurisé vers TenantModel
TenantModel? tenant = user.asTenant();
if (tenant != null) {
  print('Bien ID: ${tenant.bienId}');
}

// Cast sécurisé vers CollectionAgentModel
CollectionAgentModel? agent = user.asCollectionAgent();
if (agent != null) {
  print('Date de naissance: ${agent.dateNaissance}');
}
```

### Méthode `when` pour pattern matching fonctionnel

```dart
String description = user.when<String>(
  onTenant: (tenant) => 'Locataire: ${tenant.adresse}',
  onCollectionAgent: (agent) => 'Agent: ${agent.commune}',
  onUnknown: (user) => 'Utilisateur: ${user.fullName}',
);
```

## Utilisation dans l'interface utilisateur

### Widget polymorphe

```dart
// Le widget UserProfileWidget s'adapte automatiquement au type d'utilisateur
UserProfileWidget(
  user: user, // Peut être TenantModel ou CollectionAgentModel
  onTap: () {
    // Navigation adaptée au type
  },
  showActions: true,
)
```

### Exemple d'affichage conditionnel

```dart
Widget buildUserCard(UserModel user) {
  return Card(
    child: Column(
      children: [
        // Informations communes
        Text(user.fullName),
        Text(user.email ?? 'Email non renseigné'),
        
        // Informations spécifiques selon le type
        user.when<Widget>(
          onTenant: (tenant) => Column(
            children: [
              if (tenant.adresse != null) Text('Adresse: ${tenant.adresse}'),
              if (tenant.profession != null) Text('Profession: ${tenant.profession}'),
            ],
          ),
          onCollectionAgent: (agent) => Column(
            children: [
              if (agent.commune != null) Text('Commune: ${agent.commune}'),
              if (agent.dateNaissance != null) 
                Text('Âge: ${DateTime.now().year - agent.dateNaissance!.year} ans'),
            ],
          ),
          onUnknown: (user) => Text('Type d\'utilisateur inconnu'),
        ),
      ],
    ),
  );
}
```

## Gestion des listes mixtes

```dart
List<UserModel> users = [
  TenantModel(name: "Jean", prenom: "Dupont"),
  CollectionAgentModel(name: "Sophie", prenom: "Martin"),
  TenantModel(name: "Pierre", prenom: "Durand"),
];

// Traitement uniforme
for (var user in users) {
  print('${user.fullName} - ${user.userType.value}');
}

// Filtrage par type
final tenants = users.where((u) => u.isTenant).cast<TenantModel>().toList();
final agents = users.where((u) => u.isCollectionAgent).cast<CollectionAgentModel>().toList();
```

## Sérialisation polymorphe

### Vers JSON

```dart
// La sérialisation inclut automatiquement le type d'utilisateur
String json = user.toJson();
// Résultat: {"user_type": "tenant", "name": "Jean", ...}
```

### Depuis JSON avec détection automatique

La détection du type se base sur :

1. **Champ explicite** : `user_type` ou `type` dans le JSON
2. **Détection par champs spécifiques** :
   - Tenant : présence de `bien_id` ou `piece`
   - Agent : présence de `commune` ou `date_naissance`
3. **Défaut** : `TenantModel` si aucune détection

## Bonnes pratiques

### 1. Toujours vérifier le type avant le cast

```dart
// ✅ Bon
if (user.isTenant) {
  TenantModel tenant = user as TenantModel;
  // Utiliser tenant
}

// ❌ Éviter
TenantModel tenant = user as TenantModel; // Peut lever une exception
```

### 2. Utiliser les méthodes utilitaires

```dart
// ✅ Bon - Cast sécurisé
TenantModel? tenant = user.asTenant();
if (tenant != null) {
  // Utiliser tenant
}

// ✅ Bon - Pattern matching fonctionnel
String info = user.when<String>(
  onTenant: (t) => t.adresse ?? 'Adresse inconnue',
  onCollectionAgent: (a) => a.commune ?? 'Commune inconnue',
  onUnknown: (u) => 'Informations limitées',
);
```

### 3. Gérer le cas `unknown`

```dart
// Toujours prévoir le cas où le type est inconnu
switch (user.userType) {
  case UserType.tenant:
    // Logique tenant
    break;
  case UserType.collectionAgent:
    // Logique agent
    break;
  case UserType.unknown:
  default:
    // Logique de fallback
    print('Type d\'utilisateur non supporté');
    break;
}
```

## Exemples complets

Consultez le fichier `lib/core/utils/user_polymorphism_examples.dart` pour des exemples détaillés d'utilisation polymorphe, incluant :

- Authentification polymorphe
- Désérialisation depuis JSON
- Traitement de listes mixtes
- Sérialisation polymorphe
- Méthodes utilitaires

## Avantages du polymorphisme

1. **Code unifié** : Traitement commun des utilisateurs
2. **Extensibilité** : Facile d'ajouter de nouveaux types d'utilisateurs
3. **Type safety** : Vérifications de type à la compilation
4. **Maintenabilité** : Modifications centralisées dans `UserModel`
5. **Flexibilité** : Accès aux propriétés spécifiques quand nécessaire

## Extension future

Pour ajouter un nouveau type d'utilisateur :

1. Créer une nouvelle classe héritant de `UserModel`
2. Ajouter le type à l'enum `UserType`
3. Mettre à jour la factory `UserModel.fromMap()`
4. Implémenter les méthodes abstraites
5. Mettre à jour les widgets polymorphes si nécessaire
