import 'advertisement.dart';
import 'event_args.dart';
import 'peripheral.dart';

/// The discovered event arguments.
base class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}
