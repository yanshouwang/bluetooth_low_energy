///
//  Generated code. Do not modify.
//  source: proto/messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'messages.pbenum.dart';

class Advertisement extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Advertisement', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOM<UUID>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', subBuilder: UUID.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rssi', $pb.PbFieldType.O3)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectable')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localName')
    ..a<$core.List<$core.int>>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'manufacturerSpecificData', $pb.PbFieldType.OY)
    ..pc<ServiceData>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceDatas', $pb.PbFieldType.PM, subBuilder: ServiceData.create)
    ..pc<UUID>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuids', $pb.PbFieldType.PM, subBuilder: UUID.create)
    ..pc<UUID>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'solicitedServiceUuids', $pb.PbFieldType.PM, subBuilder: UUID.create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txPowerLevel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Advertisement._() : super();
  factory Advertisement({
    UUID? uuid,
    $core.int? rssi,
    $core.bool? connectable,
    $core.List<$core.int>? data,
    $core.String? localName,
    $core.List<$core.int>? manufacturerSpecificData,
    $core.Iterable<ServiceData>? serviceDatas,
    $core.Iterable<UUID>? serviceUuids,
    $core.Iterable<UUID>? solicitedServiceUuids,
    $core.int? txPowerLevel,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (rssi != null) {
      _result.rssi = rssi;
    }
    if (connectable != null) {
      _result.connectable = connectable;
    }
    if (data != null) {
      _result.data = data;
    }
    if (localName != null) {
      _result.localName = localName;
    }
    if (manufacturerSpecificData != null) {
      _result.manufacturerSpecificData = manufacturerSpecificData;
    }
    if (serviceDatas != null) {
      _result.serviceDatas.addAll(serviceDatas);
    }
    if (serviceUuids != null) {
      _result.serviceUuids.addAll(serviceUuids);
    }
    if (solicitedServiceUuids != null) {
      _result.solicitedServiceUuids.addAll(solicitedServiceUuids);
    }
    if (txPowerLevel != null) {
      _result.txPowerLevel = txPowerLevel;
    }
    return _result;
  }
  factory Advertisement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Advertisement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Advertisement clone() => Advertisement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Advertisement copyWith(void Function(Advertisement) updates) => super.copyWith((message) => updates(message as Advertisement)) as Advertisement; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Advertisement create() => Advertisement._();
  Advertisement createEmptyInstance() => create();
  static $pb.PbList<Advertisement> createRepeated() => $pb.PbList<Advertisement>();
  @$core.pragma('dart2js:noInline')
  static Advertisement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Advertisement>(create);
  static Advertisement? _defaultInstance;

  @$pb.TagNumber(1)
  UUID get uuid => $_getN(0);
  @$pb.TagNumber(1)
  set uuid(UUID v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
  @$pb.TagNumber(1)
  UUID ensureUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get rssi => $_getIZ(1);
  @$pb.TagNumber(2)
  set rssi($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRssi() => $_has(1);
  @$pb.TagNumber(2)
  void clearRssi() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get connectable => $_getBF(2);
  @$pb.TagNumber(3)
  set connectable($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConnectable() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectable() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get localName => $_getSZ(4);
  @$pb.TagNumber(5)
  set localName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLocalName() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocalName() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get manufacturerSpecificData => $_getN(5);
  @$pb.TagNumber(6)
  set manufacturerSpecificData($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasManufacturerSpecificData() => $_has(5);
  @$pb.TagNumber(6)
  void clearManufacturerSpecificData() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<ServiceData> get serviceDatas => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<UUID> get serviceUuids => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<UUID> get solicitedServiceUuids => $_getList(8);

  @$pb.TagNumber(10)
  $core.int get txPowerLevel => $_getIZ(9);
  @$pb.TagNumber(10)
  set txPowerLevel($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTxPowerLevel() => $_has(9);
  @$pb.TagNumber(10)
  void clearTxPowerLevel() => clearField(10);
}

class Peripheral extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Peripheral', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maximumWriteLength', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Peripheral._() : super();
  factory Peripheral({
    $fixnum.Int64? id,
    $core.int? maximumWriteLength,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (maximumWriteLength != null) {
      _result.maximumWriteLength = maximumWriteLength;
    }
    return _result;
  }
  factory Peripheral.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peripheral.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peripheral clone() => Peripheral()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peripheral copyWith(void Function(Peripheral) updates) => super.copyWith((message) => updates(message as Peripheral)) as Peripheral; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Peripheral create() => Peripheral._();
  Peripheral createEmptyInstance() => create();
  static $pb.PbList<Peripheral> createRepeated() => $pb.PbList<Peripheral>();
  @$core.pragma('dart2js:noInline')
  static Peripheral getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peripheral>(create);
  static Peripheral? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maximumWriteLength => $_getIZ(1);
  @$pb.TagNumber(2)
  set maximumWriteLength($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaximumWriteLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaximumWriteLength() => clearField(2);
}

class GattService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattService', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<UUID>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', subBuilder: UUID.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $fixnum.Int64? id,
    UUID? uuid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    return _result;
  }
  factory GattService.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattService.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattService clone() => GattService()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattService copyWith(void Function(GattService) updates) => super.copyWith((message) => updates(message as GattService)) as GattService; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattService create() => GattService._();
  GattService createEmptyInstance() => create();
  static $pb.PbList<GattService> createRepeated() => $pb.PbList<GattService>();
  @$core.pragma('dart2js:noInline')
  static GattService getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattService>(create);
  static GattService? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  UUID get uuid => $_getN(1);
  @$pb.TagNumber(2)
  set uuid(UUID v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);
  @$pb.TagNumber(2)
  UUID ensureUuid() => $_ensure(1);
}

class GattCharacteristic extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<UUID>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', subBuilder: UUID.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canRead')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWrite')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWriteWithoutResponse')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canNotify')
    ..hasRequiredFields = false
  ;

  GattCharacteristic._() : super();
  factory GattCharacteristic({
    $fixnum.Int64? id,
    UUID? uuid,
    $core.bool? canRead,
    $core.bool? canWrite,
    $core.bool? canWriteWithoutResponse,
    $core.bool? canNotify,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (canRead != null) {
      _result.canRead = canRead;
    }
    if (canWrite != null) {
      _result.canWrite = canWrite;
    }
    if (canWriteWithoutResponse != null) {
      _result.canWriteWithoutResponse = canWriteWithoutResponse;
    }
    if (canNotify != null) {
      _result.canNotify = canNotify;
    }
    return _result;
  }
  factory GattCharacteristic.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristic.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristic clone() => GattCharacteristic()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristic copyWith(void Function(GattCharacteristic) updates) => super.copyWith((message) => updates(message as GattCharacteristic)) as GattCharacteristic; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristic create() => GattCharacteristic._();
  GattCharacteristic createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristic> createRepeated() => $pb.PbList<GattCharacteristic>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristic getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristic>(create);
  static GattCharacteristic? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  UUID get uuid => $_getN(1);
  @$pb.TagNumber(2)
  set uuid(UUID v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);
  @$pb.TagNumber(2)
  UUID ensureUuid() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get canRead => $_getBF(2);
  @$pb.TagNumber(3)
  set canRead($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCanRead() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanRead() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get canWrite => $_getBF(3);
  @$pb.TagNumber(4)
  set canWrite($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCanWrite() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanWrite() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get canWriteWithoutResponse => $_getBF(4);
  @$pb.TagNumber(5)
  set canWriteWithoutResponse($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCanWriteWithoutResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearCanWriteWithoutResponse() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get canNotify => $_getBF(5);
  @$pb.TagNumber(6)
  set canNotify($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCanNotify() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanNotify() => clearField(6);
}

class GattDescriptor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptor', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<UUID>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', subBuilder: UUID.create)
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $fixnum.Int64? id,
    UUID? uuid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    return _result;
  }
  factory GattDescriptor.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDescriptor.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDescriptor clone() => GattDescriptor()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDescriptor copyWith(void Function(GattDescriptor) updates) => super.copyWith((message) => updates(message as GattDescriptor)) as GattDescriptor; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDescriptor create() => GattDescriptor._();
  GattDescriptor createEmptyInstance() => create();
  static $pb.PbList<GattDescriptor> createRepeated() => $pb.PbList<GattDescriptor>();
  @$core.pragma('dart2js:noInline')
  static GattDescriptor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDescriptor>(create);
  static GattDescriptor? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  UUID get uuid => $_getN(1);
  @$pb.TagNumber(2)
  set uuid(UUID v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);
  @$pb.TagNumber(2)
  UUID ensureUuid() => $_ensure(1);
}

class UUID extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UUID', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  UUID._() : super();
  factory UUID({
    $core.String? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory UUID.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UUID.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UUID clone() => UUID()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UUID copyWith(void Function(UUID) updates) => super.copyWith((message) => updates(message as UUID)) as UUID; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UUID create() => UUID._();
  UUID createEmptyInstance() => create();
  static $pb.PbList<UUID> createRepeated() => $pb.PbList<UUID>();
  @$core.pragma('dart2js:noInline')
  static UUID getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UUID>(create);
  static UUID? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class ServiceData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServiceData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOM<UUID>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', subBuilder: UUID.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ServiceData._() : super();
  factory ServiceData({
    UUID? uuid,
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory ServiceData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceData clone() => ServiceData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceData copyWith(void Function(ServiceData) updates) => super.copyWith((message) => updates(message as ServiceData)) as ServiceData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceData create() => ServiceData._();
  ServiceData createEmptyInstance() => create();
  static $pb.PbList<ServiceData> createRepeated() => $pb.PbList<ServiceData>();
  @$core.pragma('dart2js:noInline')
  static ServiceData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceData>(create);
  static ServiceData? _defaultInstance;

  @$pb.TagNumber(1)
  UUID get uuid => $_getN(0);
  @$pb.TagNumber(1)
  set uuid(UUID v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
  @$pb.TagNumber(1)
  UUID ensureUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class BluetoothLowEnergyException extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothLowEnergyException', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  BluetoothLowEnergyException._() : super();
  factory BluetoothLowEnergyException({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory BluetoothLowEnergyException.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothLowEnergyException.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothLowEnergyException clone() => BluetoothLowEnergyException()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothLowEnergyException copyWith(void Function(BluetoothLowEnergyException) updates) => super.copyWith((message) => updates(message as BluetoothLowEnergyException)) as BluetoothLowEnergyException; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothLowEnergyException create() => BluetoothLowEnergyException._();
  BluetoothLowEnergyException createEmptyInstance() => create();
  static $pb.PbList<BluetoothLowEnergyException> createRepeated() => $pb.PbList<BluetoothLowEnergyException>();
  @$core.pragma('dart2js:noInline')
  static BluetoothLowEnergyException getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothLowEnergyException>(create);
  static BluetoothLowEnergyException? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

