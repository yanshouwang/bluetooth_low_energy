import 'package:flutter/cupertino.dart';
import 'package:log_service/log_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'peripheral_manager.dart';

/// Platform-specific implementations should implement this class to support
/// [PeripheralManager].
abstract class MyPeripheralManager extends PlatformInterface
    with LoggerController
    implements PeripheralManager {
  static final Object _token = Object();

  static MyPeripheralManager? _instance;

  /// The default instance of [MyPeripheralManager] to use.
  static MyPeripheralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'PeripheralManager is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyPeripheralManager] when
  /// they register themselves.
  static set instance(MyPeripheralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [MyPeripheralManager].
  MyPeripheralManager() : super(token: _token);

  @protected
  @override
  Logger get logger => Logger('$PeripheralManager');
}
