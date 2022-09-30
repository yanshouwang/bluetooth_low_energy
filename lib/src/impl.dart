import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import 'broadcast.dart';
import 'api.dart';
import 'bluetooth_state.dart';
import 'central_manager.dart';
import 'gatt_characteristic.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';
import 'pigeon.dart';
import 'proto.dart' as proto;
import 'uuid.dart';

const bluetoothLowEnergyError = 'bluetoothLowEnergyError';

class MyCentralManagerApi extends CentralManagerApi
    implements CentralManagerFlutterApi {
  final hostApi = CentralManagerHostApi();
  final stateStreamController = StreamController<int>.broadcast();
  final broadcastStreamController = StreamController<Uint8List>.broadcast();

  MyCentralManagerApi() {
    CentralManagerFlutterApi.setup(this);
  }

  @override
  Future<int> get state => hostApi.getState();
  @override
  Stream<int> get stateChanged => stateStreamController.stream;
  @override
  Stream<Uint8List> get scanned => broadcastStreamController.stream;

  @override
  Future<bool> authorize() {
    return hostApi.authorize();
  }

  @override
  Future<void> startScan(List<Uint8List>? uuidBuffers) {
    return hostApi.startScan(uuidBuffers);
  }

  @override
  Future<void> stopScan() {
    return hostApi.stopScan();
  }

  @override
  void onStateChanged(int stateNumber) {
    stateStreamController.add(stateNumber);
  }

  @override
  void onScanned(Uint8List broadcastBuffer) {
    broadcastStreamController.add(broadcastBuffer);
  }
}

class MyPeripheralApi extends PeripheralApi implements PeripheralFlutterApi {
  final hostApi = PeripheralHostApi();
  final connectionLostStreamController =
      StreamController<Tuple2<String, String>>.broadcast();

  MyPeripheralApi() {
    PeripheralFlutterApi.setup(this);
  }

  @override
  Stream<Tuple2<String, String>> get connectionLost =>
      connectionLostStreamController.stream;

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<void> connect(String id) {
    return hostApi.connect(id);
  }

  @override
  Future<void> disconnect(String id) {
    return hostApi.disconnect(id);
  }

  @override
  Future<int> requestMtu(String id) {
    return hostApi.requestMtu(id);
  }

  @override
  Future<List<Uint8List>> discoverServices(String id) {
    return hostApi.discoverServices(id).then((buffers) => buffers.cast());
  }

  @override
  void onConnectionLost(String id, String errorMessage) {
    final event = Tuple2(id, errorMessage);
    connectionLostStreamController.add(event);
  }
}

class MyGattServiceApi extends GattServiceApi {
  final hostApi = GattServiceHostApi();

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverCharacteristics(String id) {
    return hostApi
        .discoverCharacteristics(id)
        .then((buffers) => buffers.cast());
  }
}

class MyGattCharacteristicApi extends GattCharacteristicApi
    implements GattCharacteristicFlutterApi {
  final hostApi = GattCharacteristicHostApi();

  MyGattCharacteristicApi() {
    GattCharacteristicFlutterApi.setup(this);
  }

  final valueStreamController =
      StreamController<Tuple2<String, Uint8List>>.broadcast();

  @override
  Stream<Tuple2<String, Uint8List>> get valueChanged =>
      valueStreamController.stream;

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverDescriptors(String id) {
    return hostApi.discoverDescriptors(id).then((buffers) => buffers.cast());
  }

  @override
  Future<Uint8List> read(String id) {
    return hostApi.read(id);
  }

  @override
  Future<void> write(String id, Uint8List value, bool withoutResponse) {
    return hostApi.write(id, value, withoutResponse);
  }

  @override
  Future<void> setNotify(String id, bool value) {
    return hostApi.setNotify(id, value);
  }

  @override
  void onValueChanged(String id, Uint8List value) {
    final event = Tuple2(id, value);
    valueStreamController.add(event);
  }
}

class MyGattDescriptorApi extends GattDescriptorApi {
  final hostApi = GattDescriptorHostApi();

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<Uint8List> read(String id) {
    return hostApi.read(id);
  }

  @override
  Future<void> write(String id, Uint8List value) {
    return hostApi.write(id, value);
  }
}

class MyCentralManager implements CentralManager {
  static CentralManagerApi get api => CentralManagerApi.instance;

  @override
  Future<BluetoothState> get state =>
      api.state.then((number) => BluetoothState.values[number]);
  @override
  Stream<BluetoothState> get stateChanged =>
      api.stateChanged.map((number) => BluetoothState.values[number]);
  @override
  Stream<Broadcast> get scanned =>
      api.scanned.map((buffer) => MyBroadcast.fromBuffer(buffer));

  @override
  Future<bool> authorize() {
    return api.authorize();
  }

  @override
  Future<void> startScan({List<UUID>? uuids}) {
    final uuidBuffers = uuids?.map((uuid) => uuid.buffer).toList();
    return api.startScan(uuidBuffers);
  }

  @override
  Future<void> stopScan() {
    return api.stopScan();
  }
}

class MyBroadcast implements Broadcast {
  @override
  final Peripheral peripheral;
  @override
  final int rssi;
  @override
  final bool? connectable;
  @override
  final Uint8List data;
  @override
  final String? localName;
  @override
  final Uint8List manufacturerSpecificData;
  @override
  final Map<UUID, Uint8List> serviceData;
  @override
  final List<UUID> serviceUUIDs;
  @override
  final List<UUID> solicitedServiceUUIDs;
  @override
  final int? txPowerLevel;

  MyBroadcast({
    required this.peripheral,
    required this.rssi,
    required this.connectable,
    required this.data,
    required this.localName,
    required this.manufacturerSpecificData,
    required this.serviceData,
    required this.serviceUUIDs,
    required this.solicitedServiceUUIDs,
    required this.txPowerLevel,
  });

  factory MyBroadcast.fromBuffer(Uint8List buffer) {
    final broadcast = proto.Broadcast.fromBuffer(buffer);
    final peripheral = MyPeripheral.fromProto(broadcast.peripheral);
    final rssi = broadcast.rssi;
    final connectable =
        broadcast.hasConnectable() ? broadcast.connectable : null;
    final data = Uint8List.fromList(broadcast.data);
    final localName = broadcast.hasLocalName() ? broadcast.localName : null;
    final manufacturerSpecificData =
        Uint8List.fromList(broadcast.manufacturerSpecificData);
    final serviceData = {
      for (var serviceData in broadcast.serviceDatas)
        MyUUID.fromProto(serviceData.uuid): Uint8List.fromList(serviceData.data)
    };
    final serviceUUIDs =
        broadcast.serviceUuids.map((uuid) => MyUUID.fromProto(uuid)).toList();
    final solicitedServiceUUIDs = broadcast.solicitedServiceUuids
        .map((uuid) => MyUUID.fromProto(uuid))
        .toList();
    final txPowerLevel =
        broadcast.hasTxPowerLevel() ? broadcast.txPowerLevel : null;
    return MyBroadcast(
      peripheral: peripheral,
      rssi: rssi,
      connectable: connectable,
      data: data,
      localName: localName,
      manufacturerSpecificData: manufacturerSpecificData,
      serviceData: serviceData,
      serviceUUIDs: serviceUUIDs,
      solicitedServiceUUIDs: solicitedServiceUUIDs,
      txPowerLevel: txPowerLevel,
    );
  }
}

class MyPeripheral implements Peripheral {
  static PeripheralApi get api => PeripheralApi.instance;

  static final finalizer = Finalizer<String>((id) {
    api.free(id);
  });

  final String id;
  @override
  final UUID uuid;

  MyPeripheral({required this.id, required this.uuid}) {
    finalizer.attach(
      this,
      id,
    );
  }

  factory MyPeripheral.fromProto(proto.Peripheral peripheral) {
    return MyPeripheral(
      id: peripheral.id,
      uuid: MyUUID.fromProto(peripheral.uuid),
    );
  }

  @override
  Stream<Exception> get connectionLost =>
      api.connectionLost.where((event) => event.item1 == id).map(
            (event) => PlatformException(
              code: bluetoothLowEnergyError,
              message: event.item2,
            ),
          );

  @override
  Future<void> connect() {
    return api.connect(id);
  }

  @override
  Future<void> disconnect() {
    return api.disconnect(id);
  }

  @override
  Future<int> requestMtu() {
    return api.requestMtu(id);
  }

  @override
  Future<List<GattService>> discoverServices() {
    return api.discoverServices(id).then(
          (buffers) => buffers
              .map((buffer) => MyGattService.fromBuffer(buffer))
              .toList(),
        );
  }
}

class MyGattService extends GattService {
  static GattServiceApi get api => GattServiceApi.instance;

  static final finalizer = Finalizer<String>((id) {
    api.free(id);
  });

  final String id;
  @override
  final UUID uuid;

  MyGattService({required this.id, required this.uuid}) {
    finalizer.attach(
      this,
      id,
    );
  }

  factory MyGattService.fromBuffer(Uint8List buffer) {
    final service = proto.GattService.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(service.uuid);
    return MyGattService(
      id: service.id,
      uuid: uuid,
    );
  }

  @override
  Future<List<GattCharacteristic>> discoverCharacteristics() {
    return api.discoverCharacteristics(id).then(
          (buffers) => buffers
              .map((buffer) => MyGattCharacteristic.fromBuffer(buffer))
              .toList(),
        );
  }
}

class MyGattCharacteristic extends GattCharacteristic {
  static GattCharacteristicApi get api => GattCharacteristicApi.instance;

  static final finalizer = Finalizer<String>((id) {
    api.free(id);
  });

  final String id;
  @override
  final UUID uuid;
  @override
  final bool canRead;
  @override
  final bool canWrite;
  @override
  final bool canWriteWithoutResponse;
  @override
  final bool canNotify;

  MyGattCharacteristic({
    required this.id,
    required this.uuid,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
  }) {
    finalizer.attach(
      this,
      id,
    );
  }

  factory MyGattCharacteristic.fromBuffer(Uint8List buffer) {
    final characteristic = proto.GattCharacteristic.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(characteristic.uuid);
    final canRead = characteristic.canRead;
    final canWrite = characteristic.canWrite;
    final canWriteWithoutResponse = characteristic.canWriteWithoutResponse;
    final canNotify = characteristic.canNotify;
    return MyGattCharacteristic(
      id: characteristic.id,
      uuid: uuid,
      canRead: canRead,
      canWrite: canWrite,
      canWriteWithoutResponse: canWriteWithoutResponse,
      canNotify: canNotify,
    );
  }

  @override
  Stream<Uint8List> get valueChanged => api.valueChanged
      .where((event) => event.item1 == id)
      .map((event) => event.item2);

  @override
  Future<List<GattDescriptor>> discoverDescriptors() {
    return api.discoverDescriptors(id).then(
          (buffers) => buffers
              .map((buffer) => MyGattDescriptor.fromBuffer(buffer))
              .toList(),
        );
  }

  @override
  Future<Uint8List> read() {
    return api.read(id);
  }

  @override
  Future<void> write(Uint8List value, {bool withoutResponse = false}) {
    return api.write(id, value, withoutResponse);
  }

  @override
  Future<void> setNotify(bool value) {
    return api.setNotify(id, value);
  }
}

class MyGattDescriptor extends GattDescriptor {
  static GattDescriptorApi get api => GattDescriptorApi.instance;

  static final finalizer = Finalizer<String>((id) {
    GattDescriptorApi.instance.free(id);
  });

  final String id;
  @override
  final UUID uuid;

  MyGattDescriptor({required this.id, required this.uuid}) {
    finalizer.attach(
      this,
      id,
    );
  }

  factory MyGattDescriptor.fromBuffer(Uint8List buffer) {
    final descriptor = proto.GattDescriptor.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(descriptor.uuid);
    return MyGattDescriptor(
      id: descriptor.id,
      uuid: uuid,
    );
  }

  @override
  Future<Uint8List> read() {
    return api.read(id);
  }

  @override
  Future<void> write(Uint8List value) {
    return api.write(id, value);
  }
}

class MyUUID implements UUID {
  @override
  final String value;

  MyUUID({required this.value});

  factory MyUUID.fromProto(proto.UUID uuid) {
    final value = uuid.value;
    return MyUUID(value: value);
  }

  // factory MyUUID.fromBuffer(Uint8List buffer) {
  //   final uuid = proto.UUID.fromBuffer(buffer);
  //   return MyUUID.fromProto(uuid);
  // }

  @override
  String toString() {
    return 'UUID: $value';
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyUUID && other.value == value;
  }
}

extension on UUID {
  Uint8List get buffer => proto.UUID(value: value).writeToBuffer();
}
