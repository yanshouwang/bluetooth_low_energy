import 'package:flutter/material.dart';

import 'mac.dart';

abstract class GATT {
  MAC get address;
  Stream<Exception> get connectionLost;

  Future disconnect();

  factory GATT(MAC address) => _GATT(address);
}

class _GATT implements GATT {
  _GATT(this.address);

  @override
  final MAC address;

  @override
  // TODO: implement connectionLost
  Stream<Exception> get connectionLost => throw UnimplementedError();

  @override
  Future disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }
}
