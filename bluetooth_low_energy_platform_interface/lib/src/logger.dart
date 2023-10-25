import 'dart:developer';

import 'package:logging/logging.dart' as inner;

/// Use a [Logger] to log debug messages.
///
/// [Logger]s are named using a hierarchical dot-separated name convention.
abstract class Logger {
  static final _logger = inner.Logger('BluetoothLowEnergy')
    ..onRecord.listen((record) {
      log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });

  /// Log message at level [LogLevel.CONFIG].
  static void config(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.config(message, error, stackTrace);
  }

  /// Log message at level [LogLevel.INFO].
  static void info(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.info(message, error, stackTrace);
  }

  /// Log message at level [LogLevel.WARNING].
  static void warning(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.warning(message, error, stackTrace);
  }
}
