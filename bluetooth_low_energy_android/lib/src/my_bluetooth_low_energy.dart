import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_central_controller.dart';

class MyCentralController extends CentralController {
  @override
  Future<void> initialize() async {
    setupMyApi();
  }
}
