import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple/tuple.dart';

import 'impl.dart';

abstract class CentralManagerApi extends PlatformInterface {
  /// Constructs a [CentralManagerApi].
  CentralManagerApi() : super(token: _token);

  static final Object _token = Object();

  static CentralManagerApi _instance = MyCentralManagerApi();

  /// The default instance of [CentralManagerApi] to use.
  static CentralManagerApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManagerApi] when
  /// they register themselves.
  static set instance(CentralManagerApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<int> get stateStream;
  Stream<Uint8List> get advertisementStream;

  Future<bool> authorize();
  Future<int> getState();
  Future<void> addStateObserver();
  Future<void> removeStateObserver();
  Future<void> startScan(List<Uint8List>? uuidBuffers);
  Future<void> stopScan();
  Future<Uint8List> connect(Uint8List uuidBuffer);
}

abstract class PeripheralApi extends PlatformInterface {
  /// Constructs a [PeripheralApi].
  PeripheralApi() : super(token: _token);

  static final Object _token = Object();

  static PeripheralApi _instance = MyPeripheralApi();

  /// The default instance of [PeripheralApi] to use.
  static PeripheralApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeripheralApi] when
  /// they register themselves.
  static set instance(PeripheralApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Tuple2<int, Uint8List>> get connectionLostStream;

  Future<void> allocate(int id, int instanceId);
  Future<void> free(int id);
  Future<void> disconnect(int id);
  Future<List<Uint8List>> discoverServices(int id);
}

abstract class GattServiceApi extends PlatformInterface {
  /// Constructs a [GattServiceApi].
  GattServiceApi() : super(token: _token);

  static final Object _token = Object();

  static GattServiceApi _instance = MyGattServiceApi();

  /// The default instance of [GattServiceApi] to use.
  static GattServiceApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GattServiceApi] when
  /// they register themselves.
  static set instance(GattServiceApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> allocate(int id, int instanceId);
  Future<void> free(int id);
  Future<List<Uint8List>> discoverCharacteristics(int id);
}

abstract class GattCharacteristicApi extends PlatformInterface {
  /// Constructs a [GattCharacteristicApi].
  GattCharacteristicApi() : super(token: _token);

  static final Object _token = Object();

  static GattCharacteristicApi _instance = MyGattCharacteristicApi();

  /// The default instance of [GattCharacteristicApi] to use.
  static GattCharacteristicApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GattCharacteristicApi] when
  /// they register themselves.
  static set instance(GattCharacteristicApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Tuple2<int, Uint8List>> get valueStream;

  Future<void> allocate(int id, int instanceId);
  Future<void> free(int id);
  Future<List<Uint8List>> discoverDescriptors(int id);
  Future<Uint8List> read(int id);
  Future<void> write(int id, Uint8List value, bool withoutResponse);
  Future<void> setNotify(int id, bool value);
}

abstract class GattDescriptorApi extends PlatformInterface {
  /// Constructs a [GattDescriptorApi].
  GattDescriptorApi() : super(token: _token);

  static final Object _token = Object();

  static GattDescriptorApi _instance = MyGattDescriptorApi();

  /// The default instance of [GattDescriptorApi] to use.
  static GattDescriptorApi get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GattDescriptorApi] when
  /// they register themselves.
  static set instance(GattDescriptorApi instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> allocate(int id, int instanceId);
  Future<void> free(int id);
  Future<Uint8List> read(int id);
  Future<void> write(int id, Uint8List value);
}
