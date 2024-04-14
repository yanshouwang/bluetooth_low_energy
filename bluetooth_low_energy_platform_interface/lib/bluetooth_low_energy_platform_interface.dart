/// A common platform interface for the [`bluetooth_low_energy`][1] plugin.
///
/// This interface allows platform-specific implementations of the `bluetooth_low_energy`
/// plugin, as well as the plugin itself, to ensure they are supporting the
/// same interface.
///
/// [1]: https://pub.dev/packages/bluetooth_low_energy
library;

export 'src/common.dart';
export 'src/central_manager.dart';
export 'src/peripheral_manager.dart';
