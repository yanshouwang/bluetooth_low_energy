import 'dart:async';
import 'dart:developer';

import 'package:logging/logging.dart';

import 'logger_controller.dart';
import 'set_up.dart';

/// Sets up logger for a bluetooth low energy manager.
mixin MyLoggerController on SetUp implements LoggerController {
  StreamSubscription<LogRecord>? _subscription;

  /// The logger used to log debug messages.
  Logger get logger;

  @override
  Level get logLevel => logger.level;
  @override
  set logLevel(Level? value) {
    hierarchicalLoggingEnabled = true;
    logger.level = value;
  }

  @override
  Future<void> setUp() async {
    hierarchicalLoggingEnabled = true;
    _subscription?.cancel();
    _subscription = logger.onRecord.listen(_onRecord);
  }

  void _onRecord(LogRecord record) {
    final message = record.message;
    final time = record.time;
    final sequenceNumber = record.sequenceNumber;
    final level = record.level.value;
    final name = record.loggerName;
    final zone = record.zone;
    final error = record.error;
    final stackTrace = record.stackTrace;
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
