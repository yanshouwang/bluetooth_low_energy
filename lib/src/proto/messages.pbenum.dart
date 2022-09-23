///
//  Generated code. Do not modify.
//  source: proto/messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class BluetoothState extends $pb.ProtobufEnum {
  static const BluetoothState BLUETOOTH_STATE_UNSUPPORTED = BluetoothState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_UNSUPPORTED');
  static const BluetoothState BLUETOOTH_STATE_POWERED_OFF = BluetoothState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_POWERED_OFF');
  static const BluetoothState BLUETOOTH_STATE_POWERED_ON = BluetoothState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLUETOOTH_STATE_POWERED_ON');

  static const $core.List<BluetoothState> values = <BluetoothState> [
    BLUETOOTH_STATE_UNSUPPORTED,
    BLUETOOTH_STATE_POWERED_OFF,
    BLUETOOTH_STATE_POWERED_ON,
  ];

  static final $core.Map<$core.int, BluetoothState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BluetoothState? valueOf($core.int value) => _byValue[value];

  const BluetoothState._($core.int v, $core.String n) : super(v, n);
}

