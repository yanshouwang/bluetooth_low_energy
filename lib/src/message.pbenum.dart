///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MessageCategory extends $pb.ProtobufEnum {
  static const MessageCategory BLUETOOTH_AVAILABLE = MessageCategory._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'BLUETOOTH_AVAILABLE');
  static const MessageCategory BLUETOOTH_STATE = MessageCategory._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'BLUETOOTH_STATE');
  static const MessageCategory CENTRAL_START_DISCOVERY = MessageCategory._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'CENTRAL_START_DISCOVERY');
  static const MessageCategory CENTRAL_STOP_DISCOVERY = MessageCategory._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'CENTRAL_STOP_DISCOVERY');
  static const MessageCategory CENTRAL_DISCOVERED = MessageCategory._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'CENTRAL_DISCOVERED');
  static const MessageCategory CENTRAL_CONNECT = MessageCategory._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'CENTRAL_CONNECT');
  static const MessageCategory GATT_DISCONNECT = MessageCategory._(
      6,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_DISCONNECT');
  static const MessageCategory GATT_CONNECTION_LOST = MessageCategory._(
      7,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_CONNECTION_LOST');
  static const MessageCategory GATT_CHARACTERISTIC_READ = MessageCategory._(
      8,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_CHARACTERISTIC_READ');
  static const MessageCategory GATT_CHARACTERISTIC_WRITE = MessageCategory._(
      9,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_CHARACTERISTIC_WRITE');
  static const MessageCategory GATT_CHARACTERISTIC_NOTIFY = MessageCategory._(
      10,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_CHARACTERISTIC_NOTIFY');
  static const MessageCategory GATT_DESCRIPTOR_READ = MessageCategory._(
      11,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_DESCRIPTOR_READ');
  static const MessageCategory GATT_DESCRIPTOR_WRITE = MessageCategory._(
      12,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GATT_DESCRIPTOR_WRITE');

  static const $core.List<MessageCategory> values = <MessageCategory>[
    BLUETOOTH_AVAILABLE,
    BLUETOOTH_STATE,
    CENTRAL_START_DISCOVERY,
    CENTRAL_STOP_DISCOVERY,
    CENTRAL_DISCOVERED,
    CENTRAL_CONNECT,
    GATT_DISCONNECT,
    GATT_CONNECTION_LOST,
    GATT_CHARACTERISTIC_READ,
    GATT_CHARACTERISTIC_WRITE,
    GATT_CHARACTERISTIC_NOTIFY,
    GATT_DESCRIPTOR_READ,
    GATT_DESCRIPTOR_WRITE,
  ];

  static final $core.Map<$core.int, MessageCategory> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static MessageCategory? valueOf($core.int value) => _byValue[value];

  const MessageCategory._($core.int v, $core.String n) : super(v, n);
}
