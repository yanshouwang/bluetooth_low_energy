//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use advertisementApiDescriptor instead')
const AdvertisementApi$json = {
  '1': 'AdvertisementApi',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {'1': 'service_uuids', '3': 2, '4': 3, '5': 9, '10': 'serviceUuids'},
    {'1': 'service_data', '3': 3, '4': 3, '5': 11, '6': '.AdvertisementApi.ServiceDataEntry', '10': 'serviceData'},
    {'1': 'manufacturer_specific_data', '3': 4, '4': 3, '5': 11, '6': '.ManufacturerSpecificDataApi', '10': 'manufacturerSpecificData'},
  ],
  '3': [AdvertisementApi_ServiceDataEntry$json],
  '8': [
    {'1': '_name'},
  ],
};

@$core.Deprecated('Use advertisementApiDescriptor instead')
const AdvertisementApi_ServiceDataEntry$json = {
  '1': 'ServiceDataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AdvertisementApi`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advertisementApiDescriptor = $convert.base64Decode(
    'ChBBZHZlcnRpc2VtZW50QXBpEhcKBG5hbWUYASABKAlIAFIEbmFtZYgBARIjCg1zZXJ2aWNlX3'
    'V1aWRzGAIgAygJUgxzZXJ2aWNlVXVpZHMSRQoMc2VydmljZV9kYXRhGAMgAygLMiIuQWR2ZXJ0'
    'aXNlbWVudEFwaS5TZXJ2aWNlRGF0YUVudHJ5UgtzZXJ2aWNlRGF0YRJaChptYW51ZmFjdHVyZX'
    'Jfc3BlY2lmaWNfZGF0YRgEIAMoCzIcLk1hbnVmYWN0dXJlclNwZWNpZmljRGF0YUFwaVIYbWFu'
    'dWZhY3R1cmVyU3BlY2lmaWNEYXRhGj4KEFNlcnZpY2VEYXRhRW50cnkSEAoDa2V5GAEgASgJUg'
    'NrZXkSFAoFdmFsdWUYAiABKAxSBXZhbHVlOgI4AUIHCgVfbmFtZQ==');

@$core.Deprecated('Use manufacturerSpecificDataApiDescriptor instead')
const ManufacturerSpecificDataApi$json = {
  '1': 'ManufacturerSpecificDataApi',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ManufacturerSpecificDataApi`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List manufacturerSpecificDataApiDescriptor = $convert.base64Decode(
    'ChtNYW51ZmFjdHVyZXJTcGVjaWZpY0RhdGFBcGkSDgoCaWQYASABKAVSAmlkEhIKBGRhdGEYAi'
    'ABKAxSBGRhdGE=');

