import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple/tuple.dart';

/// The [CentralControllerApi].
abstract class CentralControllerApi extends PlatformInterface {
  /// Constructs a [CentralControllerApi].
  CentralControllerApi() : super(token: _token);

  static final Object _token = Object();

  static CentralControllerApi _instance = _CentralControllerApi();

  /// The default instance of [CentralControllerApi] to use.
  ///
  /// Defaults to [_CentralControllerApi].
  static CentralControllerApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralControllerApi] when
  /// they register themselves.
  static set instance(CentralControllerApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Tuple2<String, int>> get stateStream;
  Stream<Tuple2<String, Discovery>> get discoveryStream;

  Future<void> create(String id);
  Future<int> getState(String id);
  Future<void> startDiscovery(String id, List<String> uuidStrings);
  Future<void> stopDiscovery(String id);
  Future<Peripherial> connect(String id, String uuidString);
  Future<void> dispose(String id);
}

class _CentralControllerApi extends CentralControllerApi {}
