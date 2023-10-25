import 'dart:developer';

import 'package:logging/logging.dart' as logging;

/// [LogLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [LogLevel]. [LogLevel]s are ordered using an integer
/// value [LogLevel.value]. The predefined [LogLevel] constants below are sorted as
/// follows (in descending order): [LogLevel.SHOUT], [LogLevel.SEVERE],
/// [LogLevel.WARNING], [LogLevel.INFO], [LogLevel.CONFIG], [LogLevel.FINE], [LogLevel.FINER],
/// [LogLevel.FINEST], and [LogLevel.ALL].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [LogLevel.ALL] and
/// [LogLevel.OFF].
typedef LogLevel = logging.Level;

/// Use a [Logger] to log debug messages.
///
/// [Logger]s are named using a hierarchical dot-separated name convention.
abstract class Logger {
  static final _logger = logging.Logger('BluetoothLowEnergy')
    ..level = LogLevel.ALL
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

  /// Get the level of the [Logger].
  static LogLevel get level => _logger.level;

  /// Set the level of the [Logger].
  static set level(LogLevel level) {
    _logger.level = level;
  }

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
