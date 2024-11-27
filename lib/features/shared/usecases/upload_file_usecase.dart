import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/storage_service.dart';

class UploadFileParams {
  final String storagePath;
  final File file;

  UploadFileParams({
    required this.storagePath,
    required this.file,
  });
}

class UploadFileUseCase {
  final IStorageService storageService;
  final LoggerService logger;

  UploadFileUseCase({
    required this.storageService,
    required this.logger,
  });

  Future<Either<BaseApiError<FirebaseErrorReason>, String>> call(
    UploadFileParams params,
  ) async {
    try {
      final downloadUrl = await storageService.uploadFile(
        params.storagePath,
        params.file,
      );
      return Right(downloadUrl); // Success case
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'File upload failed: $e',
        error: e,
        stackTrace: stackTrace,
      );

      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      ); // Failure case
    }
  }
}
