import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyCentralControllerStateChangedEventArgs
    extends CentralControllerStateChangedEventArgs {
  final CentralController controller;

  MyCentralControllerStateChangedEventArgs(
    this.controller,
    super.state,
  );
}

class MyCentralControllerDiscoveredEventArgs
    extends CentralControllerDiscoveredEventArgs {
  final CentralController controller;
  MyCentralControllerDiscoveredEventArgs(
    this.controller,
    super.peripheral,
    super.rssi,
    super.advertisement,
  );
}

class MyPeripheralStateChangedEventArgs
    extends PeripheralStateChangedEventArgs {
  final CentralController controller;
  MyPeripheralStateChangedEventArgs(
    this.controller,
    super.peripheral,
    super.state,
  );
}

class MyGattCharacteristicValueChangedEventArgs
    extends GattCharacteristicValueChangedEventArgs {
  final CentralController controller;
  MyGattCharacteristicValueChangedEventArgs(
    this.controller,
    super.characteristic,
    super.value,
  );
}
