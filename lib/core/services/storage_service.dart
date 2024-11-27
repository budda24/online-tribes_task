import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

abstract class IStorageService {
  Future<String> uploadFile(String path, File file);
  Future<void> deleteFile(String path);
  Future<String> getDownloadUrl(String path);
}

class FirebaseStorageService implements IStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final LoggerService _loggerService = getIt<LoggerService>();

  @override
  Future<String> uploadFile(String path, File file) async {
    return _retry(() async {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return ref.getDownloadURL();
    });
  }

  @override
  Future<void> deleteFile(String path) async {
    return _retry(() async {
      final ref = _storage.ref().child(path);
      await ref.delete();
    });
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<T> _retry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
  }) async {
    var retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        retryCount++;
        _loggerService.logError(
          message: 'Attempt $retryCount/$maxRetries failed',
          error: e,
          stackTrace: stackTrace,
        );
        if (retryCount >= maxRetries) {
          _loggerService.logError(message: 'Max retries exceeded.');
          rethrow;
        }
        // Optionally: You could add a delay before retrying (e.g., `await Future.delayed(Duration(seconds: 2));`)
      }
    }
    throw Exception('Operation failed after $maxRetries attempts');
  }
}
