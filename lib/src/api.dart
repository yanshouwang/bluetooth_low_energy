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

  Future<int> get state;
  Stream<int> get stateChanged;
  Stream<Uint8List> get scanned;

  Future<bool> authorize();
  Future<void> startScan(List<Uint8List>? uuidBuffers);
  Future<void> stopScan();
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

  Stream<Tuple2<String, String>> get connectionLost;

  Future<void> free(String id);
  Future<void> connect(String id);
  Future<void> disconnect(String id);
  Future<int> requestMtu(String id);
  Future<List<Uint8List>> discoverServices(String id);
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

  Future<void> free(String id);
  Future<List<Uint8List>> discoverCharacteristics(String id);
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

  Stream<Tuple2<String, Uint8List>> get valueChanged;

  Future<void> free(String id);
  Future<List<Uint8List>> discoverDescriptors(String id);
  Future<Uint8List> read(String id);
  Future<void> write(String id, Uint8List value, bool withoutResponse);
  Future<void> setNotify(String id, bool value);
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

  Future<void> free(String id);
  Future<Uint8List> read(String id);
  Future<void> write(String id, Uint8List value);
}
