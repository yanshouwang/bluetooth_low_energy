import 'package:logging/logging.dart';

/// Settings of the logger instance.
abstract class LogController {
  /// Effective level considering the levels established in this logger's
  /// parents (when [hierarchicalLoggingEnabled] is true).
  Level get logLevel;

  /// Override the level for this particular [Logger] and its children.
  ///
  /// Setting this to `null` makes it inherit the [parent]s level.
  set logLevel(Level? value);
}
