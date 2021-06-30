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
    const {'1': 'CENTRAL_CONNECT', '2': 4},
    const {'1': 'GATT_DISCONNECT', '2': 5},
    const {'1': 'GATT_CONNECTION_LOST', '2': 6},
    const {'1': 'GATT_CHARACTERISTIC_READ', '2': 7},
    const {'1': 'GATT_CHARACTERISTIC_WRITE', '2': 8},
    const {'1': 'GATT_CHARACTERISTIC_NOTIFY', '2': 9},
    const {'1': 'GATT_DESCRIPTOR_READ', '2': 10},
    const {'1': 'GATT_DESCRIPTOR_WRITE', '2': 11},
  ],
};

/// Descriptor for `MessageCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageCategoryDescriptor = $convert.base64Decode('Cg9NZXNzYWdlQ2F0ZWdvcnkSEwoPQkxVRVRPT1RIX1NUQVRFEAASGwoXQ0VOVFJBTF9TVEFSVF9ESVNDT1ZFUlkQARIaChZDRU5UUkFMX1NUT1BfRElTQ09WRVJZEAISFgoSQ0VOVFJBTF9ESVNDT1ZFUkVEEAMSEwoPQ0VOVFJBTF9DT05ORUNUEAQSEwoPR0FUVF9ESVNDT05ORUNUEAUSGAoUR0FUVF9DT05ORUNUSU9OX0xPU1QQBhIcChhHQVRUX0NIQVJBQ1RFUklTVElDX1JFQUQQBxIdChlHQVRUX0NIQVJBQ1RFUklTVElDX1dSSVRFEAgSHgoaR0FUVF9DSEFSQUNURVJJU1RJQ19OT1RJRlkQCRIYChRHQVRUX0RFU0NSSVBUT1JfUkVBRBAKEhkKFUdBVFRfREVTQ1JJUFRPUl9XUklURRAL');
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
    const {'1': 'connectionLost', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.ConnectionLost', '9': 0, '10': 'connectionLost'},
    const {'1': 'characteristicValue', '3': 6, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValue', '9': 0, '10': 'characteristicValue'},
  ],
  '8': const [
    const {'1': 'value'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlElEKCGNhdGVnb3J5GAEgASgOMjUuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lk1lc3NhZ2VDYXRlZ29yeVIIY2F0ZWdvcnkSTAoFc3RhdGUYAiABKA4yNC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQmx1ZXRvb3RoU3RhdGVIAFIFc3RhdGUSTwoJZGlzY292ZXJ5GAMgASgLMi8uZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkRpc2NvdmVyeUgAUglkaXNjb3ZlcnkSHAoIc2Nhbm5pbmcYBCABKAhIAFIIc2Nhbm5pbmcSXgoOY29ubmVjdGlvbkxvc3QYBSABKAsyNC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQ29ubmVjdGlvbkxvc3RIAFIOY29ubmVjdGlvbkxvc3QScQoTY2hhcmFjdGVyaXN0aWNWYWx1ZRgGIAEoCzI9LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q2hhcmFjdGVyaXN0aWNWYWx1ZUgAUhNjaGFyYWN0ZXJpc3RpY1ZhbHVlQgcKBXZhbHVl');
@$core.Deprecated('Use startDiscoveryArgumentsDescriptor instead')
const StartDiscoveryArguments$json = const {
  '1': 'StartDiscoveryArguments',
  '2': const [
    const {'1': 'services', '3': 1, '4': 3, '5': 9, '10': 'services'},
  ],
};

/// Descriptor for `StartDiscoveryArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startDiscoveryArgumentsDescriptor = $convert.base64Decode('ChdTdGFydERpc2NvdmVyeUFyZ3VtZW50cxIaCghzZXJ2aWNlcxgBIAMoCVIIc2VydmljZXM=');
@$core.Deprecated('Use discoveryDescriptor instead')
const Discovery$json = const {
  '1': 'Discovery',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 17, '10': 'rssi'},
    const {'1': 'advertisements', '3': 3, '4': 1, '5': 12, '10': 'advertisements'},
  ],
};

/// Descriptor for `Discovery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveryDescriptor = $convert.base64Decode('CglEaXNjb3ZlcnkSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxISCgRyc3NpGAIgASgRUgRyc3NpEiYKDmFkdmVydGlzZW1lbnRzGAMgASgMUg5hZHZlcnRpc2VtZW50cw==');
@$core.Deprecated('Use connectArgumentsDescriptor instead')
const ConnectArguments$json = const {
  '1': 'ConnectArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `ConnectArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectArgumentsDescriptor = $convert.base64Decode('ChBDb25uZWN0QXJndW1lbnRzEhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3M=');
@$core.Deprecated('Use gATTDescriptor instead')
const GATT$json = const {
  '1': 'GATT',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'mtu', '3': 2, '4': 1, '5': 5, '10': 'mtu'},
    const {'1': 'services', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattService', '10': 'services'},
  ],
};

/// Descriptor for `GATT`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gATTDescriptor = $convert.base64Decode('CgRHQVRUEg4KAmlkGAEgASgFUgJpZBIQCgNtdHUYAiABKAVSA210dRJNCghzZXJ2aWNlcxgDIAMoCzIxLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0U2VydmljZVIIc2VydmljZXM=');
@$core.Deprecated('Use gattDisconnectArgumentsDescriptor instead')
const GattDisconnectArguments$json = const {
  '1': 'GattDisconnectArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'id', '3': 2, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `GattDisconnectArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDisconnectArgumentsDescriptor = $convert.base64Decode('ChdHYXR0RGlzY29ubmVjdEFyZ3VtZW50cxIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEg4KAmlkGAIgASgFUgJpZA==');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'characteristics', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIOCgJpZBgBIAEoBVICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZBJiCg9jaGFyYWN0ZXJpc3RpY3MYAyADKAsyOC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dENoYXJhY3RlcmlzdGljUg9jaGFyYWN0ZXJpc3RpY3M=');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'descriptors', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptor', '10': 'descriptors'},
    const {'1': 'canRead', '3': 4, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'canWrite', '3': 5, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'canWriteWithoutResponse', '3': 6, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'canNotify', '3': 7, '4': 1, '5': 8, '10': 'canNotify'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSDgoCaWQYASABKAVSAmlkEhIKBHV1aWQYAiABKAlSBHV1aWQSVgoLZGVzY3JpcHRvcnMYAyADKAsyNC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dERlc2NyaXB0b3JSC2Rlc2NyaXB0b3JzEhgKB2NhblJlYWQYBCABKAhSB2NhblJlYWQSGgoIY2FuV3JpdGUYBSABKAhSCGNhbldyaXRlEjgKF2NhbldyaXRlV2l0aG91dFJlc3BvbnNlGAYgASgIUhdjYW5Xcml0ZVdpdGhvdXRSZXNwb25zZRIcCgljYW5Ob3RpZnkYByABKAhSCWNhbk5vdGlmeQ==');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchIOCgJpZBgBIAEoBVICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZA==');
@$core.Deprecated('Use connectionLostDescriptor instead')
const ConnectionLost$json = const {
  '1': 'ConnectionLost',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'error_code', '3': 2, '4': 1, '5': 5, '10': 'errorCode'},
  ],
};

/// Descriptor for `ConnectionLost`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionLostDescriptor = $convert.base64Decode('Cg5Db25uZWN0aW9uTG9zdBIOCgJpZBgBIAEoBVICaWQSHQoKZXJyb3JfY29kZRgCIAEoBVIJZXJyb3JDb2Rl');
@$core.Deprecated('Use gattCharacteristicReadArgumentsDescriptor instead')
const GattCharacteristicReadArguments$json = const {
  '1': 'GattCharacteristicReadArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'service_uuid', '3': 2, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'id', '3': 4, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `GattCharacteristicReadArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicReadArgumentsDescriptor = $convert.base64Decode('Ch9HYXR0Q2hhcmFjdGVyaXN0aWNSZWFkQXJndW1lbnRzEhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSIQoMc2VydmljZV91dWlkGAIgASgJUgtzZXJ2aWNlVXVpZBISCgR1dWlkGAMgASgJUgR1dWlkEg4KAmlkGAQgASgFUgJpZA==');
@$core.Deprecated('Use gattCharacteristicWriteArgumentsDescriptor instead')
const GattCharacteristicWriteArguments$json = const {
  '1': 'GattCharacteristicWriteArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'service_uuid', '3': 2, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'id', '3': 4, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'value', '3': 5, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'withoutResponse', '3': 6, '4': 1, '5': 8, '10': 'withoutResponse'},
  ],
};

/// Descriptor for `GattCharacteristicWriteArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicWriteArgumentsDescriptor = $convert.base64Decode('CiBHYXR0Q2hhcmFjdGVyaXN0aWNXcml0ZUFyZ3VtZW50cxIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEiEKDHNlcnZpY2VfdXVpZBgCIAEoCVILc2VydmljZVV1aWQSEgoEdXVpZBgDIAEoCVIEdXVpZBIOCgJpZBgEIAEoBVICaWQSFAoFdmFsdWUYBSABKAxSBXZhbHVlEigKD3dpdGhvdXRSZXNwb25zZRgGIAEoCFIPd2l0aG91dFJlc3BvbnNl');
@$core.Deprecated('Use gattCharacteristicNotifyArgumentsDescriptor instead')
const GattCharacteristicNotifyArguments$json = const {
  '1': 'GattCharacteristicNotifyArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'service_uuid', '3': 2, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'id', '3': 4, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'state', '3': 5, '4': 1, '5': 8, '10': 'state'},
  ],
};

/// Descriptor for `GattCharacteristicNotifyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicNotifyArgumentsDescriptor = $convert.base64Decode('CiFHYXR0Q2hhcmFjdGVyaXN0aWNOb3RpZnlBcmd1bWVudHMSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIhCgxzZXJ2aWNlX3V1aWQYAiABKAlSC3NlcnZpY2VVdWlkEhIKBHV1aWQYAyABKAlSBHV1aWQSDgoCaWQYBCABKAVSAmlkEhQKBXN0YXRlGAUgASgIUgVzdGF0ZQ==');
@$core.Deprecated('Use gattCharacteristicValueDescriptor instead')
const GattCharacteristicValue$json = const {
  '1': 'GattCharacteristicValue',
  '2': const [
    const {'1': 'id', '3': 3, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattCharacteristicValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicValueDescriptor = $convert.base64Decode('ChdHYXR0Q2hhcmFjdGVyaXN0aWNWYWx1ZRIOCgJpZBgDIAEoBVICaWQSFAoFdmFsdWUYBCABKAxSBXZhbHVl');
@$core.Deprecated('Use gattDescriptorReadArgumentsDescriptor instead')
const GattDescriptorReadArguments$json = const {
  '1': 'GattDescriptorReadArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'service_uuid', '3': 2, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'characteristic_uuid', '3': 3, '4': 1, '5': 9, '10': 'characteristicUuid'},
    const {'1': 'uuid', '3': 4, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'id', '3': 5, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `GattDescriptorReadArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorReadArgumentsDescriptor = $convert.base64Decode('ChtHYXR0RGVzY3JpcHRvclJlYWRBcmd1bWVudHMSGAoHYWRkcmVzcxgBIAEoCVIHYWRkcmVzcxIhCgxzZXJ2aWNlX3V1aWQYAiABKAlSC3NlcnZpY2VVdWlkEi8KE2NoYXJhY3RlcmlzdGljX3V1aWQYAyABKAlSEmNoYXJhY3RlcmlzdGljVXVpZBISCgR1dWlkGAQgASgJUgR1dWlkEg4KAmlkGAUgASgFUgJpZA==');
@$core.Deprecated('Use gattDescriptorWriteArgumentsDescriptor instead')
const GattDescriptorWriteArguments$json = const {
  '1': 'GattDescriptorWriteArguments',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'service_uuid', '3': 2, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'characteristic_uuid', '3': 3, '4': 1, '5': 9, '10': 'characteristicUuid'},
    const {'1': 'uuid', '3': 4, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'id', '3': 5, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'value', '3': 6, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattDescriptorWriteArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorWriteArgumentsDescriptor = $convert.base64Decode('ChxHYXR0RGVzY3JpcHRvcldyaXRlQXJndW1lbnRzEhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSIQoMc2VydmljZV91dWlkGAIgASgJUgtzZXJ2aWNlVXVpZBIvChNjaGFyYWN0ZXJpc3RpY191dWlkGAMgASgJUhJjaGFyYWN0ZXJpc3RpY1V1aWQSEgoEdXVpZBgEIAEoCVIEdXVpZBIOCgJpZBgFIAEoBVICaWQSFAoFdmFsdWUYBiABKAxSBXZhbHVl');
