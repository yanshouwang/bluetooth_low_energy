import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';

export 'my_api.g.dart';

extension MyBluetoothLowEnergyStateArgsX on MyBluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    return BluetoothLowEnergyState.values[index];
  }
}

extension MyAdvertisementArgsX on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    final name = nameArgs;
    final manufacturerSpecificData =
        manufacturerSpecificDataArgs.cast<int, Uint8List>();
    final serviceUUIDs = serviceUUIDsArgs
        .cast<String>()
        .map((args) => UUID.fromString(args))
        .toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = UUID.fromString(uuidArgs);
        final data = dataArgs;
        return MapEntry(uuid, data);
      },
    );
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
    );
  }
}

extension MyGattCharacteristicPropertyArgsX
    on MyGattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}

extension MyPeripheralArgsX on MyPeripheralArgs {
  Peripheral toPeripheral() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyPeripheral(
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension MyGattServiceArgsX on MyGattServiceArgs {
  MyGattService2 toService2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    final characteristics = characteristicsArgs
        .cast<MyGattCharacteristicArgs>()
        .map((args) => args.toCharacteristic2())
        .toList();
    return MyGattService2(
      hashCode: hashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension MyGattCharacteristicArgsX on MyGattCharacteristicArgs {
  MyGattCharacteristic2 toCharacteristic2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = MyGattCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<MyGattDescriptorArgs>()
        .map((args) => args.toDescriptor2())
        .toList();
    return MyGattCharacteristic2(
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension MyGattDescriptorArgsX on MyGattDescriptorArgs {
  MyGattDescriptor2 toDescriptor2() {
    final hashCode = hashCodeArgs;
    final uuid = UUID.fromString(uuidArgs);
    return MyGattDescriptor2(
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

// extension MyCentralArgsX on MyCentralArgs {
//   MyCentral toMyCentral() {
//     final hashCode = myKey;
//     final uuid = UUID.fromString(myUUID);
//     return MyCentral(
//       hashCode: hashCode,
//       uuid: uuid,
//     );
//   }
// }

// extension AdvertisementX on Advertisement {
//   MyAdvertisementArgs toMyArgs() {
//     final myName = name;
//     final myManufacturerSpecificData = manufacturerSpecificData;
//     final myServiceUUIDs = serviceUUIDs
//         .map(
//           (uuid) => uuid.toString(),
//         )
//         .toList();
//     final myServiceData = serviceData.map(
//       (uuid, data) {
//         final uuidValue = uuid.toString();
//         return MapEntry(uuidValue, data);
//       },
//     );
//     return MyAdvertisementArgs(
//       myName: myName,
//       myManufacturerSpecificData: myManufacturerSpecificData,
//       myServiceUUIDs: myServiceUUIDs,
//       myServiceData: myServiceData,
//     );
//   }
// }

// extension MyGattServiceX on MyGattService {
//   MyGattServiceArgs toMyArgs() {
//     final myKey = hashCode;
//     final myUUID = uuid.toString();
//     final myCharacteristicArgses = characteristics
//         .cast<MyGattCharacteristic>()
//         .map((myCharacteristic) => myCharacteristic.toMyArgs())
//         .toList();
//     return MyGattServiceArgs(
//       myKey: myKey,
//       myUUID: myUUID,
//       myCharacteristicArgses: myCharacteristicArgses,
//     );
//   }
// }

// extension MyGattCharacteristicX on MyGattCharacteristic {
//   MyGattCharacteristicArgs toMyArgs() {
//     final myKey = hashCode;
//     final myUUID = uuid.toString();
//     final myPropertyNumbers = properties.map((property) {
//       final myPropertyArgs = property.toMyArgs();
//       return myPropertyArgs.index;
//     }).toList();
//     final myDescriptorArgses = descriptors
//         .cast<MyGattDescriptor>()
//         .map((myDescriptor) => myDescriptor.toMyArgs())
//         .toList();
//     return MyGattCharacteristicArgs(
//       myKey: myKey,
//       myUUID: myUUID,
//       myPropertyNumbers: myPropertyNumbers,
//       myDescriptorArgses: myDescriptorArgses,
//     );
//   }
// }

// extension MyGattDescriptorX on MyGattDescriptor {
//   MyGattDescriptorArgs toMyArgs() {
//     final myKey = hashCode;
//     final myUUID = uuid.toString();
//     final myValue = value;
//     return MyGattDescriptorArgs(
//       myKey: myKey,
//       myUUID: myUUID,
//       myValue: myValue,
//     );
//   }
// }

// extension GattCharacteristicPropertyX on GattCharacteristicProperty {
//   MyGattCharacteristicPropertyArgs toMyArgs() {
//     return MyGattCharacteristicPropertyArgs.values[index];
//   }
// }
