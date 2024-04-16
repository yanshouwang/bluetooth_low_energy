import 'event_args.dart';
import 'peripheral.dart';

/// The connection state cahnged event arguments.
base class ConnectionStateChangedEventArgs extends EventArgs {
  /// The peripheral which connection state changed.
  final Peripheral peripheral;

  /// The connection state.
  final bool connectionState;

  /// Constructs a [ConnectionStateChangedEventArgs].
  ConnectionStateChangedEventArgs(
    this.peripheral,
    this.connectionState,
  );
}
