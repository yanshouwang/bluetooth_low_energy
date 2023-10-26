import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager.dart';

/// Platform-specific implementations should implement this class to support
/// [CentralManager].
abstract class MyCentralManager extends PlatformInterface
    implements CentralManager {
  /// Constructs a [MyCentralManager].
  MyCentralManager() : super(token: _token);

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
}
