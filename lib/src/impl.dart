import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import 'advertisement.dart';
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

final finalizer = Finalizer<void Function()>((free) => free());

const bluetoothLowEnergyError = 'bluetoothLowEnergyError';

class MyCentralManagerApi extends CentralManagerApi
    implements CentralManagerFlutterApi {
  final hostApi = CentralManagerHostApi();
  final stateStreamController = StreamController<int>.broadcast();
  final advertisementStreamController = StreamController<Uint8List>.broadcast();

  MyCentralManagerApi() {
    CentralManagerFlutterApi.setup(this);
  }

  @override
  Stream<int> get stateStream => stateStreamController.stream;

  @override
  Stream<Uint8List> get advertisementStream =>
      advertisementStreamController.stream;

  @override
  Future<bool> authorize() {
    return hostApi.authorize();
  }

  @override
  Future<int> getState() {
    return hostApi.getState();
  }

  @override
  Future<void> addStateObserver() {
    return hostApi.addStateObserver();
  }

  @override
  Future<void> removeStateObserver() {
    return hostApi.removeStateObserver();
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
  Future<Uint8List> connect(Uint8List uuidBuffer) {
    return hostApi.connect(uuidBuffer);
  }

  @override
  void notifyState(int stateNumber) {
    stateStreamController.add(stateNumber);
  }

  @override
  void notifyAdvertisement(Uint8List advertisementBuffer) {
    advertisementStreamController.add(advertisementBuffer);
  }
}

class MyPeripheralApi extends PeripheralApi implements PeripheralFlutterApi {
  final hostApi = PeripheralHostApi();
  final connectionLostStreamController =
      StreamController<Tuple2<int, Uint8List>>.broadcast();

  MyPeripheralApi() {
    PeripheralFlutterApi.setup(this);
  }

  @override
  Stream<Tuple2<int, Uint8List>> get connectionLostStream =>
      connectionLostStreamController.stream;

  @override
  Future<void> allocate(int id, int instanceId) {
    return hostApi.allocate(id, instanceId);
  }

  @override
  Future<void> free(int id) {
    return hostApi.free(id);
  }

  @override
  Future<void> disconnect(int id) {
    return hostApi.disconnect(id);
  }

  @override
  Future<List<Uint8List>> discoverServices(int id) {
    return hostApi.discoverServices(id).then((value) => value.cast());
  }

  @override
  void notifyConnectionLost(int id, Uint8List errorBuffer) {
    final event = Tuple2(id, errorBuffer);
    connectionLostStreamController.add(event);
  }
}

class MyGattServiceApi extends GattServiceApi {
  final hostApi = GattServiceHostApi();

  @override
  Future<void> allocate(int id, int instanceId) {
    return hostApi.allocate(id, instanceId);
  }

  @override
  Future<void> free(int id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverCharacteristics(int id) {
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
      StreamController<Tuple2<int, Uint8List>>.broadcast();

  @override
  Stream<Tuple2<int, Uint8List>> get valueStream =>
      valueStreamController.stream;

  @override
  Future<void> allocate(int id, int instanceId) {
    return hostApi.allocate(id, instanceId);
  }

  @override
  Future<void> free(int id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverDescriptors(int id) {
    return hostApi.discoverDescriptors(id).then((buffers) => buffers.cast());
  }

  @override
  Future<Uint8List> read(int id) {
    return hostApi.read(id);
  }

  @override
  Future<void> write(int id, Uint8List value, bool withoutResponse) {
    return hostApi.write(id, value, withoutResponse);
  }

  @override
  Future<void> setNotify(int id, bool value) {
    return hostApi.setNotify(id, value);
  }

  @override
  void notifyValue(int id, Uint8List value) {
    final event = Tuple2(id, value);
    valueStreamController.add(event);
  }
}

class MyGattDescriptorApi extends GattDescriptorApi {
  final hostApi = GattDescriptorHostApi();

  @override
  Future<void> allocate(int id, int instanceId) {
    return hostApi.allocate(id, instanceId);
  }

  @override
  Future<void> free(int id) {
    return hostApi.free(id);
  }

  @override
  Future<Uint8List> read(int id) {
    return hostApi.read(id);
  }

  @override
  Future<void> write(int id, Uint8List value) {
    return hostApi.write(id, value);
  }
}

class MyCentralManager implements CentralManager {
  @override
  Stream<Advertisement> getAdvertisementStream({List<UUID>? uuids}) {
    return CentralManagerApi.instance.advertisementStream
        .map((buffer) => MyAdvertisement.fromBuffer(buffer))
        .asBroadcastStream(
      onListen: (subscription) async {
        subscription.resume();
        final uuidBuffers = uuids
            ?.map((e) => proto.UUID(value: e.value).writeToBuffer())
            .toList();
        await CentralManagerApi.instance.startScan(uuidBuffers);
      },
      onCancel: (subscription) async {
        // TODO: the stream can't listen again when use `subscription.cancel()`.
        await CentralManagerApi.instance.stopScan();
        subscription.pause();
      },
    );
  }

  @override
  Future<bool> authorize() {
    return CentralManagerApi.instance.authorize();
  }

  @override
  Future<BluetoothState> getState() {
    return CentralManagerApi.instance
        .getState()
        .then((number) => BluetoothState.values[number]);
  }

  @override
  Stream<BluetoothState> get stateStream =>
      CentralManagerApi.instance.stateStream
          .map((number) => BluetoothState.values[number])
          .asBroadcastStream(
        onListen: (subscription) async {
          subscription.resume();
          await CentralManagerApi.instance.addStateObserver();
        },
        onCancel: (subscription) async {
          // TODO: the stream can't listen again when use `subscription.cancel()`.
          await CentralManagerApi.instance.removeStateObserver();
          subscription.pause();
        },
      );

  @override
  Future<Peripheral> connect(
    UUID uuid, {
    Function(Exception)? onConnectionLost,
  }) {
    return CentralManagerApi.instance
        .connect(uuid.buffer)
        .then((buffer) => MyPeripheral.fromBuffer(buffer, onConnectionLost));
  }
}

class MyAdvertisement implements Advertisement {
  @override
  final UUID uuid;
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

  MyAdvertisement({
    required this.uuid,
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

  factory MyAdvertisement.fromBuffer(Uint8List buffer) {
    final advertisement = proto.Advertisement.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(advertisement.uuid);
    final rssi = advertisement.rssi;
    final connectable =
        advertisement.hasConnectable() ? advertisement.connectable : null;
    final data = Uint8List.fromList(advertisement.data);
    final localName =
        advertisement.hasLocalName() ? advertisement.localName : null;
    final manufacturerSpecificData =
        Uint8List.fromList(advertisement.manufacturerSpecificData);
    final serviceData = {
      for (var serviceData in advertisement.serviceDatas)
        MyUUID.fromProto(serviceData.uuid): Uint8List.fromList(serviceData.data)
    };
    final serviceUUIDs = advertisement.serviceUuids
        .map((uuid) => MyUUID.fromProto(uuid))
        .toList();
    final solicitedServiceUUIDs = advertisement.solicitedServiceUuids
        .map((uuid) => MyUUID.fromProto(uuid))
        .toList();
    final txPowerLevel =
        advertisement.hasTxPowerLevel() ? advertisement.txPowerLevel : null;
    return MyAdvertisement(
      uuid: uuid,
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
  late StreamSubscription<Tuple2<int, Uint8List>>
      connectionLostStreamSubscription;

  @override
  final int maximumWriteLength;

  MyPeripheral({
    required this.maximumWriteLength,
    required int instanceId,
    Function(Exception)? onConnectionLost,
  }) {
    PeripheralApi.instance.allocate(hashCode, instanceId);
    connectionLostStreamSubscription = PeripheralApi
        .instance.connectionLostStream
        .where((event) => event.item1 == hashCode)
        .listen((event) {
      final error = PlatformException(
        code: bluetoothLowEnergyError,
        message: '',
      );
      onConnectionLost?.call(error);
    });
    finalizer.attach(
      this,
      () {
        connectionLostStreamSubscription.cancel();
        PeripheralApi.instance.free(hashCode);
      },
    );
  }

  factory MyPeripheral.fromBuffer(
    Uint8List buffer,
    Function(Exception)? onConnectionLost,
  ) {
    final peripheral = proto.Peripheral.fromBuffer(buffer);
    return MyPeripheral(
      maximumWriteLength: peripheral.maximumWriteLength,
      instanceId: peripheral.id.toInt(),
      onConnectionLost: onConnectionLost,
    );
  }

  @override
  Future<void> disconnect() {
    return PeripheralApi.instance.disconnect(hashCode);
  }

  @override
  Future<List<GattService>> discoverServices() {
    return PeripheralApi.instance.discoverServices(hashCode).then(
          (buffers) => buffers
              .map((buffer) => MyGattService.fromBuffer(buffer))
              .toList(),
        );
  }
}

class MyGattService extends GattService {
  @override
  final UUID uuid;

  MyGattService({required this.uuid, required int instanceId}) {
    GattServiceApi.instance.allocate(hashCode, instanceId);
    finalizer.attach(
      this,
      () => GattServiceApi.instance.free(hashCode),
    );
  }

  factory MyGattService.fromBuffer(Uint8List buffer) {
    final service = proto.GattService.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(service.uuid);
    return MyGattService(
      uuid: uuid,
      instanceId: service.id.toInt(),
    );
  }

  @override
  Future<List<GattCharacteristic>> discoverCharacteristics() {
    return GattServiceApi.instance.discoverCharacteristics(hashCode).then(
          (buffers) => buffers
              .map((buffer) => MyGattCharacteristic.fromBuffer(buffer))
              .toList(),
        );
  }
}

class MyGattCharacteristic extends GattCharacteristic {
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
    required this.uuid,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required int instanceId,
  }) {
    GattCharacteristicApi.instance.allocate(hashCode, instanceId);
    finalizer.attach(
      this,
      () => GattCharacteristicApi.instance.free(hashCode),
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
      uuid: uuid,
      canRead: canRead,
      canWrite: canWrite,
      canWriteWithoutResponse: canWriteWithoutResponse,
      canNotify: canNotify,
      instanceId: characteristic.id.toInt(),
    );
  }

  @override
  Stream<Uint8List> get valueStream =>
      GattCharacteristicApi.instance.valueStream
          .where((event) => event.item1 == hashCode)
          .map((event) => event.item2)
          .asBroadcastStream(
        onListen: (subscription) async {
          subscription.resume();
          await GattCharacteristicApi.instance.setNotify(hashCode, true);
        },
        onCancel: (subscription) async {
          // TODO: the stream can't listen again when use `subscription.cancel()`.
          await GattCharacteristicApi.instance.setNotify(hashCode, false);
          subscription.pause();
        },
      );

  @override
  Future<List<GattDescriptor>> discoverDescriptors() {
    return GattCharacteristicApi.instance.discoverDescriptors(hashCode).then(
          (buffers) => buffers
              .map((buffer) => MyGattDescriptor.fromBuffer(buffer))
              .toList(),
        );
  }

  @override
  Future<Uint8List> read() {
    return GattCharacteristicApi.instance.read(hashCode);
  }

  @override
  Future<void> write(Uint8List value, {bool withoutResponse = false}) {
    return GattCharacteristicApi.instance.write(
      hashCode,
      value,
      withoutResponse,
    );
  }
}

class MyGattDescriptor extends GattDescriptor {
  @override
  final UUID uuid;

  MyGattDescriptor({required this.uuid, required int instanceId}) {
    GattDescriptorApi.instance.allocate(hashCode, instanceId);
    finalizer.attach(
      this,
      () => GattDescriptorApi.instance.free(hashCode),
    );
  }

  factory MyGattDescriptor.fromBuffer(Uint8List buffer) {
    final descriptor = proto.GattDescriptor.fromBuffer(buffer);
    final uuid = MyUUID.fromProto(descriptor.uuid);
    return MyGattDescriptor(
      uuid: uuid,
      instanceId: descriptor.id.toInt(),
    );
  }

  @override
  Future<Uint8List> read() {
    return GattDescriptorApi.instance.read(hashCode);
  }

  @override
  Future<void> write(Uint8List value) {
    return GattDescriptorApi.instance.write(hashCode, value);
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

  factory MyUUID.fromBuffer(Uint8List buffer) {
    final uuid = proto.UUID.fromBuffer(buffer);
    return MyUUID.fromProto(uuid);
  }

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
