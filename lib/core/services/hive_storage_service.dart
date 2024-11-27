import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';

class HiveStorageService {
  HiveStorageService(this._hive);

  final HiveInterface _hive;

  Future<void> openBox(HiveBoxType boxName) async {
    try {
      if (!_hive.isBoxOpen(boxName.name)) {
        await _hive.openBox<dynamic>(boxName.name);
      }
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message: 'Error opening box ${boxName.name}: $e',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }

  Future<dynamic> get(
    HiveBoxType boxName,
    String key,
  ) async {
    try {
      await openBox(boxName);
      final box = _hive.box<dynamic>(boxName.name);
      final value = box.get(key);

      // Check if the retrieved value is JSON and decode it
      if (value is String && (value.startsWith('{') || value.startsWith('['))) {
        return json.decode(value);
      }
      return value;
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message:
            'Error retrieving data from box ${boxName.name} for key: $key.',
        error: e,
        stackTrace: stacktrace,
      );

      return null;
    }
  }

  Future<void> put(HiveBoxType boxName, String key, dynamic value) async {
    try {
      await openBox(boxName);
      dynamic storedValue = value;

      if (value is Map || value is List) {
        storedValue = json.encode(value);
      }

      await _hive.box<dynamic>(boxName.name).put(key, storedValue);
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message: 'Error storing data in box ${boxName.name} for key: $key.',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }

  Future<void> delete(
    HiveBoxType boxName,
    String key,
  ) async {
    try {
      await openBox(boxName);
      await _hive.box<void>(boxName.name).delete(key);
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message: 'Error deleting data in box ${boxName.name} for key: $key.',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }

  Future<void> clearBox(HiveBoxType boxName) async {
    try {
      await openBox(boxName);
      await _hive.box<void>(boxName.name).clear();
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message: 'Error clearing box ${boxName.name}.',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }

  Future<void> closeBox(HiveBoxType boxName) async {
    try {
      if (_hive.isBoxOpen(boxName.name)) {
        await _hive.box<void>(boxName.name).compact();
        await _hive.box<void>(boxName.name).close();
      }
    } catch (e, stacktrace) {
      getIt<LoggerService>().logError(
        message: 'Error closing box ${boxName.name}. Error: $e',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }
}
