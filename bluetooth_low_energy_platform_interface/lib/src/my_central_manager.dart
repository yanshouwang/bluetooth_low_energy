import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager.dart';
import 'my_logger_controller.dart';
import 'my_set_up.dart';

/// Platform-specific implementations should implement this class to support
/// [CentralManager].
abstract class MyCentralManager extends PlatformInterface
    with MySetUp, MyLoggerController
    implements CentralManager {
  static final Object _token = Object();

  static MyCentralManager? _instance;

  /// The default instance of [MyCentralManager] to use.
  static MyCentralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'CentralManager is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyCentralManager] when
  /// they register themselves.
  static set instance(MyCentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  final Logger logger;

  /// Constructs a [MyCentralManager].
  MyCentralManager()
      : logger = Logger('MyCentralManager'),
        super(token: _token);
}
