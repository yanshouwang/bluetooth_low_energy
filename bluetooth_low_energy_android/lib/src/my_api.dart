import 'my_api.g.dart';
import 'my_central_controller_api.dart';

final myInstanceManagerApi = MyInstanceManagerHostApi();
final myCentralControllerApi = MyCentralControllerApi();
final myPeripheralApi = MyPeripheralHostApi();
final myAdvertisementApi = MyAdvertisementHostApi();
final myGattServiceApi = MyGattServiceHostApi();
final myGattCharacteristicApi = MyGattCharacteristicHostApi();
final myGattDescriptorApi = MyGattDescriptorHostApi();

void setupMyApi() {
  MyCentralControllerFlutterApi.setup(myCentralControllerApi);
}
