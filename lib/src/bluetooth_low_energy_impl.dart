import 'dart:async';
import 'dart:typed_data';

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

class MyCentralManagerApi extends CentralManagerApi
    implements CentralManagerFlutterApi {
  final hostApi = CentralManagerHostApi();
  final stateStreamController = StreamController<Uint8List>.broadcast();
  final advertisementStreamController = StreamController<Uint8List>.broadcast();

  @override
  Stream<Uint8List> get stateStream => stateStreamController.stream;

  @override
  Stream<Uint8List> get advertisementStream =>
      advertisementStreamController.stream;

  @override
  Future<Uint8List> getState() {
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
  Future<void> startScan(List<String>? uuids) {
    return hostApi.startScan(uuids);
  }

  @override
  Future<void> stopScan() {
    return hostApi.stopScan();
  }

  @override
  Future<Uint8List> connect(String uuid) {
    return hostApi.connect(uuid);
  }

  @override
  void notifyState(Uint8List state) {
    stateStreamController.add(state);
  }

  @override
  void notifyAdvertisement(Uint8List advertisement) {
    advertisementStreamController.add(advertisement);
  }
}

class MyPeripheralApi extends PeripheralApi implements PeripheralFlutterApi {
  final hostApi = PeripheralHostApi();
  final connectionLostStreamController =
      StreamController<Tuple2<String, String>>.broadcast();

  @override
  Stream<Tuple2<String, String>> get connectionLostStream =>
      connectionLostStreamController.stream;

  @override
  Future<void> allocate(String newId, String oldId) {
    return hostApi.allocate(newId, oldId);
  }

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<void> disconnect(String id) {
    return hostApi.disconnect(id);
  }

  @override
  Future<List<Uint8List>> discoverServices(String id) {
    return hostApi.discoverServices(id).then((value) => value.cast());
  }

  @override
  void notifyConnectionLost(String id, String error) {
    final event = Tuple2(id, error);
    connectionLostStreamController.add(event);
  }
}

class MyGattServiceApi extends GattServiceApi {
  final hostApi = GattServiceHostApi();

  @override
  Future<void> allocate(String newId, String oldId) {
    return hostApi.allocate(newId, oldId);
  }

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverCharacteristics(String id) {
    return hostApi.discoverCharacteristics(id).then((value) => value.cast());
  }
}

class MyGattCharacteristicApi extends GattCharacteristicApi
    implements GattCharacteristicFlutterApi {
  final hostApi = GattCharacteristicHostApi();

  final valueStreamController =
      StreamController<Tuple2<String, Uint8List>>.broadcast();

  @override
  Stream<Tuple2<String, Uint8List>> get valueStream =>
      valueStreamController.stream;

  @override
  Future<void> allocate(String newId, String oldId) {
    return hostApi.allocate(newId, oldId);
  }

  @override
  Future<void> free(String id) {
    return hostApi.free(id);
  }

  @override
  Future<List<Uint8List>> discoverDescriptors(String id) {
    return hostApi.discoverDescriptors(id).then((value) => value.cast());
  }

  @override
  Future<Uint8List> read(String id) {
    return hostApi.read(id);
  }

  @override
  Future<void> write(String id, Uint8List value) {
    return hostApi.write(id, value);
  }

  @override
  Future<void> setNotify(String id, bool value) {
    return hostApi.setNotify(id, value);
  }

  @override
  void notifyValue(String id, Uint8List value) {
    final event = Tuple2(id, value);
    valueStreamController.add(event);
  }
}

class MyGattDescriptorApi extends GattDescriptorApi {
  final hostApi = GattDescriptorHostApi();

  @override
  Future<void> allocate(String newId, String oldId) {
    return hostApi.allocate(newId, oldId);
  }

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
  @override
  Stream<Advertisement> createAdvertisementStream({List<UUID>? uuids}) {
    return CentralManagerApi.instance.advertisementStream.map((event) {
      final advertisement = proto.Advertisement.fromBuffer(event);
      return MyAdvertisement(advertisement);
    }).asBroadcastStream(
      onListen: (subscription) {
        CentralManagerApi.instance.startScan(
          uuids?.map((e) => e.toString()).toList(),
        );
      },
      onCancel: (subscription) {
        subscription.cancel();
        CentralManagerApi.instance.stopScan();
      },
    );
  }

  @override
  Future<BluetoothState> getState() {
    return CentralManagerApi.instance.getState().then((value) {
      final number = proto.BluetoothState.fromBuffer(value).number;
      return BluetoothState.values[number];
    });
  }

  @override
  Stream<BluetoothState> get stateStream =>
      CentralManagerApi.instance.stateStream.map((event) {
        final number = proto.BluetoothState.fromBuffer(event).number;
        return BluetoothState.values[number];
      }).asBroadcastStream(
        onListen: (subscription) {
          CentralManagerApi.instance.addStateObserver();
        },
        onCancel: (subscription) {
          subscription.cancel();
          CentralManagerApi.instance.removeStateObserver();
        },
      );

  @override
  Future<Peripheral> connect(
    UUID uuid, {
    Function(Exception)? onConnectionLost,
  }) {
    return CentralManagerApi.instance.connect(uuid.toString()).then((value) {
      final peripheral = proto.Peripheral.fromBuffer(value);
      return MyPeripheral(peripheral, onConnectionLost);
    });
  }
}

class MyAdvertisement implements Advertisement {
  @override
  final UUID uuid;
  @override
  final Map<int, Uint8List> data;
  @override
  final int rssi;
  @override
  final bool connectable;

  MyAdvertisement(proto.Advertisement advertisement)
      : uuid = MyUUID(advertisement.uuid),
        data = advertisement.data.cast(),
        rssi = advertisement.rssi,
        connectable = advertisement.connectable;
}

class MyPeripheral implements Peripheral {
  late StreamSubscription<Tuple2<String, String>>
      connectionLostStreamSubscription;

  @override
  final int maximumWriteLength;

  MyPeripheral(
    proto.Peripheral peripheral,
    Function(Exception)? onConnectionLost,
  ) : maximumWriteLength = peripheral.maximumWriteLength {
    PeripheralApi.instance.allocate(id, peripheral.id);
    connectionLostStreamSubscription = PeripheralApi
        .instance.connectionLostStream
        .where((event) => event.item1 == id)
        .listen((event) {
      final error = Exception(event.item2);
      onConnectionLost?.call(error);
    });
    finalizer.attach(
      this,
      () {
        connectionLostStreamSubscription.cancel();
        PeripheralApi.instance.free(id);
      },
    );
  }

  @override
  Future<void> disconnect() {
    return PeripheralApi.instance.disconnect(id);
  }

  @override
  Future<List<GattService>> discoverServices() {
    return PeripheralApi.instance.discoverServices(id).then(
          (value) => value.map((e) {
            final service = proto.GattService.fromBuffer(e);
            return MyGattService(service);
          }).toList(),
        );
  }
}

class MyGattService extends GattService {
  MyGattService(proto.GattService service) {
    GattServiceApi.instance.allocate(id, service.id);
    finalizer.attach(
      this,
      () => GattServiceApi.instance.free(id),
    );
  }

  @override
  Future<List<GattCharacteristic>> discoverCharacteristics() {
    return GattServiceApi.instance.discoverCharacteristics(id).then(
          (value) => value.map((e) {
            final characteristic = proto.GattCharacteristic.fromBuffer(e);
            return MyGattCharacteristic(characteristic);
          }).toList(),
        );
  }
}

class MyGattCharacteristic extends GattCharacteristic {
  @override
  final bool canRead;
  @override
  final bool canWrite;
  @override
  final bool canWriteWithoutResponse;
  @override
  final bool canNotify;

  MyGattCharacteristic(proto.GattCharacteristic characteristic)
      : canRead = characteristic.canRead,
        canWrite = characteristic.canWrite,
        canWriteWithoutResponse = characteristic.canWriteWithoutResponse,
        canNotify = characteristic.canNotify {
    GattCharacteristicApi.instance.allocate(id, characteristic.id);
    finalizer.attach(
      this,
      () => GattCharacteristicApi.instance.free(id),
    );
  }

  @override
  Stream<Uint8List> get valueStream =>
      GattCharacteristicApi.instance.valueStream
          .where((event) => event.item1 == id)
          .map((event) => event.item2)
          .asBroadcastStream(
        onListen: (subscription) {
          GattCharacteristicApi.instance.setNotify(id, true);
        },
        onCancel: (subscription) {
          subscription.cancel();
          GattCharacteristicApi.instance.setNotify(id, false);
        },
      );

  @override
  Future<List<GattDescriptor>> discoverDescriptors() {
    return GattCharacteristicApi.instance.discoverDescriptors(id).then(
          (value) => value.map((e) {
            final descriptor = proto.GattDescriptor.fromBuffer(e);
            return MyGattDescriptor(descriptor);
          }).toList(),
        );
  }

  @override
  Future<Uint8List> read() {
    return GattCharacteristicApi.instance.read(id);
  }

  @override
  Future<void> write(Uint8List value) {
    return GattCharacteristicApi.instance.write(id, value);
  }
}

class MyGattDescriptor extends GattDescriptor {
  MyGattDescriptor(proto.GattDescriptor descriptor) {
    GattDescriptorApi.instance.allocate(id, descriptor.id);
    finalizer.attach(
      this,
      () => GattDescriptorApi.instance.free(id),
    );
  }

  @override
  Future<Uint8List> read() {
    return GattDescriptorApi.instance.read(id);
  }

  @override
  Future<void> write(Uint8List value) {
    return GattDescriptorApi.instance.write(id, value);
  }
}

class MyUUID implements UUID {
  final String value;

  MyUUID(this.value);

  @override
  String toString() {
    return value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyUUID && other.value == value;
  }
}

extension on Object {
  String get id => hashCode.toString();
}
