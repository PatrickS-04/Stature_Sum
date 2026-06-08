import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final _storage = const FlutterSecureStorage();

  Future<void> writeString(String key, String value) async => 
    await _storage.write(key: key, value: value);
  Future<String?> readString(String key) async => await _storage.read(key: key);

  Future<void> writeFloat(String key, double value) async => 
    await _storage.write(key: key, value: value.toString());
  Future<double> readFloat(String key) async {
    String? value = await _storage.read(key: key);
    return value != null ? double.parse(value) : 0.0;
  }

  Future<void> writeAssetList(Set<String> assets) async {
    await _storage.write(key: 'assetList', value: jsonEncode(assets.toList()));
  }

  Future<Set<String>> readAssetList() async {
    String? jsonString = await _storage.read(key: 'assetList');
    if (jsonString == null) return {};
    List<dynamic> list = jsonDecode(jsonString);
    return list.map((items) => items.toString()).toSet();
  }

  Future<void> writeBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<bool?> readBool(String key) async {
    String? value = await _storage.read(key: key);
    if (value == null) return null;
    return value == 'true';
  }
}