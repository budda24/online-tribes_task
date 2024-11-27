// lib/core/logging/logger_service.dart

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(),
    filter: ProductionFilter(),
  );

  void logInfo({
    required String message,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _logger.i(message, stackTrace: stackTrace, time: time);
  }

  void logWarning({
    required String message,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _logger.w(message, stackTrace: stackTrace, time: time);
  }

  void logError({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _logger.e(
      message,
      stackTrace: stackTrace,
      error: error,
      time: time,
    );
  }

  void logDebug({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    _logger.d(message, stackTrace: stackTrace, error: error, time: time);
  }
}

class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode) {
      // Only log warnings and errors in production
      return event.level.index >= Level.warning.index;
    }
    // Log everything in debug mode
    return true;
  }
}
