//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AdvertisementApi extends $pb.GeneratedMessage {
  factory AdvertisementApi({
    $core.String? name,
    $core.Iterable<$core.String>? serviceUuids,
    $core.Map<$core.String, $core.List<$core.int>>? serviceData,
    $core.Iterable<ManufacturerSpecificDataApi>? manufacturerSpecificData,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (serviceUuids != null) {
      $result.serviceUuids.addAll(serviceUuids);
    }
    if (serviceData != null) {
      $result.serviceData.addAll(serviceData);
    }
    if (manufacturerSpecificData != null) {
      $result.manufacturerSpecificData.addAll(manufacturerSpecificData);
    }
    return $result;
  }
  AdvertisementApi._() : super();
  factory AdvertisementApi.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AdvertisementApi.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AdvertisementApi', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPS(2, _omitFieldNames ? '' : 'serviceUuids')
    ..m<$core.String, $core.List<$core.int>>(3, _omitFieldNames ? '' : 'serviceData', entryClassName: 'AdvertisementApi.ServiceDataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OY)
    ..pc<ManufacturerSpecificDataApi>(4, _omitFieldNames ? '' : 'manufacturerSpecificData', $pb.PbFieldType.PM, subBuilder: ManufacturerSpecificDataApi.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AdvertisementApi clone() => AdvertisementApi()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AdvertisementApi copyWith(void Function(AdvertisementApi) updates) => super.copyWith((message) => updates(message as AdvertisementApi)) as AdvertisementApi;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvertisementApi create() => AdvertisementApi._();
  AdvertisementApi createEmptyInstance() => create();
  static $pb.PbList<AdvertisementApi> createRepeated() => $pb.PbList<AdvertisementApi>();
  @$core.pragma('dart2js:noInline')
  static AdvertisementApi getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AdvertisementApi>(create);
  static AdvertisementApi? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get serviceUuids => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $core.List<$core.int>> get serviceData => $_getMap(2);

  @$pb.TagNumber(4)
  $core.List<ManufacturerSpecificDataApi> get manufacturerSpecificData => $_getList(3);
}

class ManufacturerSpecificDataApi extends $pb.GeneratedMessage {
  factory ManufacturerSpecificDataApi({
    $core.int? id,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ManufacturerSpecificDataApi._() : super();
  factory ManufacturerSpecificDataApi.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ManufacturerSpecificDataApi.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ManufacturerSpecificDataApi', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ManufacturerSpecificDataApi clone() => ManufacturerSpecificDataApi()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ManufacturerSpecificDataApi copyWith(void Function(ManufacturerSpecificDataApi) updates) => super.copyWith((message) => updates(message as ManufacturerSpecificDataApi)) as ManufacturerSpecificDataApi;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ManufacturerSpecificDataApi create() => ManufacturerSpecificDataApi._();
  ManufacturerSpecificDataApi createEmptyInstance() => create();
  static $pb.PbList<ManufacturerSpecificDataApi> createRepeated() => $pb.PbList<ManufacturerSpecificDataApi>();
  @$core.pragma('dart2js:noInline')
  static ManufacturerSpecificDataApi getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ManufacturerSpecificDataApi>(create);
  static ManufacturerSpecificDataApi? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
