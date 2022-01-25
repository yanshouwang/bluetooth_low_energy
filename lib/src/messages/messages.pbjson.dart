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
    const {'1': 'COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED', '2': 1},
    const {'1': 'COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED', '2': 2},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_START_DISCOVERY', '2': 3},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY', '2': 4},
    const {'1': 'COMMAND_CATEGORY_CENTRAL_CONNECT', '2': 5},
    const {'1': 'COMMAND_CATEGORY_GATT_DISCONNECT', '2': 6},
    const {'1': 'COMMAND_CATEGORY_CHARACTERISTIC_READ', '2': 7},
    const {'1': 'COMMAND_CATEGORY_CHARACTERISTIC_WRITE', '2': 8},
    const {'1': 'COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY', '2': 9},
    const {'1': 'COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY', '2': 10},
    const {'1': 'COMMAND_CATEGORY_DESCRIPTOR_READ', '2': 11},
    const {'1': 'COMMAND_CATEGORY_DESCRIPTOR_WRITE', '2': 12},
  ],
};

/// Descriptor for `CommandCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commandCategoryDescriptor = $convert.base64Decode('Cg9Db21tYW5kQ2F0ZWdvcnkSKAokQ09NTUFORF9DQVRFR09SWV9CTFVFVE9PVEhfR0VUX1NUQVRFEAASMwovQ09NTUFORF9DQVRFR09SWV9CTFVFVE9PVEhfTElTVEVOX1NUQVRFX0NIQU5HRUQQARIzCi9DT01NQU5EX0NBVEVHT1JZX0JMVUVUT09USF9DQU5DRUxfU1RBVEVfQ0hBTkdFRBACEiwKKENPTU1BTkRfQ0FURUdPUllfQ0VOVFJBTF9TVEFSVF9ESVNDT1ZFUlkQAxIrCidDT01NQU5EX0NBVEVHT1JZX0NFTlRSQUxfU1RPUF9ESVNDT1ZFUlkQBBIkCiBDT01NQU5EX0NBVEVHT1JZX0NFTlRSQUxfQ09OTkVDVBAFEiQKIENPTU1BTkRfQ0FURUdPUllfR0FUVF9ESVNDT05ORUNUEAYSKAokQ09NTUFORF9DQVRFR09SWV9DSEFSQUNURVJJU1RJQ19SRUFEEAcSKQolQ09NTUFORF9DQVRFR09SWV9DSEFSQUNURVJJU1RJQ19XUklURRAIEioKJkNPTU1BTkRfQ0FURUdPUllfQ0hBUkFDVEVSSVNUSUNfTk9USUZZEAkSMQotQ09NTUFORF9DQVRFR09SWV9DSEFSQUNURVJJU1RJQ19DQU5DRUxfTk9USUZZEAoSJAogQ09NTUFORF9DQVRFR09SWV9ERVNDUklQVE9SX1JFQUQQCxIlCiFDT01NQU5EX0NBVEVHT1JZX0RFU0NSSVBUT1JfV1JJVEUQDA==');
@$core.Deprecated('Use eventCategoryDescriptor instead')
const EventCategory$json = const {
  '1': 'EventCategory',
  '2': const [
    const {'1': 'EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED', '2': 0},
    const {'1': 'EVENT_CATEGORY_CENTRAL_DISCOVERED', '2': 1},
    const {'1': 'EVENT_CATEGORY_GATT_CONNECTION_LOST', '2': 2},
    const {'1': 'EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED', '2': 3},
  ],
};

/// Descriptor for `EventCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventCategoryDescriptor = $convert.base64Decode('Cg1FdmVudENhdGVnb3J5EioKJkVWRU5UX0NBVEVHT1JZX0JMVUVUT09USF9TVEFURV9DSEFOR0VEEAASJQohRVZFTlRfQ0FURUdPUllfQ0VOVFJBTF9ESVNDT1ZFUkVEEAESJwojRVZFTlRfQ0FURUdPUllfR0FUVF9DT05ORUNUSU9OX0xPU1QQAhIqCiZFVkVOVF9DQVRFR09SWV9DSEFSQUNURVJJU1RJQ19OT1RJRklFRBAD');
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
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CommandCategory', '10': 'category'},
    const {'1': 'central_start_discovery_arguments', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CentralStartDiscoveryCommandArguments', '9': 0, '10': 'centralStartDiscoveryArguments'},
    const {'1': 'central_connect_arguments', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CentralConnectCommandArguments', '9': 0, '10': 'centralConnectArguments'},
    const {'1': 'gatt_disconnect_arguments', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GattDisconnectCommandArguments', '9': 0, '10': 'gattDisconnectArguments'},
    const {'1': 'characteristic_read_arguments', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicReadCommandArguments', '9': 0, '10': 'characteristicReadArguments'},
    const {'1': 'characteristic_write_arguments', '3': 6, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicWriteCommandArguments', '9': 0, '10': 'characteristicWriteArguments'},
    const {'1': 'characteristic_notify_arguments', '3': 7, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicNotifyCommandArguments', '9': 0, '10': 'characteristicNotifyArguments'},
    const {'1': 'characteristic_cancel_notify_arguments', '3': 8, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicCancelNotifyCommandArguments', '9': 0, '10': 'characteristicCancelNotifyArguments'},
    const {'1': 'descriptor_read_arguments', '3': 9, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.DescriptorReadCommandArguments', '9': 0, '10': 'descriptorReadArguments'},
    const {'1': 'descriptor_write_arguments', '3': 10, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.DescriptorWriteCommandArguments', '9': 0, '10': 'descriptorWriteArguments'},
  ],
  '8': const [
    const {'1': 'command'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode('CgdDb21tYW5kEloKCGNhdGVnb3J5GAEgASgOMj4uZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkNvbW1hbmRDYXRlZ29yeVIIY2F0ZWdvcnkSoQEKIWNlbnRyYWxfc3RhcnRfZGlzY292ZXJ5X2FyZ3VtZW50cxgCIAEoCzJULmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DZW50cmFsU3RhcnREaXNjb3ZlcnlDb21tYW5kQXJndW1lbnRzSABSHmNlbnRyYWxTdGFydERpc2NvdmVyeUFyZ3VtZW50cxKLAQoZY2VudHJhbF9jb25uZWN0X2FyZ3VtZW50cxgDIAEoCzJNLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DZW50cmFsQ29ubmVjdENvbW1hbmRBcmd1bWVudHNIAFIXY2VudHJhbENvbm5lY3RBcmd1bWVudHMSiwEKGWdhdHRfZGlzY29ubmVjdF9hcmd1bWVudHMYBCABKAsyTS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuR2F0dERpc2Nvbm5lY3RDb21tYW5kQXJndW1lbnRzSABSF2dhdHREaXNjb25uZWN0QXJndW1lbnRzEpcBCh1jaGFyYWN0ZXJpc3RpY19yZWFkX2FyZ3VtZW50cxgFIAEoCzJRLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DaGFyYWN0ZXJpc3RpY1JlYWRDb21tYW5kQXJndW1lbnRzSABSG2NoYXJhY3RlcmlzdGljUmVhZEFyZ3VtZW50cxKaAQoeY2hhcmFjdGVyaXN0aWNfd3JpdGVfYXJndW1lbnRzGAYgASgLMlIuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkNoYXJhY3RlcmlzdGljV3JpdGVDb21tYW5kQXJndW1lbnRzSABSHGNoYXJhY3RlcmlzdGljV3JpdGVBcmd1bWVudHMSnQEKH2NoYXJhY3RlcmlzdGljX25vdGlmeV9hcmd1bWVudHMYByABKAsyUy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuQ2hhcmFjdGVyaXN0aWNOb3RpZnlDb21tYW5kQXJndW1lbnRzSABSHWNoYXJhY3RlcmlzdGljTm90aWZ5QXJndW1lbnRzErABCiZjaGFyYWN0ZXJpc3RpY19jYW5jZWxfbm90aWZ5X2FyZ3VtZW50cxgIIAEoCzJZLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DaGFyYWN0ZXJpc3RpY0NhbmNlbE5vdGlmeUNvbW1hbmRBcmd1bWVudHNIAFIjY2hhcmFjdGVyaXN0aWNDYW5jZWxOb3RpZnlBcmd1bWVudHMSiwEKGWRlc2NyaXB0b3JfcmVhZF9hcmd1bWVudHMYCSABKAsyTS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuRGVzY3JpcHRvclJlYWRDb21tYW5kQXJndW1lbnRzSABSF2Rlc2NyaXB0b3JSZWFkQXJndW1lbnRzEo4BChpkZXNjcmlwdG9yX3dyaXRlX2FyZ3VtZW50cxgKIAEoCzJOLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5EZXNjcmlwdG9yV3JpdGVDb21tYW5kQXJndW1lbnRzSABSGGRlc2NyaXB0b3JXcml0ZUFyZ3VtZW50c0IJCgdjb21tYW5k');
@$core.Deprecated('Use centralStartDiscoveryCommandArgumentsDescriptor instead')
const CentralStartDiscoveryCommandArguments$json = const {
  '1': 'CentralStartDiscoveryCommandArguments',
  '2': const [
    const {'1': 'uuids', '3': 1, '4': 3, '5': 9, '10': 'uuids'},
  ],
};

/// Descriptor for `CentralStartDiscoveryCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralStartDiscoveryCommandArgumentsDescriptor = $convert.base64Decode('CiVDZW50cmFsU3RhcnREaXNjb3ZlcnlDb21tYW5kQXJndW1lbnRzEhQKBXV1aWRzGAEgAygJUgV1dWlkcw==');
@$core.Deprecated('Use centralConnectCommandArgumentsDescriptor instead')
const CentralConnectCommandArguments$json = const {
  '1': 'CentralConnectCommandArguments',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `CentralConnectCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralConnectCommandArgumentsDescriptor = $convert.base64Decode('Ch5DZW50cmFsQ29ubmVjdENvbW1hbmRBcmd1bWVudHMSEgoEdXVpZBgBIAEoCVIEdXVpZA==');
@$core.Deprecated('Use gattDisconnectCommandArgumentsDescriptor instead')
const GattDisconnectCommandArguments$json = const {
  '1': 'GattDisconnectCommandArguments',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GattDisconnectCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattDisconnectCommandArgumentsDescriptor = $convert.base64Decode('Ch5HYXR0RGlzY29ubmVjdENvbW1hbmRBcmd1bWVudHMSDgoCaWQYASABKAlSAmlk');
@$core.Deprecated('Use characteristicReadCommandArgumentsDescriptor instead')
const CharacteristicReadCommandArguments$json = const {
  '1': 'CharacteristicReadCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CharacteristicReadCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicReadCommandArgumentsDescriptor = $convert.base64Decode('CiJDaGFyYWN0ZXJpc3RpY1JlYWRDb21tYW5kQXJndW1lbnRzEhcKB2dhdHRfaWQYASABKAlSBmdhdHRJZBIdCgpzZXJ2aWNlX2lkGAIgASgJUglzZXJ2aWNlSWQSDgoCaWQYAyABKAlSAmlk');
@$core.Deprecated('Use characteristicWriteCommandArgumentsDescriptor instead')
const CharacteristicWriteCommandArguments$json = const {
  '1': 'CharacteristicWriteCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'without_response', '3': 5, '4': 1, '5': 8, '10': 'withoutResponse'},
  ],
};

/// Descriptor for `CharacteristicWriteCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicWriteCommandArgumentsDescriptor = $convert.base64Decode('CiNDaGFyYWN0ZXJpc3RpY1dyaXRlQ29tbWFuZEFyZ3VtZW50cxIXCgdnYXR0X2lkGAEgASgJUgZnYXR0SWQSHQoKc2VydmljZV9pZBgCIAEoCVIJc2VydmljZUlkEg4KAmlkGAMgASgJUgJpZBIUCgV2YWx1ZRgEIAEoDFIFdmFsdWUSKQoQd2l0aG91dF9yZXNwb25zZRgFIAEoCFIPd2l0aG91dFJlc3BvbnNl');
@$core.Deprecated('Use characteristicNotifyCommandArgumentsDescriptor instead')
const CharacteristicNotifyCommandArguments$json = const {
  '1': 'CharacteristicNotifyCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CharacteristicNotifyCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicNotifyCommandArgumentsDescriptor = $convert.base64Decode('CiRDaGFyYWN0ZXJpc3RpY05vdGlmeUNvbW1hbmRBcmd1bWVudHMSFwoHZ2F0dF9pZBgBIAEoCVIGZ2F0dElkEh0KCnNlcnZpY2VfaWQYAiABKAlSCXNlcnZpY2VJZBIOCgJpZBgDIAEoCVICaWQ=');
@$core.Deprecated('Use characteristicCancelNotifyCommandArgumentsDescriptor instead')
const CharacteristicCancelNotifyCommandArguments$json = const {
  '1': 'CharacteristicCancelNotifyCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CharacteristicCancelNotifyCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicCancelNotifyCommandArgumentsDescriptor = $convert.base64Decode('CipDaGFyYWN0ZXJpc3RpY0NhbmNlbE5vdGlmeUNvbW1hbmRBcmd1bWVudHMSFwoHZ2F0dF9pZBgBIAEoCVIGZ2F0dElkEh0KCnNlcnZpY2VfaWQYAiABKAlSCXNlcnZpY2VJZBIOCgJpZBgDIAEoCVICaWQ=');
@$core.Deprecated('Use descriptorReadCommandArgumentsDescriptor instead')
const DescriptorReadCommandArguments$json = const {
  '1': 'DescriptorReadCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'characteristic_id', '3': 3, '4': 1, '5': 9, '10': 'characteristicId'},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DescriptorReadCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptorReadCommandArgumentsDescriptor = $convert.base64Decode('Ch5EZXNjcmlwdG9yUmVhZENvbW1hbmRBcmd1bWVudHMSFwoHZ2F0dF9pZBgBIAEoCVIGZ2F0dElkEh0KCnNlcnZpY2VfaWQYAiABKAlSCXNlcnZpY2VJZBIrChFjaGFyYWN0ZXJpc3RpY19pZBgDIAEoCVIQY2hhcmFjdGVyaXN0aWNJZBIOCgJpZBgEIAEoCVICaWQ=');
@$core.Deprecated('Use descriptorWriteCommandArgumentsDescriptor instead')
const DescriptorWriteCommandArguments$json = const {
  '1': 'DescriptorWriteCommandArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'characteristic_id', '3': 3, '4': 1, '5': 9, '10': 'characteristicId'},
    const {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'value', '3': 5, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `DescriptorWriteCommandArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptorWriteCommandArgumentsDescriptor = $convert.base64Decode('Ch9EZXNjcmlwdG9yV3JpdGVDb21tYW5kQXJndW1lbnRzEhcKB2dhdHRfaWQYASABKAlSBmdhdHRJZBIdCgpzZXJ2aWNlX2lkGAIgASgJUglzZXJ2aWNlSWQSKwoRY2hhcmFjdGVyaXN0aWNfaWQYAyABKAlSEGNoYXJhY3RlcmlzdGljSWQSDgoCaWQYBCABKAlSAmlkEhQKBXZhbHVlGAUgASgMUgV2YWx1ZQ==');
@$core.Deprecated('Use replyDescriptor instead')
const Reply$json = const {
  '1': 'Reply',
  '2': const [
    const {'1': 'bluetooth_get_state_arguments', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothGetStateReplyArguments', '9': 0, '10': 'bluetoothGetStateArguments'},
    const {'1': 'central_connect_arguments', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CentralConnectReplyArguments', '9': 0, '10': 'centralConnectArguments'},
    const {'1': 'characteristic_read_arguments', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicReadReplyArguments', '9': 0, '10': 'characteristicReadArguments'},
    const {'1': 'descriptor_read_arguments', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.DescriptorReadReplyArguments', '9': 0, '10': 'descriptorReadArguments'},
  ],
  '8': const [
    const {'1': 'arguments'},
  ],
};

/// Descriptor for `Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyDescriptor = $convert.base64Decode('CgVSZXBseRKTAQodYmx1ZXRvb3RoX2dldF9zdGF0ZV9hcmd1bWVudHMYASABKAsyTi5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuQmx1ZXRvb3RoR2V0U3RhdGVSZXBseUFyZ3VtZW50c0gAUhpibHVldG9vdGhHZXRTdGF0ZUFyZ3VtZW50cxKJAQoZY2VudHJhbF9jb25uZWN0X2FyZ3VtZW50cxgCIAEoCzJLLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DZW50cmFsQ29ubmVjdFJlcGx5QXJndW1lbnRzSABSF2NlbnRyYWxDb25uZWN0QXJndW1lbnRzEpUBCh1jaGFyYWN0ZXJpc3RpY19yZWFkX2FyZ3VtZW50cxgDIAEoCzJPLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DaGFyYWN0ZXJpc3RpY1JlYWRSZXBseUFyZ3VtZW50c0gAUhtjaGFyYWN0ZXJpc3RpY1JlYWRBcmd1bWVudHMSiQEKGWRlc2NyaXB0b3JfcmVhZF9hcmd1bWVudHMYBCABKAsySy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuRGVzY3JpcHRvclJlYWRSZXBseUFyZ3VtZW50c0gAUhdkZXNjcmlwdG9yUmVhZEFyZ3VtZW50c0ILCglhcmd1bWVudHM=');
@$core.Deprecated('Use bluetoothGetStateReplyArgumentsDescriptor instead')
const BluetoothGetStateReplyArguments$json = const {
  '1': 'BluetoothGetStateReplyArguments',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothState', '10': 'state'},
  ],
};

/// Descriptor for `BluetoothGetStateReplyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothGetStateReplyArgumentsDescriptor = $convert.base64Decode('Ch9CbHVldG9vdGhHZXRTdGF0ZVJlcGx5QXJndW1lbnRzElMKBXN0YXRlGAEgASgOMj0uZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkJsdWV0b290aFN0YXRlUgVzdGF0ZQ==');
@$core.Deprecated('Use centralConnectReplyArgumentsDescriptor instead')
const CentralConnectReplyArguments$json = const {
  '1': 'CentralConnectReplyArguments',
  '2': const [
    const {'1': 'gatt', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GATT', '10': 'gatt'},
  ],
};

/// Descriptor for `CentralConnectReplyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralConnectReplyArgumentsDescriptor = $convert.base64Decode('ChxDZW50cmFsQ29ubmVjdFJlcGx5QXJndW1lbnRzEkcKBGdhdHQYASABKAsyMy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuR0FUVFIEZ2F0dA==');
@$core.Deprecated('Use characteristicReadReplyArgumentsDescriptor instead')
const CharacteristicReadReplyArguments$json = const {
  '1': 'CharacteristicReadReplyArguments',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `CharacteristicReadReplyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicReadReplyArgumentsDescriptor = $convert.base64Decode('CiBDaGFyYWN0ZXJpc3RpY1JlYWRSZXBseUFyZ3VtZW50cxIUCgV2YWx1ZRgBIAEoDFIFdmFsdWU=');
@$core.Deprecated('Use descriptorReadReplyArgumentsDescriptor instead')
const DescriptorReadReplyArguments$json = const {
  '1': 'DescriptorReadReplyArguments',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `DescriptorReadReplyArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptorReadReplyArgumentsDescriptor = $convert.base64Decode('ChxEZXNjcmlwdG9yUmVhZFJlcGx5QXJndW1lbnRzEhQKBXZhbHVlGAEgASgMUgV2YWx1ZQ==');
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.EventCategory', '10': 'category'},
    const {'1': 'bluetooth_state_changed_arguments', '3': 2, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothStateChangedEventArguments', '9': 0, '10': 'bluetoothStateChangedArguments'},
    const {'1': 'central_discovered_arguments', '3': 3, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CentralDiscoveredEventArguments', '9': 0, '10': 'centralDiscoveredArguments'},
    const {'1': 'gatt_connection_lost_arguments', '3': 4, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GattConnectionLostEventArguments', '9': 0, '10': 'gattConnectionLostArguments'},
    const {'1': 'characteristic_notified_arguments', '3': 5, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.CharacteristicNotifiedEventArguments', '9': 0, '10': 'characteristicNotifiedArguments'},
  ],
  '8': const [
    const {'1': 'event'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode('CgVFdmVudBJYCghjYXRlZ29yeRgBIAEoDjI8LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5FdmVudENhdGVnb3J5UghjYXRlZ29yeRKfAQohYmx1ZXRvb3RoX3N0YXRlX2NoYW5nZWRfYXJndW1lbnRzGAIgASgLMlIuZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkJsdWV0b290aFN0YXRlQ2hhbmdlZEV2ZW50QXJndW1lbnRzSABSHmJsdWV0b290aFN0YXRlQ2hhbmdlZEFyZ3VtZW50cxKSAQocY2VudHJhbF9kaXNjb3ZlcmVkX2FyZ3VtZW50cxgDIAEoCzJOLmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5DZW50cmFsRGlzY292ZXJlZEV2ZW50QXJndW1lbnRzSABSGmNlbnRyYWxEaXNjb3ZlcmVkQXJndW1lbnRzEpYBCh5nYXR0X2Nvbm5lY3Rpb25fbG9zdF9hcmd1bWVudHMYBCABKAsyTy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuR2F0dENvbm5lY3Rpb25Mb3N0RXZlbnRBcmd1bWVudHNIAFIbZ2F0dENvbm5lY3Rpb25Mb3N0QXJndW1lbnRzEqEBCiFjaGFyYWN0ZXJpc3RpY19ub3RpZmllZF9hcmd1bWVudHMYBSABKAsyUy5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuQ2hhcmFjdGVyaXN0aWNOb3RpZmllZEV2ZW50QXJndW1lbnRzSABSH2NoYXJhY3RlcmlzdGljTm90aWZpZWRBcmd1bWVudHNCBwoFZXZlbnQ=');
@$core.Deprecated('Use bluetoothStateChangedEventArgumentsDescriptor instead')
const BluetoothStateChangedEventArguments$json = const {
  '1': 'BluetoothStateChangedEventArguments',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.BluetoothState', '10': 'state'},
  ],
};

/// Descriptor for `BluetoothStateChangedEventArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothStateChangedEventArgumentsDescriptor = $convert.base64Decode('CiNCbHVldG9vdGhTdGF0ZUNoYW5nZWRFdmVudEFyZ3VtZW50cxJTCgVzdGF0ZRgBIAEoDjI9LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5CbHVldG9vdGhTdGF0ZVIFc3RhdGU=');
@$core.Deprecated('Use centralDiscoveredEventArgumentsDescriptor instead')
const CentralDiscoveredEventArguments$json = const {
  '1': 'CentralDiscoveredEventArguments',
  '2': const [
    const {'1': 'discovery', '3': 1, '4': 1, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.Discovery', '10': 'discovery'},
  ],
};

/// Descriptor for `CentralDiscoveredEventArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List centralDiscoveredEventArgumentsDescriptor = $convert.base64Decode('Ch9DZW50cmFsRGlzY292ZXJlZEV2ZW50QXJndW1lbnRzElYKCWRpc2NvdmVyeRgBIAEoCzI4LmRldi55YW5zaG91d2FuZy5ibHVldG9vdGhfbG93X2VuZXJneS5tZXNzYWdlcy5EaXNjb3ZlcnlSCWRpc2NvdmVyeQ==');
@$core.Deprecated('Use gattConnectionLostEventArgumentsDescriptor instead')
const GattConnectionLostEventArguments$json = const {
  '1': 'GattConnectionLostEventArguments',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'error_code', '3': 2, '4': 1, '5': 5, '10': 'errorCode'},
  ],
};

/// Descriptor for `GattConnectionLostEventArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattConnectionLostEventArgumentsDescriptor = $convert.base64Decode('CiBHYXR0Q29ubmVjdGlvbkxvc3RFdmVudEFyZ3VtZW50cxIOCgJpZBgBIAEoCVICaWQSHQoKZXJyb3JfY29kZRgCIAEoBVIJZXJyb3JDb2Rl');
@$core.Deprecated('Use characteristicNotifiedEventArgumentsDescriptor instead')
const CharacteristicNotifiedEventArguments$json = const {
  '1': 'CharacteristicNotifiedEventArguments',
  '2': const [
    const {'1': 'gatt_id', '3': 1, '4': 1, '5': 9, '10': 'gattId'},
    const {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'value', '3': 4, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `CharacteristicNotifiedEventArguments`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicNotifiedEventArgumentsDescriptor = $convert.base64Decode('CiRDaGFyYWN0ZXJpc3RpY05vdGlmaWVkRXZlbnRBcmd1bWVudHMSFwoHZ2F0dF9pZBgBIAEoCVIGZ2F0dElkEh0KCnNlcnZpY2VfaWQYAiABKAlSCXNlcnZpY2VJZBIOCgJpZBgDIAEoCVICaWQSFAoFdmFsdWUYBCABKAxSBXZhbHVl');
@$core.Deprecated('Use discoveryDescriptor instead')
const Discovery$json = const {
  '1': 'Discovery',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 17, '10': 'rssi'},
    const {'1': 'advertisements', '3': 3, '4': 1, '5': 12, '10': 'advertisements'},
    const {'1': 'connectable', '3': 4, '4': 1, '5': 8, '10': 'connectable'},
  ],
};

/// Descriptor for `Discovery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveryDescriptor = $convert.base64Decode('CglEaXNjb3ZlcnkSEgoEdXVpZBgBIAEoCVIEdXVpZBISCgRyc3NpGAIgASgRUgRyc3NpEiYKDmFkdmVydGlzZW1lbnRzGAMgASgMUg5hZHZlcnRpc2VtZW50cxIgCgtjb25uZWN0YWJsZRgEIAEoCFILY29ubmVjdGFibGU=');
@$core.Deprecated('Use gATTDescriptor instead')
const GATT$json = const {
  '1': 'GATT',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'maximum_write_length', '3': 2, '4': 1, '5': 5, '10': 'maximumWriteLength'},
    const {'1': 'services', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GattService', '10': 'services'},
  ],
};

/// Descriptor for `GATT`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gATTDescriptor = $convert.base64Decode('CgRHQVRUEg4KAmlkGAEgASgJUgJpZBIwChRtYXhpbXVtX3dyaXRlX2xlbmd0aBgCIAEoBVISbWF4aW11bVdyaXRlTGVuZ3RoElYKCHNlcnZpY2VzGAMgAygLMjouZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkdhdHRTZXJ2aWNlUghzZXJ2aWNlcw==');
@$core.Deprecated('Use gattServiceDescriptor instead')
const GattService$json = const {
  '1': 'GattService',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'characteristics', '3': 3, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GattCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `GattService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattServiceDescriptor = $convert.base64Decode('CgtHYXR0U2VydmljZRIOCgJpZBgBIAEoCVICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZBJrCg9jaGFyYWN0ZXJpc3RpY3MYAyADKAsyQS5kZXYueWFuc2hvdXdhbmcuYmx1ZXRvb3RoX2xvd19lbmVyZ3kubWVzc2FnZXMuR2F0dENoYXJhY3RlcmlzdGljUg9jaGFyYWN0ZXJpc3RpY3M=');
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
    const {'1': 'descriptors', '3': 7, '4': 3, '5': 11, '6': '.dev.yanshouwang.bluetooth_low_energy.messages.GattDescriptor', '10': 'descriptors'},
  ],
};

/// Descriptor for `GattCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gattCharacteristicDescriptor = $convert.base64Decode('ChJHYXR0Q2hhcmFjdGVyaXN0aWMSDgoCaWQYASABKAlSAmlkEhIKBHV1aWQYAiABKAlSBHV1aWQSGQoIY2FuX3JlYWQYAyABKAhSB2NhblJlYWQSGwoJY2FuX3dyaXRlGAQgASgIUghjYW5Xcml0ZRI7ChpjYW5fd3JpdGVfd2l0aG91dF9yZXNwb25zZRgFIAEoCFIXY2FuV3JpdGVXaXRob3V0UmVzcG9uc2USHQoKY2FuX25vdGlmeRgGIAEoCFIJY2FuTm90aWZ5El8KC2Rlc2NyaXB0b3JzGAcgAygLMj0uZGV2LnlhbnNob3V3YW5nLmJsdWV0b290aF9sb3dfZW5lcmd5Lm1lc3NhZ2VzLkdhdHREZXNjcmlwdG9yUgtkZXNjcmlwdG9ycw==');
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
