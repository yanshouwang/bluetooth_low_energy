import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:clover/clover.dart';

import 'characteristic_view_model.dart';

class ServiceViewModel extends ViewModel {
  final GATTService _service;

  final List<ServiceViewModel> _includedServiceViewModels;
  final List<CharacteristicViewModel> _characteristicViewModels;

  ServiceViewModel({
    required CentralManager manager,
    required Peripheral peripheral,
    required GATTService service,
  })  : _service = service,
        _includedServiceViewModels = service.includedServices
            .map((service) => ServiceViewModel(
                  manager: manager,
                  peripheral: peripheral,
                  service: service,
                ))
            .toList(),
        _characteristicViewModels = service.characteristics
            .map((characteristic) => CharacteristicViewModel(
                  manager: manager,
                  peripheral: peripheral,
                  characteristic: characteristic,
                ))
            .toList();

  UUID get uuid => _service.uuid;
  bool get isPrimary => _service.isPrimary;
  List<ServiceViewModel> get includedServiceViewModels =>
      _includedServiceViewModels;
  List<CharacteristicViewModel> get characteristicViewModels =>
      _characteristicViewModels;

  @override
  void dispose() {
    for (var characteristicViewModel in characteristicViewModels) {
      characteristicViewModel.dispose();
    }
    super.dispose();
  }
}
