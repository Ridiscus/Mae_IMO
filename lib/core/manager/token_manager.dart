import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive_flutter/hive_flutter.dart';

class TokenManager {
  String? redirectRoute;

  /// Clé utilisée pour stocker le token dans Hive
  final String _cacheName = 'token';

  /// Clé utilisée pour stocker la clé de chiffrement
  final String _encryptionKey = 'encryption_key';

  /// Instance de la box Hive utilisée pour le stockage
  late Box _box;

  /// Initialise Hive et ouvre la box de stockage.
  /// Cette méthode doit être appelée avant toute utilisation de TokenManager,
  /// généralement au démarrage de l'application.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox("box_hive_maelys_imo");
  }

  /// Constructeur qui initialise la box Hive et la clé de chiffrement.
  TokenManager() {
    _box = Hive.box("box_hive_maelys_imo");
    _initializeEncryptionKey();
  }

  /// Initialise la clé de chiffrement si elle n'existe pas déjà.
  /// Génère une nouvelle clé de chiffrement aléatoire de 32 bytes
  /// et la stocke de manière sécurisée dans Hive.
  Future<void> _initializeEncryptionKey() async {
    if (!_box.containsKey(_encryptionKey)) {
      final key = encrypt.Key.fromSecureRandom(32).base64;
      await _box.put(_encryptionKey, key);
    }
  }

  /// Chiffre une chaîne de caractères avec AES.
  ///
  /// Utilise un IV (Initialization Vector) unique pour chaque chiffrement
  /// et stocke l'IV avec les données chiffrées pour le déchiffrement.
  ///
  /// [data] La chaîne à chiffrer
  /// Retourne la chaîne chiffrée encodée en base64 avec son IV
  String _encryptData(String data) {
    final key = encrypt.Key.fromBase64(_box.get(_encryptionKey));
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return json.encode({'data': encrypted.base64, 'iv': iv.base64});
  }

  /// Déchiffre une chaîne précédemment chiffrée avec [_encryptData].
  ///
  /// [encryptedData] La chaîne chiffrée à déchiffrer
  /// Retourne la chaîne déchiffrée
  String _decryptData(String encryptedData) {
    final key = encrypt.Key.fromBase64(_box.get(_encryptionKey));
    final data = json.decode(encryptedData);
    final iv = encrypt.IV.fromBase64(data['iv']);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt64(data['data'], iv: iv);
  }

  /// Stocke le token d'authentification de manière sécurisée.
  Future<void> storeUserToken(String token) async {
    final encryptedToken = _encryptData(token);
    await _box.put(_cacheName, encryptedToken);
  }

  /// Retourne le token déchiffré ou null si aucun token n'est stocké.
  Future<String?> getUserToken() async {
    final encryptedToken = _box.get(_cacheName);
    if (encryptedToken == null) return null;
    return _decryptData(encryptedToken);
  }

  /// Cette méthode est typiquement appelée lors de la déconnexion de l'utilisateur.
  Future<void> removeUserToken() async {
    await _box.delete(_cacheName);
  }

  /// Retourne true si un token existe, false sinon.
  Future<bool> hasUserToken() async {
    return _box.containsKey(_cacheName);
  }
}
