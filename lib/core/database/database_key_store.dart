import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the SQLCipher key in Android Keystore-backed storage.
class DatabaseKeyStore {
  DatabaseKeyStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyName = 'database_key_v1';
  static const int _keyLengthBytes = 32;

  final FlutterSecureStorage _storage;

  Future<String> readOrCreate() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.isNotEmpty) return existing;
    final key = generate();
    await save(key);
    return key;
  }

  Future<void> save(String hexKey) =>
      _storage.write(key: _keyName, value: hexKey);

  /// 256 random bits as hex, the raw-key format SQLCipher accepts.
  String generate() {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < _keyLengthBytes; i++) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
