import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStore {
  static final LocalStore _singleton = LocalStore._internal();

  factory LocalStore() {
    return _singleton;
  }

  LocalStore._internal();

  static const _storage = FlutterSecureStorage();

  static Future<void> setValue({required String key, String? value}) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getValue({required String key}) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete({required String key}) async {
    return await _storage.delete(key: key);
  }
}
