/// A common platform interface for the [`bluetooth_low_energy`][1] plugin.
///
/// This interface allows platform-specific implementations of the `bluetooth_low_energy`
/// plugin, as well as the plugin itself, to ensure they are supporting the
/// same interface.
///
/// [1]: https://pub.dev/packages/bluetooth_low_energy
library;

export 'package:log_service/log_service.dart';

export 'src/event_args.dart';
export 'src/bluetooth_low_energy_state.dart';
export 'src/bluetooth_low_energy_event_args.dart';
export 'src/bluetooth_low_energy_manager.dart';
export 'src/bluetooth_low_energy_peer.dart';
export 'src/central_manager_event_args.dart';
export 'src/central_manager.dart';
export 'src/central.dart';
export 'src/peripheral_manager_event_args.dart';
export 'src/peripheral_manager.dart';
export 'src/peripheral.dart';
export 'src/uuid.dart';
export 'src/advertisement.dart';
export 'src/manufacturer_specific_data.dart';
export 'src/gatt_service.dart';
export 'src/gatt_characteristic.dart';
export 'src/gatt_characteristic_property.dart';
export 'src/gatt_characteristic_write_type.dart';
export 'src/gatt_descriptor.dart';
export 'src/my_central_manager.dart';
export 'src/my_peripheral_manager.dart';
export 'src/my_bluetooth_low_energy_peer.dart';
export 'src/my_central.dart';
export 'src/my_peripheral.dart';
export 'src/my_gatt_attribute.dart';
export 'src/my_gatt_service.dart';
export 'src/my_gatt_characteristic.dart';
export 'src/my_gatt_descriptor.dart';
