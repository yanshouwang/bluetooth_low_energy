///
//  Generated code. Do not modify.
//  source: proto/messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use bluetoothStateDescriptor instead')
const BluetoothState$json = const {
  '1': 'BluetoothState',
  '2': const [
    const {'1': 'BLUETOOTH_STATE_UNSUPPORTED', '2': 0},
    const {'1': 'BLUETOOTH_STATE_POWERED_OFF', '2': 1},
    const {'1': 'BLUETOOTH_STATE_POWERED_ON', '2': 2},
  ],
};

/// Descriptor for `BluetoothState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bluetoothStateDescriptor = $convert.base64Decode('Cg5CbHVldG9vdGhTdGF0ZRIfChtCTFVFVE9PVEhfU1RBVEVfVU5TVVBQT1JURUQQABIfChtCTFVFVE9PVEhfU1RBVEVfUE9XRVJFRF9PRkYQARIeChpCTFVFVE9PVEhfU1RBVEVfUE9XRVJFRF9PThAC');
@$core.Deprecated('Use broadcastDescriptor instead')
const Broadcast$json = const {
  '1': 'Broadcast',
  '2': const [
    const {'1': 'peripheral', '3': 1, '4': 1, '5': 11, '6': '.proto.Peripheral', '10': 'peripheral'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 5, '10': 'rssi'},
    const {'1': 'connectable', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'connectable', '17': true},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'local_name', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'localName', '17': true},
    const {'1': 'manufacturer_specific_data', '3': 6, '4': 1, '5': 12, '10': 'manufacturerSpecificData'},
    const {'1': 'service_datas', '3': 7, '4': 3, '5': 11, '6': '.proto.ServiceData', '10': 'serviceDatas'},
    const {'1': 'service_uuids', '3': 8, '4': 3, '5': 11, '6': '.proto.UUID', '10': 'serviceUuids'},
    const {'1': 'solicited_service_uuids', '3': 9, '4': 3, '5': 11, '6': '.proto.UUID', '10': 'solicitedServiceUuids'},
    const {'1': 'tx_power_level', '3': 10, '4': 1, '5': 5, '9': 2, '10': 'txPowerLevel', '17': true},
  ],
  '8': const [
    const {'1': '_connectable'},
    const {'1': '_local_name'},
    const {'1': '_tx_power_level'},
  ],
};

/// Descriptor for `Broadcast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastDescriptor = $convert.base64Decode('CglCcm9hZGNhc3QSMQoKcGVyaXBoZXJhbBgBIAEoCzIRLnByb3RvLlBlcmlwaGVyYWxSCnBlcmlwaGVyYWwSEgoEcnNzaRgCIAEoBVIEcnNzaRIlCgtjb25uZWN0YWJsZRgDIAEoCEgAUgtjb25uZWN0YWJsZYgBARISCgRkYXRhGAQgASgMUgRkYXRhEiIKCmxvY2FsX25hbWUYBSABKAlIAVIJbG9jYWxOYW1liAEBEjwKGm1hbnVmYWN0dXJlcl9zcGVjaWZpY19kYXRhGAYgASgMUhhtYW51ZmFjdHVyZXJTcGVjaWZpY0RhdGESNwoNc2VydmljZV9kYXRhcxgHIAMoCzISLnByb3RvLlNlcnZpY2VEYXRhUgxzZXJ2aWNlRGF0YXMSMAoNc2VydmljZV91dWlkcxgIIAMoCzILLnByb3RvLlVVSURSDHNlcnZpY2VVdWlkcxJDChdzb2xpY2l0ZWRfc2VydmljZV91dWlkcxgJIAMoCzILLnByb3RvLlVVSURSFXNvbGljaXRlZFNlcnZpY2VVdWlkcxIpCg50eF9wb3dlcl9sZXZlbBgKIAEoBUgCUgx0eFBvd2VyTGV2ZWyIAQFCDgoMX2Nvbm5lY3RhYmxlQg0KC19sb2NhbF9uYW1lQhEKD190eF9wb3dlcl9sZXZlbA==');
@$core.Deprecated('Use peripheralDescriptor instead')
const Peripheral$json = const {
  '1': 'Peripheral',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 11, '6': '.proto.UUID', '10': 'uuid'},
  ],
};

/// Descriptor for `Peripheral`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peripheralDescriptor = $convert.base64Decode('CgpQZXJpcGhlcmFsEg4KAmlkGAEgASgJUgJpZBIfCgR1dWlkGAIgASgLMgsucHJvdG8uVVVJRFIEdXVpZA==');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 11, '6': '.proto.UUID', '10': 'uuid'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIOCgJpZBgBIAEoCVICaWQSHwoEdXVpZBgCIAEoCzILLnByb3RvLlVVSURSBHV1aWQ=');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 11, '6': '.proto.UUID', '10': 'uuid'},
    const {'1': 'can_read', '3': 3, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'can_write', '3': 4, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'can_write_without_response', '3': 5, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'can_notify', '3': 6, '4': 1, '5': 8, '10': 'canNotify'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSDgoCaWQYASABKAlSAmlkEh8KBHV1aWQYAiABKAsyCy5wcm90by5VVUlEUgR1dWlkEhkKCGNhbl9yZWFkGAMgASgIUgdjYW5SZWFkEhsKCWNhbl93cml0ZRgEIAEoCFIIY2FuV3JpdGUSOwoaY2FuX3dyaXRlX3dpdGhvdXRfcmVzcG9uc2UYBSABKAhSF2NhbldyaXRlV2l0aG91dFJlc3BvbnNlEh0KCmNhbl9ub3RpZnkYBiABKAhSCWNhbk5vdGlmeQ==');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 11, '6': '.proto.UUID', '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchIOCgJpZBgBIAEoCVICaWQSHwoEdXVpZBgCIAEoCzILLnByb3RvLlVVSURSBHV1aWQ=');
@$core.Deprecated('Use uUIDDescriptor instead')
const UUID$json = const {
  '1': 'UUID',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `UUID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uUIDDescriptor = $convert.base64Decode('CgRVVUlEEhQKBXZhbHVlGAEgASgJUgV2YWx1ZQ==');
@$core.Deprecated('Use serviceDataDescriptor instead')
const ServiceData$json = const {
  '1': 'ServiceData',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 11, '6': '.proto.UUID', '10': 'uuid'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ServiceData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDataDescriptor = $convert.base64Decode('CgtTZXJ2aWNlRGF0YRIfCgR1dWlkGAEgASgLMgsucHJvdG8uVVVJRFIEdXVpZBISCgRkYXRhGAIgASgMUgRkYXRh');
