///
//  Generated code. Do not modify.
//  source: proto/messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use advertisementDescriptor instead')
const Advertisement$json = const {
  '1': 'Advertisement',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'rssi', '3': 3, '4': 1, '5': 5, '10': 'rssi'},
    const {'1': 'connectable', '3': 4, '4': 1, '5': 8, '10': 'connectable'},
  ],
};

/// Descriptor for `Advertisement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advertisementDescriptor = $convert.base64Decode('Cg1BZHZlcnRpc2VtZW50EhIKBHV1aWQYASABKAlSBHV1aWQSEgoEZGF0YRgCIAEoDFIEZGF0YRISCgRyc3NpGAMgASgFUgRyc3NpEiAKC2Nvbm5lY3RhYmxlGAQgASgIUgtjb25uZWN0YWJsZQ==');
@$core.Deprecated('Use peripheralDescriptor instead')
const Peripheral$json = const {
  '1': 'Peripheral',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'maximum_write_length', '3': 2, '4': 1, '5': 5, '10': 'maximumWriteLength'},
  ],
};

/// Descriptor for `Peripheral`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peripheralDescriptor = $convert.base64Decode('CgpQZXJpcGhlcmFsEg4KAmlkGAEgASgJUgJpZBIwChRtYXhpbXVtX3dyaXRlX2xlbmd0aBgCIAEoBVISbWF4aW11bVdyaXRlTGVuZ3Ro');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIOCgJpZBgBIAEoCVICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZA==');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'can_read', '3': 3, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'can_write', '3': 4, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'can_write_without_response', '3': 5, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'can_notify', '3': 6, '4': 1, '5': 8, '10': 'canNotify'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSDgoCaWQYASABKAlSAmlkEhIKBHV1aWQYAiABKAlSBHV1aWQSGQoIY2FuX3JlYWQYAyABKAhSB2NhblJlYWQSGwoJY2FuX3dyaXRlGAQgASgIUghjYW5Xcml0ZRI7ChpjYW5fd3JpdGVfd2l0aG91dF9yZXNwb25zZRgFIAEoCFIXY2FuV3JpdGVXaXRob3V0UmVzcG9uc2USHQoKY2FuX25vdGlmeRgGIAEoCFIJY2FuTm90aWZ5');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchIOCgJpZBgBIAEoCVICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZA==');
@$core.Deprecated('Use bluetoothStateDescriptor instead')
const BluetoothState$json = const {
  '1': 'BluetoothState',
  '2': const [
    const {'1': 'number', '3': 1, '4': 1, '5': 5, '10': 'number'},
  ],
};

/// Descriptor for `BluetoothState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothStateDescriptor = $convert.base64Decode('Cg5CbHVldG9vdGhTdGF0ZRIWCgZudW1iZXIYASABKAVSBm51bWJlcg==');