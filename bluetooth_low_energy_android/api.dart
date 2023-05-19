import 'package:pigeon/pigeon.dart';

@HostApi(dartHostTestHandler: 'TestCentralManagerHostApi')
abstract class CentralManagerHostApi {
  void initialize();
  @async
  void startScan();
  void stopScan();
  @async
  void connect(String id);
  void disconnect(String id);
  @async
  GattServiceArgs discoverService(String id, String serviceId);
  @async
  Uint8List read(
    String id,
    String serviceId,
    String characteristicId,
  );
  @async
  void write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value,
    GattCharacteristicWriteTypeArgs typeArgs,
  );
  @async
  void notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  );
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  void onStateChanged(CentralManagerStateEventArgs eventArgs);
  void onScanned(PeripheralEventArgs eventArgs);
  void onPeripheralStateChanged(PeripheralStateEventArgs eventArgs);
  void onCharacteristicValueChanged(GattCharacteristicValueEventArgs eventArgs);
}

class CentralManagerArgs {
  final CentralManagerStateArgs stateArgs;

  CentralManagerArgs({
    required this.stateArgs,
  });
}

class PeripheralArgs {
  final String id;
  final String name;
  final int rssi;
  final Uint8List? manufacturerSpecificData;

  PeripheralArgs({
    required this.id,
    required this.name,
    required this.rssi,
    required this.manufacturerSpecificData,
  });
}

class GattServiceArgs {
  final String id;
  final List<GattCharacteristicArgs?> characteristicArgs;

  GattServiceArgs({
    required this.id,
    required this.characteristicArgs,
  });
}

class GattCharacteristicArgs {
  final String id;
  final bool canRead;
  final bool canWrite;
  final bool canWriteWithoutResponse;
  final bool canNotify;
  final List<GattDescriptorArgs?> descriptorArgs;

  const GattCharacteristicArgs({
    required this.id,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required this.descriptorArgs,
  });
}

class GattDescriptorArgs {
  final String id;

  const GattDescriptorArgs({
    required this.id,
  });
}

class CentralManagerStateEventArgs {
  final CentralManagerStateArgs stateArgs;

  CentralManagerStateEventArgs({
    required this.stateArgs,
  });
}

class PeripheralEventArgs {
  final PeripheralArgs peripheralArgs;

  PeripheralEventArgs({
    required this.peripheralArgs,
  });
}

class PeripheralStateEventArgs {
  final String id;
  final PeripheralStateArgs stateArgs;

  PeripheralStateEventArgs({
    required this.id,
    required this.stateArgs,
  });
}

class GattCharacteristicValueEventArgs {
  final String id;
  final String serviceId;
  final String characteristicId;
  final Uint8List value;

  GattCharacteristicValueEventArgs({
    required this.id,
    required this.serviceId,
    required this.characteristicId,
    required this.value,
  });
}

enum CentralManagerStateArgs {
  unknown,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum PeripheralStateArgs {
  disconnected,
  connecting,
  connected,
}

enum GattCharacteristicWriteTypeArgs {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}
