///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use messageCategoryDescriptor instead')
const MessageCategory$json = const {
  '1': 'MessageCategory',
  '2': const [
    const {'1': 'BLUETOOTH_MANAGER_STATE', '2': 0},
    const {'1': 'CENTRAL_MANAGER_START_DISCOVERY', '2': 1},
    const {'1': 'CENTRAL_MANAGER_STOP_DISCOVERY', '2': 2},
    const {'1': 'CENTRAL_MANAGER_DISCOVERED', '2': 3},
  ],
};

/// Descriptor for `MessageCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageCategoryDescriptor = $convert.base64Decode('Cg9NZXNzYWdlQ2F0ZWdvcnkSGwoXQkxVRVRPT1RIX01BTkFHRVJfU1RBVEUQABIjCh9DRU5UUkFMX01BTkFHRVJfU1RBUlRfRElTQ09WRVJZEAESIgoeQ0VOVFJBTF9NQU5BR0VSX1NUT1BfRElTQ09WRVJZEAISHgoaQ0VOVFJBTF9NQU5BR0VSX0RJU0NPVkVSRUQQAw==');
@$core.Deprecated('Use bluetoothManagerStateDescriptor instead')
const BluetoothManagerState$json = const {
  '1': 'BluetoothManagerState',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'RESETTING', '2': 1},
    const {'1': 'UNSUPPORTED', '2': 2},
    const {'1': 'UNAUTHORIZED', '2': 3},
    const {'1': 'POWERED_OFF', '2': 4},
    const {'1': 'POWERED_ON', '2': 5},
  ],
};

/// Descriptor for `BluetoothManagerState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bluetoothManagerStateDescriptor = $convert.base64Decode('ChVCbHVldG9vdGhNYW5hZ2VyU3RhdGUSCwoHVU5LTk9XThAAEg0KCVJFU0VUVElORxABEg8KC1VOU1VQUE9SVEVEEAISEAoMVU5BVVRIT1JJWkVEEAMSDwoLUE9XRVJFRF9PRkYQBBIOCgpQT1dFUkVEX09OEAU=');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.MessageCategory', '10': 'category'},
    const {'1': 'state', '3': 2, '4': 1, '5': 14, '6': '.BluetoothManagerState', '9': 0, '10': 'state'},
    const {'1': 'discovery', '3': 3, '4': 1, '5': 11, '6': '.Discovery', '9': 0, '10': 'discovery'},
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEiwKCGNhdGVnb3J5GAEgASgOMhAuTWVzc2FnZUNhdGVnb3J5UghjYXRlZ29yeRIuCgVzdGF0ZRgCIAEoDjIWLkJsdWV0b290aE1hbmFnZXJTdGF0ZUgAUgVzdGF0ZRIqCglkaXNjb3ZlcnkYAyABKAsyCi5EaXNjb3ZlcnlIAFIJZGlzY292ZXJ5QgcKBXZhbHVl');
@$core.Deprecated('Use discoveryDescriptor instead')
const Discovery$json = const {
  '1': 'Discovery',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 17, '10': 'rssi'},
    const {'1': 'advertisements', '3': 3, '4': 3, '5': 11, '6': '.Discovery.AdvertisementsEntry', '10': 'advertisements'},
  ],
  '3': const [Discovery_AdvertisementsEntry$json],
};

@$core.Deprecated('Use discoveryDescriptor instead')
const Discovery_AdvertisementsEntry$json = const {
  '1': 'AdvertisementsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Discovery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveryDescriptor = $convert.base64Decode('CglEaXNjb3ZlcnkSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxISCgRyc3NpGAIgASgRUgRyc3NpEkYKDmFkdmVydGlzZW1lbnRzGAMgAygLMh4uRGlzY292ZXJ5LkFkdmVydGlzZW1lbnRzRW50cnlSDmFkdmVydGlzZW1lbnRzGkEKE0FkdmVydGlzZW1lbnRzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSFAoFdmFsdWUYAiABKAxSBXZhbHVlOgI4AQ==');
