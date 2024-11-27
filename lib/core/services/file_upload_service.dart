import 'dart:io';

import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/storage_service.dart';

class FileUploadService {
  final IStorageService storageService;
  final LoggerService logger;

  FileUploadService({
    required this.storageService,
    required this.logger,
  });

  /// This method handles file uploads with retry logic.
  Future<String?> uploadWithRetry({
    required String filePath,
    required File file,
    int maxRetries = 3,
  }) async {
    String? fileUrl;
    var retryCount = 0;
    var uploadSuccessful = false;

    // Retry logic for uploading files
    while (retryCount < maxRetries && !uploadSuccessful) {
      try {
        fileUrl = await storageService.uploadFile(filePath, file);
        uploadSuccessful = true;
      } catch (e, stackTrace) {
        retryCount++;
        logger.logError(
          message: 'Upload failed, attempt $retryCount/$maxRetries',
          error: e,
          stackTrace: stackTrace,
        );
        if (retryCount >= maxRetries) {
          logger.logError(message: 'Max retries exceeded. Upload failed.');
          return null; // Upload failed after all retries
        }
      }
    }

    return fileUrl;
  }
}
