import 'dart:async';

import 'package:pigeon/pigeon.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple/tuple.dart';

/// The [CentralControllerApi].
abstract class CentralControllerApi extends PlatformInterface {
  /// Constructs a [CentralControllerApi].
  CentralControllerApi() : super(token: _token);

  static final Object _token = Object();

  static late CentralControllerApi _instance;

  /// The default instance of [CentralControllerApi] to use.
  static CentralControllerApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralControllerApi] when
  /// they register themselves.
  static set instance(CentralControllerApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Tuple2<String, int>> get stateStream;
  Stream<Tuple2<String, Uint8List>> get advertisementStream;

  Future<void> create(String id);
  Future<int> getState(String id);
  Future<void> addStateObserver(String id);
  Future<void> removeStateObserver(String id);
  Future<void> startDiscovery(String id, List<String>? uuids);
  Future<void> stopDiscovery(String id);
  Future<void> destory(String id);
}
