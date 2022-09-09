import 'dart:async';
import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import 'advertisement.dart';
import 'central_controller.dart';
import 'central_controller_api.dart';
import 'gatt_service.dart';
import 'peripheral.dart';
import 'pigeon.dart';
import 'proto.dart' as proto;
import 'uuid.dart';

class MyCentralControllerApi extends CentralControllerApi
    implements CentralControllerFlutterApi {
  final hostApi = CentralControllerHostApi();
  final stateStreamController =
      StreamController<Tuple2<String, int>>.broadcast();
  final advertisementStreamController =
      StreamController<Tuple2<String, Uint8List>>.broadcast();

  @override
  Stream<Tuple2<String, int>> get stateStream => stateStreamController.stream;

  @override
  Stream<Tuple2<String, Uint8List>> get advertisementStream =>
      advertisementStreamController.stream;

  @override
  Future<void> addStateObserver(String id) {
    return hostApi.addStateObserver(id);
  }

  @override
  Future<void> create(String id) {
    return hostApi.create(id);
  }

  @override
  Future<void> destory(String id) {
    return hostApi.destroy(id);
  }

  @override
  Future<int> getState(String id) {
    return hostApi.getState(id);
  }

  @override
  Future<void> removeStateObserver(String id) {
    return hostApi.removeStateObserver(id);
  }

  @override
  Future<void> startDiscovery(String id, List<String>? uuids) {
    return hostApi.startDiscovery(id, uuids);
  }

  @override
  Future<void> stopDiscovery(String id) {
    return hostApi.stopDiscovery(id);
  }

  @override
  void notifyState(String id, int state) {
    stateStreamController.add(Tuple2(id, state));
  }

  @override
  void notifyAdvertisement(String id, Uint8List advertisement) {
    advertisementStreamController.add(Tuple2(id, advertisement));
  }
}

class MyCentralController implements CentralController {
  MyCentralController() {
    CentralControllerApi.instance.create(id);
  }

  @override
  Stream<Advertisement> buildAdvertisementStream({List<UUID>? uuids}) {
    late StreamController<Advertisement> controller;
    final subscription = CentralControllerApi.instance.advertisementStream
        .where((event) => event.item1 == id)
        .map((event) {
      final advertisement = proto.Advertisement.fromBuffer(event.item2);
      return MyAdvertisement(advertisement);
    }).listen((event) {
      controller.add(event);
    });
    controller = StreamController<Advertisement>(
      onListen: () {
        CentralControllerApi.instance.startDiscovery(
          id,
          uuids?.map((e) => e.toString()).toList(),
        );
      },
      onCancel: () {
        subscription.cancel();
        CentralControllerApi.instance.stopDiscovery(id);
      },
    );
  }

  @override
  void dispose() {
    CentralControllerApi.instance.destory(id);
  }

  @override
  Future<BluetoothState> getState() {
    // TODO: implement getState
    throw UnimplementedError();
  }

  @override
  // TODO: implement stateStream
  Stream<BluetoothState> get stateStream => throw UnimplementedError();
}

class MyAdvertisement implements Advertisement {
  @override
  final Peripheral peripheral;
  @override
  final Map<int, Uint8List> data;
  @override
  final int rssi;

  MyAdvertisement(proto.Advertisement advertisement)
      : peripheral = MyPeripheral(advertisement.peripheral),
        data = advertisement.data.cast(),
        rssi = advertisement.rssi;
}

class MyPeripheral implements Peripheral {
  @override
  final UUID uuid;
  @override
  final bool connectable;

  MyPeripheral(proto.Peripheral peripheral)
      : uuid = MyUUID(peripheral.uuid),
        connectable = peripheral.connectable;

  @override
  Future<int> connect(Function(Exception error) onConnectionLost) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<GattService>> discoverServices() {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  // TODO: implement services
  List<GattService> get services => throw UnimplementedError();
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
