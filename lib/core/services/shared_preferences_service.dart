import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal() {
    _init();
  }

  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveString(SharedPreferencesKeys key, String value) async {
    await _prefs?.setString(key.name, value);
  }

  String? getString(SharedPreferencesKeys key) {
    return _prefs?.getString(key.name);
  }

  Future<void> saveInt(SharedPreferencesKeys key, int value) async {
    await _prefs?.setInt(key.name, value);
  }

  int? getInt(SharedPreferencesKeys key) {
    return _prefs?.getInt(key.name);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> saveBool(SharedPreferencesKeys key, bool value) async {
    await _prefs?.setBool(key.name, value);
  }

  bool? getBool(SharedPreferencesKeys key) {
    return _prefs?.getBool(key.name);
  }

  Future<void> remove(SharedPreferencesKeys key) async {
    await _prefs?.remove(key.name);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}

enum SharedPreferencesKeys {
  nothing,
}
