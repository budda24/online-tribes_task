import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class EncryptionService {
  EncryptionService(this._secureStorage, this._hive);

  final FlutterSecureStorage _secureStorage;
  final HiveInterface _hive;

  Future<Uint8List> get encryptionKeyUint8List async {
    var encryptionKey = await _secureStorage.read(key: 'encryptionKey');
    if (encryptionKey == null) {
      final newKey = _hive.generateSecureKey();
      encryptionKey = base64UrlEncode(newKey);
      await _secureStorage.write(key: 'encryptionKey', value: encryptionKey);
    }
    return base64Url.decode(encryptionKey);
  }
}
