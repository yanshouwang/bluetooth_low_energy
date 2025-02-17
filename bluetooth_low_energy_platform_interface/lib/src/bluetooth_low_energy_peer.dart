import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'uuid.dart';

/// An object that represents a remote device.
abstract base class BluetoothLowEnergyPeer extends PlatformInterface {
  static final _token = Object();

  /// The UUID associated with the peer.
  final UUID uuid;

  BluetoothLowEnergyPeer.impl({
    required this.uuid,
  }) : super(token: _token);

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BluetoothLowEnergyPeer && other.uuid == uuid;
  }
}
