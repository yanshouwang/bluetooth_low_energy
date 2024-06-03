import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

import 'view_model.dart';

class DescriptorViewModel extends ViewModel {
  final GATTDescriptor _descriptor;

  DescriptorViewModel(this._descriptor);

  UUID get uuid => _descriptor.uuid;
}
