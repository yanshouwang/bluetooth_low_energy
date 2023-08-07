import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_object.dart';

class MyAdvertisement extends MyObject implements Advertisement {
  MyAdvertisement(super.hashCode);

  @override
  Future<String?> getName() {
    return myAdvertisementApi.getName(hashCode);
  }

  @override
  Future<Uint8List?> getManufacturerSpecificData() {
    return myAdvertisementApi.getManufacturerSpecificData(hashCode);
  }
}
