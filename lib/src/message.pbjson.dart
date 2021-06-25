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
    const {'1': 'BLUETOOTH_STATE', '2': 0},
    const {'1': 'CENTRAL_START_DISCOVERY', '2': 1},
    const {'1': 'CENTRAL_STOP_DISCOVERY', '2': 2},
    const {'1': 'CENTRAL_DISCOVERED', '2': 3},
    const {'1': 'CENTRAL_SCANNING', '2': 4},
    const {'1': 'CENTRAL_CONNECT', '2': 5},
    const {'1': 'GATT_DISCONNECT', '2': 6},
    const {'1': 'GATT_CONNECTION_LOST', '2': 7},
  ],
};

/// Descriptor for `MessageCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageCategoryDescriptor = $convert.base64Decode('Cg9NZXNzYWdlQ2F0ZWdvcnkSEwoPQkxVRVRPT1RIX1NUQVRFEAASGwoXQ0VOVFJBTF9TVEFSVF9ESVNDT1ZFUlkQARIaChZDRU5UUkFMX1NUT1BfRElTQ09WRVJZEAISFgoSQ0VOVFJBTF9ESVNDT1ZFUkVEEAMSFAoQQ0VOVFJBTF9TQ0FOTklORxAEEhMKD0NFTlRSQUxfQ09OTkVDVBAFEhMKD0dBVFRfRElTQ09OTkVDVBAGEhgKFEdBVFRfQ09OTkVDVElPTl9MT1NUEAc=');
@$core.Deprecated('Use bluetoothStateDescriptor instead')
const BluetoothState$json = const {
  '1': 'BluetoothState',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'RESETTING', '2': 1},
    const {'1': 'UNSUPPORTED', '2': 2},
    const {'1': 'UNAUTHORIZED', '2': 3},
    const {'1': 'POWERED_OFF', '2': 4},
    const {'1': 'POWERED_ON', '2': 5},
  ],
};

/// Descriptor for `BluetoothState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bluetoothStateDescriptor = $convert.base64Decode('Cg5CbHVldG9vdGhTdGF0ZRILCgdVTktOT1dOEAASDQoJUkVTRVRUSU5HEAESDwoLVU5TVVBQT1JURUQQAhIQCgxVTkFVVEhPUklaRUQQAxIPCgtQT1dFUkVEX09GRhAEEg4KClBPV0VSRURfT04QBQ==');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.MessageCategory', '10': 'category'},
    const {'1': 'state', '3': 2, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.BluetoothState', '9': 0, '10': 'state'},
    const {'1': 'discovery', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.Discovery', '9': 0, '10': 'discovery'},
    const {'1': 'scanning', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'scanning'},
    const {'1': 'connectionLostArguments', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.ConnectionLostArguments', '9': 0, '10': 'connectionLostArguments'},
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlElEKCGNhdGVnb3J5GAEgASgOMjUuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lk1lc3NhZ2VDYXRlZ29yeVIIY2F0ZWdvcnkSTAoFc3RhdGUYAiABKA4yNC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQmx1ZXRvb3RoU3RhdGVIAFIFc3RhdGUSTwoJZGlzY292ZXJ5GAMgASgLMi8uZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkRpc2NvdmVyeUgAUglkaXNjb3ZlcnkSHAoIc2Nhbm5pbmcYBCABKAhIAFIIc2Nhbm5pbmcSeQoXY29ubmVjdGlvbkxvc3RBcmd1bWVudHMYBSABKAsyPS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQ29ubmVjdGlvbkxvc3RBcmd1bWVudHNIAFIXY29ubmVjdGlvbkxvc3RBcmd1bWVudHNCBwoFdmFsdWU=');
@$core.Deprecated('Use discoveryArgumentsDescriptor instead')
const DiscoveryArguments$json = const {
  '1': 'DiscoveryArguments',
  '2': const [
    const {'1': 'services', '3': 1, '4': 3, '5': 9, '10': 'services'},
  ],
};

/// Descriptor for `DiscoveryArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveryArgumentsDescriptor = $convert.base64Decode('ChJEaXNjb3ZlcnlBcmd1bWVudHMSGgoIc2VydmljZXMYASADKAlSCHNlcnZpY2Vz');
@$core.Deprecated('Use discoveryDescriptor instead')
const Discovery$json = const {
  '1': 'Discovery',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 17, '10': 'rssi'},
    const {'1': 'advertisements', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.Discovery.AdvertisementsEntry', '10': 'advertisements'},
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
final $typed_data.Uint8List discoveryDescriptor = $convert.base64Decode('CglEaXNjb3ZlcnkSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxISCgRyc3NpGAIgASgRUgRyc3NpEmsKDmFkdmVydGlzZW1lbnRzGAMgAygLMkMuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkRpc2NvdmVyeS5BZHZlcnRpc2VtZW50c0VudHJ5Ug5hZHZlcnRpc2VtZW50cxpBChNBZHZlcnRpc2VtZW50c0VudHJ5EhAKA2tleRgBIAEoDVIDa2V5EhQKBXZhbHVlGAIgASgMUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use gATTDescriptor instead')
const GATT$json = const {
  '1': 'GATT',
  '2': const [
    const {'1': 'mtu', '3': 1, '4': 1, '5': 5, '10': 'mtu'},
    const {'1': 'services', '3': 2, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattService', '10': 'services'},
  ],
};

/// Descriptor for `GATT`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gATTDescriptor = $convert.base64Decode('CgRHQVRUEhAKA210dRgBIAEoBVIDbXR1Ek0KCHNlcnZpY2VzGAIgAygLMjEuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRTZXJ2aWNlUghzZXJ2aWNlcw==');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'characteristics', '3': 2, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRISCgR1dWlkGAEgASgJUgR1dWlkEmIKD2NoYXJhY3RlcmlzdGljcxgCIAMoCzI4LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q2hhcmFjdGVyaXN0aWNSD2NoYXJhY3RlcmlzdGljcw==');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'descriptors', '3': 2, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptor', '10': 'descriptors'},
    const {'1': 'canRead', '3': 3, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'canWrite', '3': 4, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'canWriteWithoutResponse', '3': 5, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'canNotify', '3': 6, '4': 1, '5': 8, '10': 'canNotify'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSEgoEdXVpZBgBIAEoCVIEdXVpZBJWCgtkZXNjcmlwdG9ycxgCIAMoCzI0LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0RGVzY3JpcHRvclILZGVzY3JpcHRvcnMSGAoHY2FuUmVhZBgDIAEoCFIHY2FuUmVhZBIaCghjYW5Xcml0ZRgEIAEoCFIIY2FuV3JpdGUSOAoXY2FuV3JpdGVXaXRob3V0UmVzcG9uc2UYBSABKAhSF2NhbldyaXRlV2l0aG91dFJlc3BvbnNlEhwKCWNhbk5vdGlmeRgGIAEoCFIJY2FuTm90aWZ5');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchISCgR1dWlkGAEgASgJUgR1dWlk');
@$core.Deprecated('Use connectionLostArgumentsDescriptor instead')
const ConnectionLostArguments$json = const {
  '1': 'ConnectionLostArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'error_code', '3': 2, '4': 1, '5': 5, '10': 'errorCode'},
  ],
};

/// Descriptor for `ConnectionLostArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionLostArgumentsDescriptor = $convert.base64Decode('ChdDb25uZWN0aW9uTG9zdEFyZ3VtZW50cxIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEh0KCmVycm9yX2NvZGUYAiABKAVSCWVycm9yQ29kZQ==');
