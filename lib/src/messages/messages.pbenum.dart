///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CommandCategory extends $pb.ProtobufEnum {
  static const CommandCategory COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE = CommandCategory._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE');
  static const CommandCategory COMMAND_CATEGORY_BLUETOOTH_GET_STATE = CommandCategory._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_BLUETOOTH_GET_STATE');
  static const CommandCategory COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED = CommandCategory._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED');
  static const CommandCategory COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED = CommandCategory._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED');
  static const CommandCategory COMMAND_CATEGORY_CENTRAL_START_DISCOVERY = CommandCategory._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CENTRAL_START_DISCOVERY');
  static const CommandCategory COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY = CommandCategory._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY');
  static const CommandCategory COMMAND_CATEGORY_CENTRAL_CONNECT = CommandCategory._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CENTRAL_CONNECT');
  static const CommandCategory COMMAND_CATEGORY_GATT_DISCONNECT = CommandCategory._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_GATT_DISCONNECT');
  static const CommandCategory COMMAND_CATEGORY_CHARACTERISTIC_READ = CommandCategory._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CHARACTERISTIC_READ');
  static const CommandCategory COMMAND_CATEGORY_CHARACTERISTIC_WRITE = CommandCategory._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CHARACTERISTIC_WRITE');
  static const CommandCategory COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY = CommandCategory._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY');
  static const CommandCategory COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY = CommandCategory._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY');
  static const CommandCategory COMMAND_CATEGORY_DESCRIPTOR_READ = CommandCategory._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_DESCRIPTOR_READ');
  static const CommandCategory COMMAND_CATEGORY_DESCRIPTOR_WRITE = CommandCategory._(13, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COMMAND_CATEGORY_DESCRIPTOR_WRITE');

  static const $core.List<CommandCategory> values = <CommandCategory> [
    COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE,
    COMMAND_CATEGORY_BLUETOOTH_GET_STATE,
    COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED,
    COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED,
    COMMAND_CATEGORY_CENTRAL_START_DISCOVERY,
    COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY,
    COMMAND_CATEGORY_CENTRAL_CONNECT,
    COMMAND_CATEGORY_GATT_DISCONNECT,
    COMMAND_CATEGORY_CHARACTERISTIC_READ,
    COMMAND_CATEGORY_CHARACTERISTIC_WRITE,
    COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY,
    COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY,
    COMMAND_CATEGORY_DESCRIPTOR_READ,
    COMMAND_CATEGORY_DESCRIPTOR_WRITE,
  ];

  static final $core.Map<$core.int, CommandCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommandCategory? valueOf($core.int value) => _byValue[value];

  const CommandCategory._($core.int v, $core.String n) : super(v, n);
}

class EventCategory extends $pb.ProtobufEnum {
  static const EventCategory EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED = EventCategory._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED');
  static const EventCategory EVENT_CATEGORY_CENTRAL_DISCOVERED = EventCategory._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_CATEGORY_CENTRAL_DISCOVERED');
  static const EventCategory EVENT_CATEGORY_GATT_CONNECTION_LOST = EventCategory._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_CATEGORY_GATT_CONNECTION_LOST');
  static const EventCategory EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED = EventCategory._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED');

  static const $core.List<EventCategory> values = <EventCategory> [
    EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED,
    EVENT_CATEGORY_CENTRAL_DISCOVERED,
    EVENT_CATEGORY_GATT_CONNECTION_LOST,
    EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED,
  ];

  static final $core.Map<$core.int, EventCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EventCategory? valueOf($core.int value) => _byValue[value];

  const EventCategory._($core.int v, $core.String n) : super(v, n);
}

class BluetoothState extends $pb.ProtobufEnum {
  static const BluetoothState BLUETOOTH_STATE_UNSUPPORTED = BluetoothState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_UNSUPPORTED');
  static const BluetoothState BLUETOOTH_STATE_UNAUTHORIZED = BluetoothState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_UNAUTHORIZED');
  static const BluetoothState BLUETOOTH_STATE_POWERED_OFF = BluetoothState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_POWERED_OFF');
  static const BluetoothState BLUETOOTH_STATE_POWERED_ON = BluetoothState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_POWERED_ON');

  static const $core.List<BluetoothState> values = <BluetoothState> [
    BLUETOOTH_STATE_UNSUPPORTED,
    BLUETOOTH_STATE_UNAUTHORIZED,
    BLUETOOTH_STATE_POWERED_OFF,
    BLUETOOTH_STATE_POWERED_ON,
  ];

  static final $core.Map<$core.int, BluetoothState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BluetoothState? valueOf($core.int value) => _byValue[value];

  const BluetoothState._($core.int v, $core.String n) : super(v, n);
}

