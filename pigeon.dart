import 'package:pigeon/pigeon.dart';

class Peripheral {
  final String macAddress;
  final String name;

  Peripheral({
    required this.macAddress,
    required this.name,
  });
}

@HostApi(dartHostTestHandler: "TestCentralManagerHostApi")
abstract class CentralManagerHostApi {
  void startScan();

  void stopScan();

  void connect(String macAddress);

  void disconnect(String macAddress);

  void write(
    String macAddress,
    String serviceId,
    String characteristicId,
    Uint8List value,
  );

  void read(
    String macAddress,
    String serviceId,
    String characteristicId,
  );

  void notify(
    String macAddress,
    String serviceId,
    String characteristicId,
    bool value,
  );
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  void onScanned(Peripheral peripheral);

  void onStateChanged(String macAddress);

  void onNotified(
    String macAddress,
    String serviceId,
    String characteristicId,
    Uint8List value,
  );
}
