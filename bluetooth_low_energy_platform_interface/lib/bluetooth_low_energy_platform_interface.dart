/// A common platform interface for the [`bluetooth_low_energy`][1] plugin.
///
/// This interface allows platform-specific implementations of the `bluetooth_low_energy`
/// plugin, as well as the plugin itself, to ensure they are supporting the
/// same interface.
///
/// [1]: https://pub.dev/packages/bluetooth_low_energy
library;

export 'src/advertisement.dart';
export 'src/bluetooth_low_energy_manager.dart';
export 'src/bluetooth_low_energy_peer.dart';
export 'src/bluetooth_low_energy_plugin.dart';
export 'src/bluetooth_low_energy_state.dart';
export 'src/central_manager.dart';
export 'src/central.dart';
export 'src/connection_priority.dart';
export 'src/connection_state.dart';
export 'src/event_args.dart';
export 'src/gatt.dart';
export 'src/manufacturer_specific_data.dart';
export 'src/peripheral_manager.dart';
export 'src/peripheral.dart';
export 'src/uuid.dart';
