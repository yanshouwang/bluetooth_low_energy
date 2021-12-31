///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use commandCategoryDescriptor instead')
const CommandCategory$json = const {
  '1': 'CommandCategory',
  '2': const [
    const {'1': 'COMMAND_CATEGORY_BLUETOOTH_GET_STATE', '2': 0},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_START_DISCOVERY', '2': 1},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY', '2': 2},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_CONNECT', '2': 3},
    const {'1': 'COMMAND_CATEGORY_GATT_DISCONNECT', '2': 4},
    const {'1': 'COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ', '2': 5},
    const {'1': 'COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE', '2': 6},
    const {'1': 'COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY', '2': 7},
    const {'1': 'COMMAND_CATEGORY_GATT_DESCRIPTOR_READ', '2': 8},
    const {'1': 'COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE', '2': 9},
  ],
};

/// Descriptor for `CommandCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commandCategoryDescriptor = $convert.base64Decode('Cg9Db21tYW5kQ2F0ZWdvcnkSKAokQ09NTUFORF9DQVRFR09SWV9CTFVFVE9PVEhfR0VUX1NUQVRFEAASLAooQ09NTUFORF9DQVRFR09SWV9DRU5UUkFMX1NUQVJUX0RJU0NPVkVSWRABEisKJ0NPTU1BTkRfQ0FURUdPUllfQ0VOVFJBTF9TVE9QX0RJU0NPVkVSWRACEiQKIENPTU1BTkRfQ0FURUdPUllfQ0VOVFJBTF9DT05ORUNUEAMSJAogQ09NTUFORF9DQVRFR09SWV9HQVRUX0RJU0NPTk5FQ1QQBBItCilDT01NQU5EX0NBVEVHT1JZX0dBVFRfQ0hBUkFDVEVSSVNUSUNfUkVBRBAFEi4KKkNPTU1BTkRfQ0FURUdPUllfR0FUVF9DSEFSQUNURVJJU1RJQ19XUklURRAGEi8KK0NPTU1BTkRfQ0FURUdPUllfR0FUVF9DSEFSQUNURVJJU1RJQ19OT1RJRlkQBxIpCiVDT01NQU5EX0NBVEVHT1JZX0dBVFRfREVTQ1JJUFRPUl9SRUFEEAgSKgomQ09NTUFORF9DQVRFR09SWV9HQVRUX0RFU0NSSVBUT1JfV1JJVEUQCQ==');
@$core.Deprecated('Use eventCategoryDescriptor instead')
const EventCategory$json = const {
  '1': 'EventCategory',
  '2': const [
    const {'1': 'EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED', '2': 0},
    const {'1': 'EVENT_CATEGORY_CENTRAL_DISCOVERED', '2': 1},
    const {'1': 'EVENT_CATEGORY_GATT_CONNECTION_LOST', '2': 2},
    const {'1': 'EVENT_CATEGORY_GATT_CHARACTERISTIC_VALUE_CHANGED', '2': 3},
  ],
};

/// Descriptor for `EventCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventCategoryDescriptor = $convert.base64Decode('Cg1FdmVudENhdGVnb3J5EioKJkVWRU5UX0NBVEVHT1JZX0JMVUVUT09USF9TVEFURV9DSEFOR0VEEAASJQohRVZFTlRfQ0FURUdPUllfQ0VOVFJBTF9ESVNDT1ZFUkVEEAESJwojRVZFTlRfQ0FURUdPUllfR0FUVF9DT05ORUNUSU9OX0xPU1QQAhI0CjBFVkVOVF9DQVRFR09SWV9HQVRUX0NIQVJBQ1RFUklTVElDX1ZBTFVFX0NIQU5HRUQQAw==');
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
@$core.Deprecated('Use commandDescriptor instead')
const Command$json = const {
  '1': 'Command',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.CommandCategory', '10': 'category'},
    const {'1': 'central_start_discovery_command', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralStartDiscoveryCommand', '9': 0, '10': 'centralStartDiscoveryCommand'},
    const {'1': 'central_connect_command', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralConnectCommand', '9': 0, '10': 'centralConnectCommand'},
    const {'1': 'gatt_disconnect_command', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDisconnectCommand', '9': 0, '10': 'gattDisconnectCommand'},
    const {'1': 'gatt_characteristic_read_command', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadCommand', '9': 0, '10': 'gattCharacteristicReadCommand'},
    const {'1': 'gatt_characteristic_write_command', '3': 6, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteCommand', '9': 0, '10': 'gattCharacteristicWriteCommand'},
    const {'1': 'gatt_characteristic_notify_command', '3': 7, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyCommand', '9': 0, '10': 'gattCharacteristicNotifyCommand'},
    const {'1': 'gatt_descriptor_read_command', '3': 8, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptorReadCommand', '9': 0, '10': 'gattDescriptorReadCommand'},
    const {'1': 'gatt_descriptor_write_command', '3': 9, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteCommand', '9': 0, '10': 'gattDescriptorWriteCommand'},
  ],
  '8': const [
    const {'1': 'stub'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode('CgdDb21tYW5kElEKCGNhdGVnb3J5GAEgASgOMjUuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkNvbW1hbmRDYXRlZ29yeVIIY2F0ZWdvcnkSiwEKH2NlbnRyYWxfc3RhcnRfZGlzY292ZXJ5X2NvbW1hbmQYAiABKAsyQi5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQ2VudHJhbFN0YXJ0RGlzY292ZXJ5Q29tbWFuZEgAUhxjZW50cmFsU3RhcnREaXNjb3ZlcnlDb21tYW5kEnUKF2NlbnRyYWxfY29ubmVjdF9jb21tYW5kGAMgASgLMjsuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkNlbnRyYWxDb25uZWN0Q29tbWFuZEgAUhVjZW50cmFsQ29ubmVjdENvbW1hbmQSdQoXZ2F0dF9kaXNjb25uZWN0X2NvbW1hbmQYBCABKAsyOy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dERpc2Nvbm5lY3RDb21tYW5kSABSFWdhdHREaXNjb25uZWN0Q29tbWFuZBKOAQogZ2F0dF9jaGFyYWN0ZXJpc3RpY19yZWFkX2NvbW1hbmQYBSABKAsyQy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dENoYXJhY3RlcmlzdGljUmVhZENvbW1hbmRIAFIdZ2F0dENoYXJhY3RlcmlzdGljUmVhZENvbW1hbmQSkQEKIWdhdHRfY2hhcmFjdGVyaXN0aWNfd3JpdGVfY29tbWFuZBgGIAEoCzJELmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q2hhcmFjdGVyaXN0aWNXcml0ZUNvbW1hbmRIAFIeZ2F0dENoYXJhY3RlcmlzdGljV3JpdGVDb21tYW5kEpQBCiJnYXR0X2NoYXJhY3RlcmlzdGljX25vdGlmeV9jb21tYW5kGAcgASgLMkUuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRDaGFyYWN0ZXJpc3RpY05vdGlmeUNvbW1hbmRIAFIfZ2F0dENoYXJhY3RlcmlzdGljTm90aWZ5Q29tbWFuZBKCAQocZ2F0dF9kZXNjcmlwdG9yX3JlYWRfY29tbWFuZBgIIAEoCzI/LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0RGVzY3JpcHRvclJlYWRDb21tYW5kSABSGWdhdHREZXNjcmlwdG9yUmVhZENvbW1hbmQShQEKHWdhdHRfZGVzY3JpcHRvcl93cml0ZV9jb21tYW5kGAkgASgLMkAuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHREZXNjcmlwdG9yV3JpdGVDb21tYW5kSABSGmdhdHREZXNjcmlwdG9yV3JpdGVDb21tYW5kQgYKBHN0dWI=');
@$core.Deprecated('Use centralStartDiscoveryCommandDescriptor instead')
const CentralStartDiscoveryCommand$json = const {
  '1': 'CentralStartDiscoveryCommand',
  '2': const [
    const {'1': 'uuids', '3': 1, '4': 3, '5': 9, '10': 'uuids'},
  ],
};

/// Descriptor for `CentralStartDiscoveryCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralStartDiscoveryCommandDescriptor = $convert.base64Decode('ChxDZW50cmFsU3RhcnREaXNjb3ZlcnlDb21tYW5kEhQKBXV1aWRzGAEgAygJUgV1dWlkcw==');
@$core.Deprecated('Use centralConnectCommandDescriptor instead')
const CentralConnectCommand$json = const {
  '1': 'CentralConnectCommand',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `CentralConnectCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralConnectCommandDescriptor = $convert.base64Decode('ChVDZW50cmFsQ29ubmVjdENvbW1hbmQSEgoEdXVpZBgBIAEoCVIEdXVpZA==');
@$core.Deprecated('Use gattDisconnectCommandDescriptor instead')
const GattDisconnectCommand$json = const {
  '1': 'GattDisconnectCommand',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
  ],
};

/// Descriptor for `GattDisconnectCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDisconnectCommandDescriptor = $convert.base64Decode('ChVHYXR0RGlzY29ubmVjdENvbW1hbmQSGwoJaGFzaF91dWlkGAEgASgJUghoYXNoVXVpZA==');
@$core.Deprecated('Use gattCharacteristicReadCommandDescriptor instead')
const GattCharacteristicReadCommand$json = const {
  '1': 'GattCharacteristicReadCommand',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'hashUuid'},
  ],
};

/// Descriptor for `GattCharacteristicReadCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicReadCommandDescriptor = $convert.base64Decode('Ch1HYXR0Q2hhcmFjdGVyaXN0aWNSZWFkQ29tbWFuZBIkCg5nYXR0X2hhc2hfdXVpZBgBIAEoCVIMZ2F0dEhhc2hVdWlkEjMKFmdhdHRfc2VydmljZV9oYXNoX3V1aWQYAiABKAlSE2dhdHRTZXJ2aWNlSGFzaFV1aWQSGwoJaGFzaF91dWlkGAMgASgJUghoYXNoVXVpZA==');
@$core.Deprecated('Use gattCharacteristicWriteCommandDescriptor instead')
const GattCharacteristicWriteCommand$json = const {
  '1': 'GattCharacteristicWriteCommand',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'without_response', '3': 5, '4': 1, '5': 8, '10': 'withoutResponse'},
  ],
};

/// Descriptor for `GattCharacteristicWriteCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicWriteCommandDescriptor = $convert.base64Decode('Ch5HYXR0Q2hhcmFjdGVyaXN0aWNXcml0ZUNvbW1hbmQSJAoOZ2F0dF9oYXNoX3V1aWQYASABKAlSDGdhdHRIYXNoVXVpZBIzChZnYXR0X3NlcnZpY2VfaGFzaF91dWlkGAIgASgJUhNnYXR0U2VydmljZUhhc2hVdWlkEhsKCWhhc2hfdXVpZBgDIAEoCVIIaGFzaFV1aWQSFAoFdmFsdWUYBCABKAxSBXZhbHVlEikKEHdpdGhvdXRfcmVzcG9uc2UYBSABKAhSD3dpdGhvdXRSZXNwb25zZQ==');
@$core.Deprecated('Use gattCharacteristicNotifyCommandDescriptor instead')
const GattCharacteristicNotifyCommand$json = const {
  '1': 'GattCharacteristicNotifyCommand',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'state', '3': 4, '4': 1, '5': 8, '10': 'state'},
  ],
};

/// Descriptor for `GattCharacteristicNotifyCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicNotifyCommandDescriptor = $convert.base64Decode('Ch9HYXR0Q2hhcmFjdGVyaXN0aWNOb3RpZnlDb21tYW5kEiQKDmdhdHRfaGFzaF91dWlkGAEgASgJUgxnYXR0SGFzaFV1aWQSMwoWZ2F0dF9zZXJ2aWNlX2hhc2hfdXVpZBgCIAEoCVITZ2F0dFNlcnZpY2VIYXNoVXVpZBIbCgloYXNoX3V1aWQYAyABKAlSCGhhc2hVdWlkEhQKBXN0YXRlGAQgASgIUgVzdGF0ZQ==');
@$core.Deprecated('Use gattDescriptorReadCommandDescriptor instead')
const GattDescriptorReadCommand$json = const {
  '1': 'GattDescriptorReadCommand',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'gatt_characteristic_hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'gattCharacteristicHashUuid'},
    const {'1': 'hash_uuid', '3': 4, '4': 1, '5': 9, '10': 'hashUuid'},
  ],
};

/// Descriptor for `GattDescriptorReadCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorReadCommandDescriptor = $convert.base64Decode('ChlHYXR0RGVzY3JpcHRvclJlYWRDb21tYW5kEiQKDmdhdHRfaGFzaF91dWlkGAEgASgJUgxnYXR0SGFzaFV1aWQSMwoWZ2F0dF9zZXJ2aWNlX2hhc2hfdXVpZBgCIAEoCVITZ2F0dFNlcnZpY2VIYXNoVXVpZBJBCh1nYXR0X2NoYXJhY3RlcmlzdGljX2hhc2hfdXVpZBgDIAEoCVIaZ2F0dENoYXJhY3RlcmlzdGljSGFzaFV1aWQSGwoJaGFzaF91dWlkGAQgASgJUghoYXNoVXVpZA==');
@$core.Deprecated('Use gattDescriptorWriteCommandDescriptor instead')
const GattDescriptorWriteCommand$json = const {
  '1': 'GattDescriptorWriteCommand',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'gatt_characteristic_hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'gattCharacteristicHashUuid'},
    const {'1': 'hash_uuid', '3': 4, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'value', '3': 5, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattDescriptorWriteCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorWriteCommandDescriptor = $convert.base64Decode('ChpHYXR0RGVzY3JpcHRvcldyaXRlQ29tbWFuZBIkCg5nYXR0X2hhc2hfdXVpZBgBIAEoCVIMZ2F0dEhhc2hVdWlkEjMKFmdhdHRfc2VydmljZV9oYXNoX3V1aWQYAiABKAlSE2dhdHRTZXJ2aWNlSGFzaFV1aWQSQQodZ2F0dF9jaGFyYWN0ZXJpc3RpY19oYXNoX3V1aWQYAyABKAlSGmdhdHRDaGFyYWN0ZXJpc3RpY0hhc2hVdWlkEhsKCWhhc2hfdXVpZBgEIAEoCVIIaGFzaFV1aWQSFAoFdmFsdWUYBSABKAxSBXZhbHVl');
@$core.Deprecated('Use centralConnectReplyDescriptor instead')
const CentralConnectReply$json = const {
  '1': 'CentralConnectReply',
  '2': const [
    const {'1': 'gatt', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GATT', '10': 'gatt'},
  ],
};

/// Descriptor for `CentralConnectReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralConnectReplyDescriptor = $convert.base64Decode('ChNDZW50cmFsQ29ubmVjdFJlcGx5Ej4KBGdhdHQYASABKAsyKi5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR0FUVFIEZ2F0dA==');
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.EventCategory', '10': 'category'},
    const {'1': 'bluetooth_state_changed_event', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.BluetoothStateChangedEvent', '9': 0, '10': 'bluetoothStateChangedEvent'},
    const {'1': 'central_discovered_event', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralDiscoveredEvent', '9': 0, '10': 'centralDiscoveredEvent'},
    const {'1': 'gatt_connection_lost_event', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattConnectionLostEvent', '9': 0, '10': 'gattConnectionLostEvent'},
    const {'1': 'gatt_characteristic_value_changed_event', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueChangedEvent', '9': 0, '10': 'gattCharacteristicValueChangedEvent'},
  ],
  '8': const [
    const {'1': 'stub'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode('CgVFdmVudBJPCghjYXRlZ29yeRgBIAEoDjIzLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5FdmVudENhdGVnb3J5UghjYXRlZ29yeRKFAQodYmx1ZXRvb3RoX3N0YXRlX2NoYW5nZWRfZXZlbnQYAiABKAsyQC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQmx1ZXRvb3RoU3RhdGVDaGFuZ2VkRXZlbnRIAFIaYmx1ZXRvb3RoU3RhdGVDaGFuZ2VkRXZlbnQSeAoYY2VudHJhbF9kaXNjb3ZlcmVkX2V2ZW50GAMgASgLMjwuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkNlbnRyYWxEaXNjb3ZlcmVkRXZlbnRIAFIWY2VudHJhbERpc2NvdmVyZWRFdmVudBJ8ChpnYXR0X2Nvbm5lY3Rpb25fbG9zdF9ldmVudBgEIAEoCzI9LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q29ubmVjdGlvbkxvc3RFdmVudEgAUhdnYXR0Q29ubmVjdGlvbkxvc3RFdmVudBKhAQonZ2F0dF9jaGFyYWN0ZXJpc3RpY192YWx1ZV9jaGFuZ2VkX2V2ZW50GAUgASgLMkkuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRDaGFyYWN0ZXJpc3RpY1ZhbHVlQ2hhbmdlZEV2ZW50SABSI2dhdHRDaGFyYWN0ZXJpc3RpY1ZhbHVlQ2hhbmdlZEV2ZW50QgYKBHN0dWI=');
@$core.Deprecated('Use bluetoothStateChangedEventDescriptor instead')
const BluetoothStateChangedEvent$json = const {
  '1': 'BluetoothStateChangedEvent',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.BluetoothState', '10': 'state'},
  ],
};

/// Descriptor for `BluetoothStateChangedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothStateChangedEventDescriptor = $convert.base64Decode('ChpCbHVldG9vdGhTdGF0ZUNoYW5nZWRFdmVudBJKCgVzdGF0ZRgBIAEoDjI0LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5CbHVldG9vdGhTdGF0ZVIFc3RhdGU=');
@$core.Deprecated('Use centralDiscoveredEventDescriptor instead')
const CentralDiscoveredEvent$json = const {
  '1': 'CentralDiscoveredEvent',
  '2': const [
    const {'1': 'peripheral_discovery', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.PeripheralDiscovery', '10': 'peripheralDiscovery'},
  ],
};

/// Descriptor for `CentralDiscoveredEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralDiscoveredEventDescriptor = $convert.base64Decode('ChZDZW50cmFsRGlzY292ZXJlZEV2ZW50EmwKFHBlcmlwaGVyYWxfZGlzY292ZXJ5GAEgASgLMjkuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LlBlcmlwaGVyYWxEaXNjb3ZlcnlSE3BlcmlwaGVyYWxEaXNjb3Zlcnk=');
@$core.Deprecated('Use gattConnectionLostEventDescriptor instead')
const GattConnectionLostEvent$json = const {
  '1': 'GattConnectionLostEvent',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `GattConnectionLostEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattConnectionLostEventDescriptor = $convert.base64Decode('ChdHYXR0Q29ubmVjdGlvbkxvc3RFdmVudBIbCgloYXNoX3V1aWQYASABKAlSCGhhc2hVdWlkEhQKBWVycm9yGAIgASgJUgVlcnJvcg==');
@$core.Deprecated('Use gattCharacteristicValueChangedEventDescriptor instead')
const GattCharacteristicValueChangedEvent$json = const {
  '1': 'GattCharacteristicValueChangedEvent',
  '2': const [
    const {'1': 'gatt_hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'gattHashUuid'},
    const {'1': 'gatt_service_hash_uuid', '3': 2, '4': 1, '5': 9, '10': 'gattServiceHashUuid'},
    const {'1': 'hash_uuid', '3': 3, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattCharacteristicValueChangedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicValueChangedEventDescriptor = $convert.base64Decode('CiNHYXR0Q2hhcmFjdGVyaXN0aWNWYWx1ZUNoYW5nZWRFdmVudBIkCg5nYXR0X2hhc2hfdXVpZBgBIAEoCVIMZ2F0dEhhc2hVdWlkEjMKFmdhdHRfc2VydmljZV9oYXNoX3V1aWQYAiABKAlSE2dhdHRTZXJ2aWNlSGFzaFV1aWQSGwoJaGFzaF91dWlkGAMgASgJUghoYXNoVXVpZBIUCgV2YWx1ZRgEIAEoDFIFdmFsdWU=');
@$core.Deprecated('Use gATTDescriptor instead')
const GATT$json = const {
  '1': 'GATT',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'maximum_write_length', '3': 2, '4': 1, '5': 5, '10': 'maximumWriteLength'},
    const {'1': 'services', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattService', '10': 'services'},
  ],
};

/// Descriptor for `GATT`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gATTDescriptor = $convert.base64Decode('CgRHQVRUEhsKCWhhc2hfdXVpZBgBIAEoCVIIaGFzaFV1aWQSMAoUbWF4aW11bV93cml0ZV9sZW5ndGgYAiABKAVSEm1heGltdW1Xcml0ZUxlbmd0aBJNCghzZXJ2aWNlcxgDIAMoCzIxLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0U2VydmljZVIIc2VydmljZXM=');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'characteristics', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIbCgloYXNoX3V1aWQYASABKAlSCGhhc2hVdWlkEhIKBHV1aWQYAiABKAlSBHV1aWQSYgoPY2hhcmFjdGVyaXN0aWNzGAMgAygLMjguZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRDaGFyYWN0ZXJpc3RpY1IPY2hhcmFjdGVyaXN0aWNz');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'can_read', '3': 3, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'can_write', '3': 4, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'can_write_without_response', '3': 5, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'can_notify', '3': 6, '4': 1, '5': 8, '10': 'canNotify'},
    const {'1': 'descriptors', '3': 7, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptor', '10': 'descriptors'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSGwoJaGFzaF91dWlkGAEgASgJUghoYXNoVXVpZBISCgR1dWlkGAIgASgJUgR1dWlkEhkKCGNhbl9yZWFkGAMgASgIUgdjYW5SZWFkEhsKCWNhbl93cml0ZRgEIAEoCFIIY2FuV3JpdGUSOwoaY2FuX3dyaXRlX3dpdGhvdXRfcmVzcG9uc2UYBSABKAhSF2NhbldyaXRlV2l0aG91dFJlc3BvbnNlEh0KCmNhbl9ub3RpZnkYBiABKAhSCWNhbk5vdGlmeRJWCgtkZXNjcmlwdG9ycxgHIAMoCzI0LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0RGVzY3JpcHRvclILZGVzY3JpcHRvcnM=');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'hash_uuid', '3': 1, '4': 1, '5': 9, '10': 'hashUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchIbCgloYXNoX3V1aWQYASABKAlSCGhhc2hVdWlkEhIKBHV1aWQYAiABKAlSBHV1aWQ=');
@$core.Deprecated('Use peripheralDiscoveryDescriptor instead')
const PeripheralDiscovery$json = const {
  '1': 'PeripheralDiscovery',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 17, '10': 'rssi'},
    const {'1': 'advertisements', '3': 3, '4': 1, '5': 12, '10': 'advertisements'},
    const {'1': 'connectable', '3': 4, '4': 1, '5': 8, '10': 'connectable'},
  ],
};

/// Descriptor for `PeripheralDiscovery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peripheralDiscoveryDescriptor = $convert.base64Decode('ChNQZXJpcGhlcmFsRGlzY292ZXJ5EhIKBHV1aWQYASABKAlSBHV1aWQSEgoEcnNzaRgCIAEoEVIEcnNzaRImCg5hZHZlcnRpc2VtZW50cxgDIAEoDFIOYWR2ZXJ0aXNlbWVudHMSIAoLY29ubmVjdGFibGUYBCABKAhSC2Nvbm5lY3RhYmxl');
