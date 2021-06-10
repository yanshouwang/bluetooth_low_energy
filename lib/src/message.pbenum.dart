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
  static const MessageCategory BLUETOOTH_MANAGER_STATE = MessageCategory._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_MANAGER_STATE');
  static const MessageCategory CENTRAL_MANAGER_START_DISCOVERY = MessageCategory._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CENTRAL_MANAGER_START_DISCOVERY');
  static const MessageCategory CENTRAL_MANAGER_STOP_DISCOVERY = MessageCategory._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CENTRAL_MANAGER_STOP_DISCOVERY');
  static const MessageCategory CENTRAL_MANAGER_DISCOVERED = MessageCategory._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CENTRAL_MANAGER_DISCOVERED');

  static const $core.List<MessageCategory> values = <MessageCategory> [
    BLUETOOTH_MANAGER_STATE,
    CENTRAL_MANAGER_START_DISCOVERY,
    CENTRAL_MANAGER_STOP_DISCOVERY,
    CENTRAL_MANAGER_DISCOVERED,
  ];

  static final $core.Map<$core.int, MessageCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageCategory? valueOf($core.int value) => _byValue[value];

  const MessageCategory._($core.int v, $core.String n) : super(v, n);
}

class BluetoothManagerState extends $pb.ProtobufEnum {
  static const BluetoothManagerState UNKNOWN = BluetoothManagerState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN');
  static const BluetoothManagerState RESETTING = BluetoothManagerState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RESETTING');
  static const BluetoothManagerState UNSUPPORTED = BluetoothManagerState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNSUPPORTED');
  static const BluetoothManagerState UNAUTHORIZED = BluetoothManagerState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNAUTHORIZED');
  static const BluetoothManagerState POWERED_OFF = BluetoothManagerState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POWERED_OFF');
  static const BluetoothManagerState POWERED_ON = BluetoothManagerState._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POWERED_ON');

  static const $core.List<BluetoothManagerState> values = <BluetoothManagerState> [
    UNKNOWN,
    RESETTING,
    UNSUPPORTED,
    UNAUTHORIZED,
    POWERED_OFF,
    POWERED_ON,
  ];

  static final $core.Map<$core.int, BluetoothManagerState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BluetoothManagerState? valueOf($core.int value) => _byValue[value];

  const BluetoothManagerState._($core.int v, $core.String n) : super(v, n);
}

