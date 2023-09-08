// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum MyCentralStateArgs {
  unknown,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum MyGattCharacteristicPropertyArgs {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum MyGattCharacteristicWriteTypeArgs {
  withResponse,
  withoutResponse,
}

class MyCentralControllerArgs {
  MyCentralControllerArgs({
    required this.myStateNumber,
  });

  int myStateNumber;

  Object encode() {
    return <Object?>[
      myStateNumber,
    ];
  }

  static MyCentralControllerArgs decode(Object result) {
    result as List<Object?>;
    return MyCentralControllerArgs(
      myStateNumber: result[0]! as int,
    );
  }
}

class MyPeripheralArgs {
  MyPeripheralArgs({
    required this.key,
    required this.uuid,
  });

  int key;

  String uuid;

  Object encode() {
    return <Object?>[
      key,
      uuid,
    ];
  }

  static MyPeripheralArgs decode(Object result) {
    result as List<Object?>;
    return MyPeripheralArgs(
      key: result[0]! as int,
      uuid: result[1]! as String,
    );
  }
}

class MyAdvertisementArgs {
  MyAdvertisementArgs({
    this.name,
    required this.manufacturerSpecificData,
    required this.serviceUUIDs,
    required this.serviceData,
  });

  String? name;

  Map<int?, Uint8List?> manufacturerSpecificData;

  List<String?> serviceUUIDs;

  Map<String?, Uint8List?> serviceData;

  Object encode() {
    return <Object?>[
      name,
      manufacturerSpecificData,
      serviceUUIDs,
      serviceData,
    ];
  }

  static MyAdvertisementArgs decode(Object result) {
    result as List<Object?>;
    return MyAdvertisementArgs(
      name: result[0] as String?,
      manufacturerSpecificData: (result[1] as Map<Object?, Object?>?)!.cast<int?, Uint8List?>(),
      serviceUUIDs: (result[2] as List<Object?>?)!.cast<String?>(),
      serviceData: (result[3] as Map<Object?, Object?>?)!.cast<String?, Uint8List?>(),
    );
  }
}

class MyGattServiceArgs {
  MyGattServiceArgs({
    required this.key,
    required this.uuid,
  });

  int key;

  String uuid;

  Object encode() {
    return <Object?>[
      key,
      uuid,
    ];
  }

  static MyGattServiceArgs decode(Object result) {
    result as List<Object?>;
    return MyGattServiceArgs(
      key: result[0]! as int,
      uuid: result[1]! as String,
    );
  }
}

class MyGattCharacteristicArgs {
  MyGattCharacteristicArgs({
    required this.key,
    required this.uuid,
    required this.myPropertyNumbers,
  });

  int key;

  String uuid;

  List<int?> myPropertyNumbers;

  Object encode() {
    return <Object?>[
      key,
      uuid,
      myPropertyNumbers,
    ];
  }

  static MyGattCharacteristicArgs decode(Object result) {
    result as List<Object?>;
    return MyGattCharacteristicArgs(
      key: result[0]! as int,
      uuid: result[1]! as String,
      myPropertyNumbers: (result[2] as List<Object?>?)!.cast<int?>(),
    );
  }
}

class MyGattDescriptorArgs {
  MyGattDescriptorArgs({
    required this.key,
    required this.uuid,
  });

  int key;

  String uuid;

  Object encode() {
    return <Object?>[
      key,
      uuid,
    ];
  }

  static MyGattDescriptorArgs decode(Object result) {
    result as List<Object?>;
    return MyGattDescriptorArgs(
      key: result[0]! as int,
      uuid: result[1]! as String,
    );
  }
}

class _MyCentralControllerHostApiCodec extends StandardMessageCodec {
  const _MyCentralControllerHostApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is MyCentralControllerArgs) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MyGattCharacteristicArgs) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is MyGattDescriptorArgs) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is MyGattServiceArgs) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return MyCentralControllerArgs.decode(readValue(buffer)!);
      case 129: 
        return MyGattCharacteristicArgs.decode(readValue(buffer)!);
      case 130: 
        return MyGattDescriptorArgs.decode(readValue(buffer)!);
      case 131: 
        return MyGattServiceArgs.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class MyCentralControllerHostApi {
  /// Constructor for [MyCentralControllerHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MyCentralControllerHostApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MyCentralControllerHostApiCodec();

  Future<MyCentralControllerArgs> setUp() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.setUp', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as MyCentralControllerArgs?)!;
    }
  }

  Future<void> tearDown() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.tearDown', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> startDiscovery() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.startDiscovery', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> stopDiscovery() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.stopDiscovery', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> connect(int arg_myPeripheralKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.connect', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> disconnect(int arg_myPeripheralKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.disconnect', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int> getMaximumWriteLength(int arg_myPeripheralKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getMaximumWriteLength', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as int?)!;
    }
  }

  Future<void> discoverGATT(int arg_myPeripheralKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.discoverGATT', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<List<MyGattServiceArgs?>> getServices(int arg_myPeripheralKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getServices', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<MyGattServiceArgs?>();
    }
  }

  Future<List<MyGattCharacteristicArgs?>> getCharacteristics(int arg_myServiceKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getCharacteristics', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myServiceKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<MyGattCharacteristicArgs?>();
    }
  }

  Future<List<MyGattDescriptorArgs?>> getDescriptors(int arg_myCharacteristicKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.getDescriptors', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myCharacteristicKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<MyGattDescriptorArgs?>();
    }
  }

  Future<Uint8List> readCharacteristic(int arg_myPeripheralKey, int arg_myServiceKey, int arg_myCharacteristicKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.readCharacteristic', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey, arg_myServiceKey, arg_myCharacteristicKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as Uint8List?)!;
    }
  }

  Future<void> writeCharacteristic(int arg_myPeripheralKey, int arg_myServiceKey, int arg_myCharacteristicKey, Uint8List arg_value, int arg_myTypeNumber) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.writeCharacteristic', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey, arg_myServiceKey, arg_myCharacteristicKey, arg_value, arg_myTypeNumber]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> notifyCharacteristic(int arg_myPeripheralKey, int arg_myServiceKey, int arg_myCharacteristicKey, bool arg_state) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.notifyCharacteristic', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey, arg_myServiceKey, arg_myCharacteristicKey, arg_state]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<Uint8List> readDescriptor(int arg_myPeripheralKey, int arg_myCharacteristicKey, int arg_myDescriptorKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.readDescriptor', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey, arg_myCharacteristicKey, arg_myDescriptorKey]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as Uint8List?)!;
    }
  }

  Future<void> writeDescriptor(int arg_myPeripheralKey, int arg_myCharacteristicKey, int arg_myDescriptorKey, Uint8List arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerHostApi.writeDescriptor', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_myPeripheralKey, arg_myCharacteristicKey, arg_myDescriptorKey, arg_value]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }
}

class _MyCentralControllerFlutterApiCodec extends StandardMessageCodec {
  const _MyCentralControllerFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is MyAdvertisementArgs) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MyPeripheralArgs) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return MyAdvertisementArgs.decode(readValue(buffer)!);
      case 129: 
        return MyPeripheralArgs.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class MyCentralControllerFlutterApi {
  static const MessageCodec<Object?> codec = _MyCentralControllerFlutterApiCodec();

  void onStateChanged(int myStateNumber);

  void onDiscovered(MyPeripheralArgs myPeripheralArgs, int rssi, MyAdvertisementArgs myAdvertisementArgs);

  void onPeripheralStateChanged(int myPeripheralKey, bool state);

  void onCharacteristicValueChanged(int myCharacteristicKey, Uint8List value);

  static void setup(MyCentralControllerFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onStateChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onStateChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_myStateNumber = (args[0] as int?);
          assert(arg_myStateNumber != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onStateChanged was null, expected non-null int.');
          api.onStateChanged(arg_myStateNumber!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MyPeripheralArgs? arg_myPeripheralArgs = (args[0] as MyPeripheralArgs?);
          assert(arg_myPeripheralArgs != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered was null, expected non-null MyPeripheralArgs.');
          final int? arg_rssi = (args[1] as int?);
          assert(arg_rssi != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered was null, expected non-null int.');
          final MyAdvertisementArgs? arg_myAdvertisementArgs = (args[2] as MyAdvertisementArgs?);
          assert(arg_myAdvertisementArgs != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onDiscovered was null, expected non-null MyAdvertisementArgs.');
          api.onDiscovered(arg_myPeripheralArgs!, arg_rssi!, arg_myAdvertisementArgs!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onPeripheralStateChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onPeripheralStateChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_myPeripheralKey = (args[0] as int?);
          assert(arg_myPeripheralKey != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onPeripheralStateChanged was null, expected non-null int.');
          final bool? arg_state = (args[1] as bool?);
          assert(arg_state != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onPeripheralStateChanged was null, expected non-null bool.');
          api.onPeripheralStateChanged(arg_myPeripheralKey!, arg_state!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onCharacteristicValueChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onCharacteristicValueChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_myCharacteristicKey = (args[0] as int?);
          assert(arg_myCharacteristicKey != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onCharacteristicValueChanged was null, expected non-null int.');
          final Uint8List? arg_value = (args[1] as Uint8List?);
          assert(arg_value != null,
              'Argument for dev.flutter.pigeon.bluetooth_low_energy_darwin.MyCentralControllerFlutterApi.onCharacteristicValueChanged was null, expected non-null Uint8List.');
          api.onCharacteristicValueChanged(arg_myCharacteristicKey!, arg_value!);
          return;
        });
      }
    }
  }
}
