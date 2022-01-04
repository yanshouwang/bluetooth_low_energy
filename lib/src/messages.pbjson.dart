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
    const {'1': 'central_start_discovery_arguments', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralStartDiscoveryArguments', '9': 0, '10': 'centralStartDiscoveryArguments'},
    const {'1': 'central_connect_arguments', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralConnectArguments', '9': 0, '10': 'centralConnectArguments'},
    const {'1': 'gatt_disconnect_arguments', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDisconnectArguments', '9': 0, '10': 'gattDisconnectArguments'},
    const {'1': 'characteristic_read_arguments', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicReadArguments', '9': 0, '10': 'characteristicReadArguments'},
    const {'1': 'characteristic_write_arguments', '3': 6, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicWriteArguments', '9': 0, '10': 'characteristicWriteArguments'},
    const {'1': 'characteristic_notify_arguments', '3': 7, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicNotifyArguments', '9': 0, '10': 'characteristicNotifyArguments'},
    const {'1': 'descriptor_read_arguments', '3': 8, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptorReadArguments', '9': 0, '10': 'descriptorReadArguments'},
    const {'1': 'descriptor_write_arguments', '3': 9, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptorWriteArguments', '9': 0, '10': 'descriptorWriteArguments'},
  ],
  '8': const [
    const {'1': 'arguments'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode('CgdDb21tYW5kElEKCGNhdGVnb3J5GAEgASgOMjUuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkNvbW1hbmRDYXRlZ29yeVIIY2F0ZWdvcnkSkQEKIWNlbnRyYWxfc3RhcnRfZGlzY292ZXJ5X2FyZ3VtZW50cxgCIAEoCzJELmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5DZW50cmFsU3RhcnREaXNjb3ZlcnlBcmd1bWVudHNIAFIeY2VudHJhbFN0YXJ0RGlzY292ZXJ5QXJndW1lbnRzEnsKGWNlbnRyYWxfY29ubmVjdF9hcmd1bWVudHMYAyABKAsyPS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQ2VudHJhbENvbm5lY3RBcmd1bWVudHNIAFIXY2VudHJhbENvbm5lY3RBcmd1bWVudHMSewoZZ2F0dF9kaXNjb25uZWN0X2FyZ3VtZW50cxgEIAEoCzI9LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0RGlzY29ubmVjdEFyZ3VtZW50c0gAUhdnYXR0RGlzY29ubmVjdEFyZ3VtZW50cxKLAQodY2hhcmFjdGVyaXN0aWNfcmVhZF9hcmd1bWVudHMYBSABKAsyRS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dENoYXJhY3RlcmlzdGljUmVhZEFyZ3VtZW50c0gAUhtjaGFyYWN0ZXJpc3RpY1JlYWRBcmd1bWVudHMSjgEKHmNoYXJhY3RlcmlzdGljX3dyaXRlX2FyZ3VtZW50cxgGIAEoCzJGLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q2hhcmFjdGVyaXN0aWNXcml0ZUFyZ3VtZW50c0gAUhxjaGFyYWN0ZXJpc3RpY1dyaXRlQXJndW1lbnRzEpEBCh9jaGFyYWN0ZXJpc3RpY19ub3RpZnlfYXJndW1lbnRzGAcgASgLMkcuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRDaGFyYWN0ZXJpc3RpY05vdGlmeUFyZ3VtZW50c0gAUh1jaGFyYWN0ZXJpc3RpY05vdGlmeUFyZ3VtZW50cxJ/ChlkZXNjcmlwdG9yX3JlYWRfYXJndW1lbnRzGAggASgLMkEuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHREZXNjcmlwdG9yUmVhZEFyZ3VtZW50c0gAUhdkZXNjcmlwdG9yUmVhZEFyZ3VtZW50cxKCAQoaZGVzY3JpcHRvcl93cml0ZV9hcmd1bWVudHMYCSABKAsyQi5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuR2F0dERlc2NyaXB0b3JXcml0ZUFyZ3VtZW50c0gAUhhkZXNjcmlwdG9yV3JpdGVBcmd1bWVudHNCCwoJYXJndW1lbnRz');
@$core.Deprecated('Use centralStartDiscoveryArgumentsDescriptor instead')
const CentralStartDiscoveryArguments$json = const {
  '1': 'CentralStartDiscoveryArguments',
  '2': const [
    const {'1': 'uuids', '3': 1, '4': 3, '5': 9, '10': 'uuids'},
  ],
};

/// Descriptor for `CentralStartDiscoveryArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralStartDiscoveryArgumentsDescriptor = $convert.base64Decode('Ch5DZW50cmFsU3RhcnREaXNjb3ZlcnlBcmd1bWVudHMSFAoFdXVpZHMYASADKAlSBXV1aWRz');
@$core.Deprecated('Use centralConnectArgumentsDescriptor instead')
const CentralConnectArguments$json = const {
  '1': 'CentralConnectArguments',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `CentralConnectArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralConnectArgumentsDescriptor = $convert.base64Decode('ChdDZW50cmFsQ29ubmVjdEFyZ3VtZW50cxISCgR1dWlkGAEgASgJUgR1dWlk');
@$core.Deprecated('Use gattDisconnectArgumentsDescriptor instead')
const GattDisconnectArguments$json = const {
  '1': 'GattDisconnectArguments',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
  ],
};

/// Descriptor for `GattDisconnectArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDisconnectArgumentsDescriptor = $convert.base64Decode('ChdHYXR0RGlzY29ubmVjdEFyZ3VtZW50cxIhCgxpbmRleGVkX3V1aWQYASABKAlSC2luZGV4ZWRVdWlk');
@$core.Deprecated('Use gattCharacteristicReadArgumentsDescriptor instead')
const GattCharacteristicReadArguments$json = const {
  '1': 'GattCharacteristicReadArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedUuid'},
  ],
};

/// Descriptor for `GattCharacteristicReadArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicReadArgumentsDescriptor = $convert.base64Decode('Ch9HYXR0Q2hhcmFjdGVyaXN0aWNSZWFkQXJndW1lbnRzEioKEWluZGV4ZWRfZ2F0dF91dWlkGAEgASgJUg9pbmRleGVkR2F0dFV1aWQSMAoUaW5kZXhlZF9zZXJ2aWNlX3V1aWQYAiABKAlSEmluZGV4ZWRTZXJ2aWNlVXVpZBIhCgxpbmRleGVkX3V1aWQYAyABKAlSC2luZGV4ZWRVdWlk');
@$core.Deprecated('Use gattCharacteristicWriteArgumentsDescriptor instead')
const GattCharacteristicWriteArguments$json = const {
  '1': 'GattCharacteristicWriteArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'without_response', '3': 5, '4': 1, '5': 8, '10': 'withoutResponse'},
  ],
};

/// Descriptor for `GattCharacteristicWriteArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicWriteArgumentsDescriptor = $convert.base64Decode('CiBHYXR0Q2hhcmFjdGVyaXN0aWNXcml0ZUFyZ3VtZW50cxIqChFpbmRleGVkX2dhdHRfdXVpZBgBIAEoCVIPaW5kZXhlZEdhdHRVdWlkEjAKFGluZGV4ZWRfc2VydmljZV91dWlkGAIgASgJUhJpbmRleGVkU2VydmljZVV1aWQSIQoMaW5kZXhlZF91dWlkGAMgASgJUgtpbmRleGVkVXVpZBIUCgV2YWx1ZRgEIAEoDFIFdmFsdWUSKQoQd2l0aG91dF9yZXNwb25zZRgFIAEoCFIPd2l0aG91dFJlc3BvbnNl');
@$core.Deprecated('Use gattCharacteristicNotifyArgumentsDescriptor instead')
const GattCharacteristicNotifyArguments$json = const {
  '1': 'GattCharacteristicNotifyArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'state', '3': 4, '4': 1, '5': 8, '10': 'state'},
  ],
};

/// Descriptor for `GattCharacteristicNotifyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicNotifyArgumentsDescriptor = $convert.base64Decode('CiFHYXR0Q2hhcmFjdGVyaXN0aWNOb3RpZnlBcmd1bWVudHMSKgoRaW5kZXhlZF9nYXR0X3V1aWQYASABKAlSD2luZGV4ZWRHYXR0VXVpZBIwChRpbmRleGVkX3NlcnZpY2VfdXVpZBgCIAEoCVISaW5kZXhlZFNlcnZpY2VVdWlkEiEKDGluZGV4ZWRfdXVpZBgDIAEoCVILaW5kZXhlZFV1aWQSFAoFc3RhdGUYBCABKAhSBXN0YXRl');
@$core.Deprecated('Use gattDescriptorReadArgumentsDescriptor instead')
const GattDescriptorReadArguments$json = const {
  '1': 'GattDescriptorReadArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_characteristic_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedCharacteristicUuid'},
    const {'1': 'indexed_uuid', '3': 4, '4': 1, '5': 9, '10': 'indexedUuid'},
  ],
};

/// Descriptor for `GattDescriptorReadArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorReadArgumentsDescriptor = $convert.base64Decode('ChtHYXR0RGVzY3JpcHRvclJlYWRBcmd1bWVudHMSKgoRaW5kZXhlZF9nYXR0X3V1aWQYASABKAlSD2luZGV4ZWRHYXR0VXVpZBIwChRpbmRleGVkX3NlcnZpY2VfdXVpZBgCIAEoCVISaW5kZXhlZFNlcnZpY2VVdWlkEj4KG2luZGV4ZWRfY2hhcmFjdGVyaXN0aWNfdXVpZBgDIAEoCVIZaW5kZXhlZENoYXJhY3RlcmlzdGljVXVpZBIhCgxpbmRleGVkX3V1aWQYBCABKAlSC2luZGV4ZWRVdWlk');
@$core.Deprecated('Use gattDescriptorWriteArgumentsDescriptor instead')
const GattDescriptorWriteArguments$json = const {
  '1': 'GattDescriptorWriteArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_characteristic_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedCharacteristicUuid'},
    const {'1': 'indexed_uuid', '3': 4, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'value', '3': 5, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattDescriptorWriteArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorWriteArgumentsDescriptor = $convert.base64Decode('ChxHYXR0RGVzY3JpcHRvcldyaXRlQXJndW1lbnRzEioKEWluZGV4ZWRfZ2F0dF91dWlkGAEgASgJUg9pbmRleGVkR2F0dFV1aWQSMAoUaW5kZXhlZF9zZXJ2aWNlX3V1aWQYAiABKAlSEmluZGV4ZWRTZXJ2aWNlVXVpZBI+ChtpbmRleGVkX2NoYXJhY3RlcmlzdGljX3V1aWQYAyABKAlSGWluZGV4ZWRDaGFyYWN0ZXJpc3RpY1V1aWQSIQoMaW5kZXhlZF91dWlkGAQgASgJUgtpbmRleGVkVXVpZBIUCgV2YWx1ZRgFIAEoDFIFdmFsdWU=');
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.EventCategory', '10': 'category'},
    const {'1': 'bluetooth_state_changed_arguments', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.BluetoothStateChangedArguments', '9': 0, '10': 'bluetoothStateChangedArguments'},
    const {'1': 'central_discovered_arguments', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.CentralDiscoveredArguments', '9': 0, '10': 'centralDiscoveredArguments'},
    const {'1': 'gatt_connection_lost_arguments', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattConnectionLostArguments', '9': 0, '10': 'gattConnectionLostArguments'},
    const {'1': 'characteristic_value_changed_arguments', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristicValueChangedArguments', '9': 0, '10': 'characteristicValueChangedArguments'},
  ],
  '8': const [
    const {'1': 'arguments'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode('CgVFdmVudBJPCghjYXRlZ29yeRgBIAEoDjIzLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5FdmVudENhdGVnb3J5UghjYXRlZ29yeRKRAQohYmx1ZXRvb3RoX3N0YXRlX2NoYW5nZWRfYXJndW1lbnRzGAIgASgLMkQuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkJsdWV0b290aFN0YXRlQ2hhbmdlZEFyZ3VtZW50c0gAUh5ibHVldG9vdGhTdGF0ZUNoYW5nZWRBcmd1bWVudHMShAEKHGNlbnRyYWxfZGlzY292ZXJlZF9hcmd1bWVudHMYAyABKAsyQC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQ2VudHJhbERpc2NvdmVyZWRBcmd1bWVudHNIAFIaY2VudHJhbERpc2NvdmVyZWRBcmd1bWVudHMSiAEKHmdhdHRfY29ubmVjdGlvbl9sb3N0X2FyZ3VtZW50cxgEIAEoCzJBLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q29ubmVjdGlvbkxvc3RBcmd1bWVudHNIAFIbZ2F0dENvbm5lY3Rpb25Mb3N0QXJndW1lbnRzEqQBCiZjaGFyYWN0ZXJpc3RpY192YWx1ZV9jaGFuZ2VkX2FyZ3VtZW50cxgFIAEoCzJNLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0Q2hhcmFjdGVyaXN0aWNWYWx1ZUNoYW5nZWRBcmd1bWVudHNIAFIjY2hhcmFjdGVyaXN0aWNWYWx1ZUNoYW5nZWRBcmd1bWVudHNCCwoJYXJndW1lbnRz');
@$core.Deprecated('Use bluetoothStateChangedArgumentsDescriptor instead')
const BluetoothStateChangedArguments$json = const {
  '1': 'BluetoothStateChangedArguments',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.BluetoothState', '10': 'state'},
  ],
};

/// Descriptor for `BluetoothStateChangedArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothStateChangedArgumentsDescriptor = $convert.base64Decode('Ch5CbHVldG9vdGhTdGF0ZUNoYW5nZWRBcmd1bWVudHMSSgoFc3RhdGUYASABKA4yNC5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuQmx1ZXRvb3RoU3RhdGVSBXN0YXRl');
@$core.Deprecated('Use centralDiscoveredArgumentsDescriptor instead')
const CentralDiscoveredArguments$json = const {
  '1': 'CentralDiscoveredArguments',
  '2': const [
    const {'1': 'discovery', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.PeripheralDiscovery', '10': 'discovery'},
  ],
};

/// Descriptor for `CentralDiscoveredArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralDiscoveredArgumentsDescriptor = $convert.base64Decode('ChpDZW50cmFsRGlzY292ZXJlZEFyZ3VtZW50cxJXCglkaXNjb3ZlcnkYASABKAsyOS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kuUGVyaXBoZXJhbERpc2NvdmVyeVIJZGlzY292ZXJ5');
@$core.Deprecated('Use gattConnectionLostArgumentsDescriptor instead')
const GattConnectionLostArguments$json = const {
  '1': 'GattConnectionLostArguments',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `GattConnectionLostArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattConnectionLostArgumentsDescriptor = $convert.base64Decode('ChtHYXR0Q29ubmVjdGlvbkxvc3RBcmd1bWVudHMSIQoMaW5kZXhlZF91dWlkGAEgASgJUgtpbmRleGVkVXVpZBIUCgVlcnJvchgCIAEoCVIFZXJyb3I=');
@$core.Deprecated('Use gattCharacteristicValueChangedArgumentsDescriptor instead')
const GattCharacteristicValueChangedArguments$json = const {
  '1': 'GattCharacteristicValueChangedArguments',
  '2': const [
    const {'1': 'indexed_gatt_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedGattUuid'},
    const {'1': 'indexed_service_uuid', '3': 2, '4': 1, '5': 9, '10': 'indexedServiceUuid'},
    const {'1': 'indexed_uuid', '3': 3, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `GattCharacteristicValueChangedArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicValueChangedArgumentsDescriptor = $convert.base64Decode('CidHYXR0Q2hhcmFjdGVyaXN0aWNWYWx1ZUNoYW5nZWRBcmd1bWVudHMSKgoRaW5kZXhlZF9nYXR0X3V1aWQYASABKAlSD2luZGV4ZWRHYXR0VXVpZBIwChRpbmRleGVkX3NlcnZpY2VfdXVpZBgCIAEoCVISaW5kZXhlZFNlcnZpY2VVdWlkEiEKDGluZGV4ZWRfdXVpZBgDIAEoCVILaW5kZXhlZFV1aWQSFAoFdmFsdWUYBCABKAxSBXZhbHVl');
@$core.Deprecated('Use gATTDescriptor instead')
const GATT$json = const {
  '1': 'GATT',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'maximum_write_length', '3': 2, '4': 1, '5': 5, '10': 'maximumWriteLength'},
    const {'1': 'services', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattService', '10': 'services'},
  ],
};

/// Descriptor for `GATT`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gATTDescriptor = $convert.base64Decode('CgRHQVRUEiEKDGluZGV4ZWRfdXVpZBgBIAEoCVILaW5kZXhlZFV1aWQSMAoUbWF4aW11bV93cml0ZV9sZW5ndGgYAiABKAVSEm1heGltdW1Xcml0ZUxlbmd0aBJNCghzZXJ2aWNlcxgDIAMoCzIxLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0U2VydmljZVIIc2VydmljZXM=');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'characteristics', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIhCgxpbmRleGVkX3V1aWQYASABKAlSC2luZGV4ZWRVdWlkEhIKBHV1aWQYAiABKAlSBHV1aWQSYgoPY2hhcmFjdGVyaXN0aWNzGAMgAygLMjguZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5LkdhdHRDaGFyYWN0ZXJpc3RpY1IPY2hhcmFjdGVyaXN0aWNz');
@$core.Deprecated('Use gattCharacteristicDescriptor instead')
const GattCharacteristic$json = const {
  '1': 'GattCharacteristic',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'can_read', '3': 3, '4': 1, '5': 8, '10': 'canRead'},
    const {'1': 'can_write', '3': 4, '4': 1, '5': 8, '10': 'canWrite'},
    const {'1': 'can_write_without_response', '3': 5, '4': 1, '5': 8, '10': 'canWriteWithoutResponse'},
    const {'1': 'can_notify', '3': 6, '4': 1, '5': 8, '10': 'canNotify'},
    const {'1': 'descriptors', '3': 7, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.GattDescriptor', '10': 'descriptors'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSIQoMaW5kZXhlZF91dWlkGAEgASgJUgtpbmRleGVkVXVpZBISCgR1dWlkGAIgASgJUgR1dWlkEhkKCGNhbl9yZWFkGAMgASgIUgdjYW5SZWFkEhsKCWNhbl93cml0ZRgEIAEoCFIIY2FuV3JpdGUSOwoaY2FuX3dyaXRlX3dpdGhvdXRfcmVzcG9uc2UYBSABKAhSF2NhbldyaXRlV2l0aG91dFJlc3BvbnNlEh0KCmNhbl9ub3RpZnkYBiABKAhSCWNhbk5vdGlmeRJWCgtkZXNjcmlwdG9ycxgHIAMoCzI0LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5HYXR0RGVzY3JpcHRvclILZGVzY3JpcHRvcnM=');
@$core.Deprecated('Use gattDescriptorDescriptor instead')
const GattDescriptor$json = const {
  '1': 'GattDescriptor',
  '2': const [
    const {'1': 'indexed_uuid', '3': 1, '4': 1, '5': 9, '10': 'indexedUuid'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `GattDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDescriptorDescriptor = $convert.base64Decode('Cg5HYXR0RGVzY3JpcHRvchIhCgxpbmRleGVkX3V1aWQYASABKAlSC2luZGV4ZWRVdWlkEhIKBHV1aWQYAiABKAlSBHV1aWQ=');
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
