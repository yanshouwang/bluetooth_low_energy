// import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

// import 'my_api.dart';
// import 'my_api.g.dart';

// final class MyGATTDescriptor extends GATTDescriptor {
//   final String addressArgs;
//   final int hashCodeArgs;

//   MyGATTDescriptor({
//     required this.addressArgs,
//     required this.hashCodeArgs,
//     required super.uuid,
//   });

//   factory MyGATTDescriptor.fromArgs({
//     required String addressArgs,
//     required MyGATTDescriptorArgs descriptorArgs,
//   }) {
//     return MyGATTDescriptor(
//       addressArgs: addressArgs,
//       hashCodeArgs: descriptorArgs.hashCodeArgs,
//       uuid: UUID.fromString(descriptorArgs.uuidArgs),
//     );
//   }

//   @override
//   int get hashCode => Object.hash(addressArgs, hashCodeArgs);

//   @override
//   bool operator ==(Object other) {
//     return other is MyGATTDescriptor &&
//         other.addressArgs == addressArgs &&
//         other.hashCodeArgs == hashCodeArgs;
//   }
// }

// final class MyGATTCharacteristic extends GATTCharacteristic {
//   final String addressArgs;
//   final int hashCodeArgs;

//   MyGATTCharacteristic({
//     required this.addressArgs,
//     required this.hashCodeArgs,
//     required super.uuid,
//     required super.properties,
//     required List<MyGATTDescriptor> descriptors,
//   }) : super(
//           descriptors: descriptors,
//         );

//   factory MyGATTCharacteristic.fromArgs({
//     required String addressArgs,
//     required MyGATTCharacteristicArgs characteristicArgs,
//   }) {
//     return MyGATTCharacteristic(
//       addressArgs: addressArgs,
//       hashCodeArgs: characteristicArgs.hashCodeArgs,
//       uuid: UUID.fromString(characteristicArgs.uuidArgs),
//       properties: characteristicArgs.propertyNumbersArgs
//           .cast<int>()
//           .map((propertyNumberArgs) {
//         final propertyArgs =
//             MyGATTCharacteristicPropertyArgs.values[propertyNumberArgs];
//         return propertyArgs.toProperty();
//       }).toList(),
//       descriptors: characteristicArgs.descriptorsArgs
//           .cast<MyGATTDescriptorArgs>()
//           .map((descriptorArgs) => MyGATTDescriptor.fromArgs(
//                 addressArgs: addressArgs,
//                 descriptorArgs: descriptorArgs,
//               ))
//           .toList(),
//     );
//   }

//   @override
//   List<MyGATTDescriptor> get descriptors =>
//       super.descriptors.cast<MyGATTDescriptor>();

//   @override
//   int get hashCode => Object.hash(addressArgs, hashCodeArgs);

//   @override
//   bool operator ==(Object other) {
//     return other is MyGATTCharacteristic &&
//         other.addressArgs == addressArgs &&
//         other.hashCodeArgs == hashCodeArgs;
//   }
// }

// final class MyGATTService extends GATTService {
//   final String addressArgs;
//   final int hashCodeArgs;

//   MyGATTService({
//     required this.addressArgs,
//     required this.hashCodeArgs,
//     required super.uuid,
//     required super.isPrimary,
//     required List<MyGATTService> includedServices,
//     required List<MyGATTCharacteristic> characteristics,
//   }) : super(
//           includedServices: includedServices,
//           characteristics: characteristics,
//         );

//   factory MyGATTService.fromArgs({
//     required String addressArgs,
//     required MyGATTServiceArgs serviceArgs,
//   }) {
//     return MyGATTService(
//       addressArgs: addressArgs,
//       hashCodeArgs: serviceArgs.hashCodeArgs,
//       uuid: UUID.fromString(serviceArgs.uuidArgs),
//       isPrimary: serviceArgs.isPrimaryArgs,
//       includedServices: serviceArgs.includedServicesArgs
//           .cast<MyGATTServiceArgs>()
//           .map((includedServiceArgs) => MyGATTService.fromArgs(
//                 addressArgs: addressArgs,
//                 serviceArgs: includedServiceArgs,
//               ))
//           .toList(),
//       characteristics: serviceArgs.characteristicsArgs
//           .cast<MyGATTCharacteristicArgs>()
//           .map((characteristicArgs) => MyGATTCharacteristic.fromArgs(
//                 addressArgs: addressArgs,
//                 characteristicArgs: characteristicArgs,
//               ))
//           .toList(),
//     );
//   }

//   @override
//   List<MyGATTCharacteristic> get characteristics =>
//       super.characteristics.cast<MyGATTCharacteristic>();

//   @override
//   int get hashCode => Object.hash(addressArgs, hashCodeArgs);

//   @override
//   bool operator ==(Object other) {
//     return other is MyGATTService &&
//         other.addressArgs == addressArgs &&
//         other.hashCodeArgs == hashCodeArgs;
//   }
// }

// final class MyGATTReadRequest extends GATTReadRequest {
//   final String addressArgs;
//   final int idArgs;

//   MyGATTReadRequest({
//     required this.addressArgs,
//     required this.idArgs,
//     required super.offset,
//   });
// }

// final class MyGATTWriteRequest extends GATTWriteRequest {
//   final String addressArgs;
//   final int idArgs;
//   final bool responseNeededArgs;

//   MyGATTWriteRequest({
//     required this.addressArgs,
//     required this.idArgs,
//     required this.responseNeededArgs,
//     required super.offset,
//     required super.value,
//   });
// }
