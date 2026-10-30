import 'dart:typed_data';

/// An open L2CAP Connection-oriented Channel (CoC) to a peripheral.
///
/// Obtained from [CentralManager.openL2CAPChannel]. Exposes the inbound byte
/// [stream] and a [write] sink over the channel's reliable, flow-controlled
/// transport. The channel reuses the peripheral's existing (authenticated)
/// connection rather than opening a new one.
abstract interface class L2CAPChannel {
  /// The protocol/service multiplexer (PSM) this channel was opened on.
  int get psm;

  /// Inbound bytes received over the channel.
  ///
  /// The stream closes when the peer closes the channel - for a data transfer
  /// this is the signal that the transfer completed.
  Stream<Uint8List> get stream;

  /// Writes [value] to the channel.
  ///
  /// Resolves once the bytes are handed to the transport, respecting the
  /// channel's credit-based flow control.
  Future<void> write(Uint8List value);

  /// Closes the channel and releases native resources.
  Future<void> close();
}
