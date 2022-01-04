///
//  Generated code. Do not modify.
//  source: messages.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'messages.pbenum.dart';

export 'messages.pbenum.dart';

enum Command_Arguments {
  centralStartDiscoveryArguments, 
  centralConnectArguments, 
  gattDisconnectArguments, 
  characteristicReadArguments, 
  characteristicWriteArguments, 
  characteristicNotifyArguments, 
  descriptorReadArguments, 
  descriptorWriteArguments, 
  notSet
}

class Command extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Command_Arguments> _Command_ArgumentsByTag = {
    2 : Command_Arguments.centralStartDiscoveryArguments,
    3 : Command_Arguments.centralConnectArguments,
    4 : Command_Arguments.gattDisconnectArguments,
    5 : Command_Arguments.characteristicReadArguments,
    6 : Command_Arguments.characteristicWriteArguments,
    7 : Command_Arguments.characteristicNotifyArguments,
    8 : Command_Arguments.descriptorReadArguments,
    9 : Command_Arguments.descriptorWriteArguments,
    0 : Command_Arguments.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Command', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9])
    ..e<CommandCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE, valueOf: CommandCategory.valueOf, enumValues: CommandCategory.values)
    ..aOM<CentralStartDiscoveryArguments>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralStartDiscoveryArguments', subBuilder: CentralStartDiscoveryArguments.create)
    ..aOM<CentralConnectArguments>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralConnectArguments', subBuilder: CentralConnectArguments.create)
    ..aOM<GattDisconnectArguments>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattDisconnectArguments', subBuilder: GattDisconnectArguments.create)
    ..aOM<GattCharacteristicReadArguments>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicReadArguments', subBuilder: GattCharacteristicReadArguments.create)
    ..aOM<GattCharacteristicWriteArguments>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicWriteArguments', subBuilder: GattCharacteristicWriteArguments.create)
    ..aOM<GattCharacteristicNotifyArguments>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicNotifyArguments', subBuilder: GattCharacteristicNotifyArguments.create)
    ..aOM<GattDescriptorReadArguments>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptorReadArguments', subBuilder: GattDescriptorReadArguments.create)
    ..aOM<GattDescriptorWriteArguments>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptorWriteArguments', subBuilder: GattDescriptorWriteArguments.create)
    ..hasRequiredFields = false
  ;

  Command._() : super();
  factory Command({
    CommandCategory? category,
    CentralStartDiscoveryArguments? centralStartDiscoveryArguments,
    CentralConnectArguments? centralConnectArguments,
    GattDisconnectArguments? gattDisconnectArguments,
    GattCharacteristicReadArguments? characteristicReadArguments,
    GattCharacteristicWriteArguments? characteristicWriteArguments,
    GattCharacteristicNotifyArguments? characteristicNotifyArguments,
    GattDescriptorReadArguments? descriptorReadArguments,
    GattDescriptorWriteArguments? descriptorWriteArguments,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (centralStartDiscoveryArguments != null) {
      _result.centralStartDiscoveryArguments = centralStartDiscoveryArguments;
    }
    if (centralConnectArguments != null) {
      _result.centralConnectArguments = centralConnectArguments;
    }
    if (gattDisconnectArguments != null) {
      _result.gattDisconnectArguments = gattDisconnectArguments;
    }
    if (characteristicReadArguments != null) {
      _result.characteristicReadArguments = characteristicReadArguments;
    }
    if (characteristicWriteArguments != null) {
      _result.characteristicWriteArguments = characteristicWriteArguments;
    }
    if (characteristicNotifyArguments != null) {
      _result.characteristicNotifyArguments = characteristicNotifyArguments;
    }
    if (descriptorReadArguments != null) {
      _result.descriptorReadArguments = descriptorReadArguments;
    }
    if (descriptorWriteArguments != null) {
      _result.descriptorWriteArguments = descriptorWriteArguments;
    }
    return _result;
  }
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  Command_Arguments whichArguments() => _Command_ArgumentsByTag[$_whichOneof(0)]!;
  void clearArguments() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CommandCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(CommandCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  CentralStartDiscoveryArguments get centralStartDiscoveryArguments => $_getN(1);
  @$pb.TagNumber(2)
  set centralStartDiscoveryArguments(CentralStartDiscoveryArguments v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCentralStartDiscoveryArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearCentralStartDiscoveryArguments() => clearField(2);
  @$pb.TagNumber(2)
  CentralStartDiscoveryArguments ensureCentralStartDiscoveryArguments() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralConnectArguments get centralConnectArguments => $_getN(2);
  @$pb.TagNumber(3)
  set centralConnectArguments(CentralConnectArguments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralConnectArguments() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralConnectArguments() => clearField(3);
  @$pb.TagNumber(3)
  CentralConnectArguments ensureCentralConnectArguments() => $_ensure(2);

  @$pb.TagNumber(4)
  GattDisconnectArguments get gattDisconnectArguments => $_getN(3);
  @$pb.TagNumber(4)
  set gattDisconnectArguments(GattDisconnectArguments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattDisconnectArguments() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattDisconnectArguments() => clearField(4);
  @$pb.TagNumber(4)
  GattDisconnectArguments ensureGattDisconnectArguments() => $_ensure(3);

  @$pb.TagNumber(5)
  GattCharacteristicReadArguments get characteristicReadArguments => $_getN(4);
  @$pb.TagNumber(5)
  set characteristicReadArguments(GattCharacteristicReadArguments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCharacteristicReadArguments() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacteristicReadArguments() => clearField(5);
  @$pb.TagNumber(5)
  GattCharacteristicReadArguments ensureCharacteristicReadArguments() => $_ensure(4);

  @$pb.TagNumber(6)
  GattCharacteristicWriteArguments get characteristicWriteArguments => $_getN(5);
  @$pb.TagNumber(6)
  set characteristicWriteArguments(GattCharacteristicWriteArguments v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCharacteristicWriteArguments() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacteristicWriteArguments() => clearField(6);
  @$pb.TagNumber(6)
  GattCharacteristicWriteArguments ensureCharacteristicWriteArguments() => $_ensure(5);

  @$pb.TagNumber(7)
  GattCharacteristicNotifyArguments get characteristicNotifyArguments => $_getN(6);
  @$pb.TagNumber(7)
  set characteristicNotifyArguments(GattCharacteristicNotifyArguments v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCharacteristicNotifyArguments() => $_has(6);
  @$pb.TagNumber(7)
  void clearCharacteristicNotifyArguments() => clearField(7);
  @$pb.TagNumber(7)
  GattCharacteristicNotifyArguments ensureCharacteristicNotifyArguments() => $_ensure(6);

  @$pb.TagNumber(8)
  GattDescriptorReadArguments get descriptorReadArguments => $_getN(7);
  @$pb.TagNumber(8)
  set descriptorReadArguments(GattDescriptorReadArguments v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasDescriptorReadArguments() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescriptorReadArguments() => clearField(8);
  @$pb.TagNumber(8)
  GattDescriptorReadArguments ensureDescriptorReadArguments() => $_ensure(7);

  @$pb.TagNumber(9)
  GattDescriptorWriteArguments get descriptorWriteArguments => $_getN(8);
  @$pb.TagNumber(9)
  set descriptorWriteArguments(GattDescriptorWriteArguments v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescriptorWriteArguments() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescriptorWriteArguments() => clearField(9);
  @$pb.TagNumber(9)
  GattDescriptorWriteArguments ensureDescriptorWriteArguments() => $_ensure(8);
}

class CentralStartDiscoveryArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralStartDiscoveryArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuids')
    ..hasRequiredFields = false
  ;

  CentralStartDiscoveryArguments._() : super();
  factory CentralStartDiscoveryArguments({
    $core.Iterable<$core.String>? uuids,
  }) {
    final _result = create();
    if (uuids != null) {
      _result.uuids.addAll(uuids);
    }
    return _result;
  }
  factory CentralStartDiscoveryArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralStartDiscoveryArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryArguments clone() => CentralStartDiscoveryArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryArguments copyWith(void Function(CentralStartDiscoveryArguments) updates) => super.copyWith((message) => updates(message as CentralStartDiscoveryArguments)) as CentralStartDiscoveryArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryArguments create() => CentralStartDiscoveryArguments._();
  CentralStartDiscoveryArguments createEmptyInstance() => create();
  static $pb.PbList<CentralStartDiscoveryArguments> createRepeated() => $pb.PbList<CentralStartDiscoveryArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralStartDiscoveryArguments>(create);
  static CentralStartDiscoveryArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get uuids => $_getList(0);
}

class CentralConnectArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralConnectArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  CentralConnectArguments._() : super();
  factory CentralConnectArguments({
    $core.String? uuid,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    return _result;
  }
  factory CentralConnectArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralConnectArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralConnectArguments clone() => CentralConnectArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralConnectArguments copyWith(void Function(CentralConnectArguments) updates) => super.copyWith((message) => updates(message as CentralConnectArguments)) as CentralConnectArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralConnectArguments create() => CentralConnectArguments._();
  CentralConnectArguments createEmptyInstance() => create();
  static $pb.PbList<CentralConnectArguments> createRepeated() => $pb.PbList<CentralConnectArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralConnectArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralConnectArguments>(create);
  static CentralConnectArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
}

class GattDisconnectArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDisconnectArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..hasRequiredFields = false
  ;

  GattDisconnectArguments._() : super();
  factory GattDisconnectArguments({
    $core.String? indexedUuid,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    return _result;
  }
  factory GattDisconnectArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDisconnectArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDisconnectArguments clone() => GattDisconnectArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDisconnectArguments copyWith(void Function(GattDisconnectArguments) updates) => super.copyWith((message) => updates(message as GattDisconnectArguments)) as GattDisconnectArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDisconnectArguments create() => GattDisconnectArguments._();
  GattDisconnectArguments createEmptyInstance() => create();
  static $pb.PbList<GattDisconnectArguments> createRepeated() => $pb.PbList<GattDisconnectArguments>();
  @$core.pragma('dart2js:noInline')
  static GattDisconnectArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDisconnectArguments>(create);
  static GattDisconnectArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);
}

class GattCharacteristicReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..hasRequiredFields = false
  ;

  GattCharacteristicReadArguments._() : super();
  factory GattCharacteristicReadArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedUuid,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    return _result;
  }
  factory GattCharacteristicReadArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicReadArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicReadArguments clone() => GattCharacteristicReadArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicReadArguments copyWith(void Function(GattCharacteristicReadArguments) updates) => super.copyWith((message) => updates(message as GattCharacteristicReadArguments)) as GattCharacteristicReadArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicReadArguments create() => GattCharacteristicReadArguments._();
  GattCharacteristicReadArguments createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicReadArguments> createRepeated() => $pb.PbList<GattCharacteristicReadArguments>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicReadArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicReadArguments>(create);
  static GattCharacteristicReadArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedUuid() => clearField(3);
}

class GattCharacteristicWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withoutResponse')
    ..hasRequiredFields = false
  ;

  GattCharacteristicWriteArguments._() : super();
  factory GattCharacteristicWriteArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedUuid,
    $core.List<$core.int>? value,
    $core.bool? withoutResponse,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    if (withoutResponse != null) {
      _result.withoutResponse = withoutResponse;
    }
    return _result;
  }
  factory GattCharacteristicWriteArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicWriteArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicWriteArguments clone() => GattCharacteristicWriteArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicWriteArguments copyWith(void Function(GattCharacteristicWriteArguments) updates) => super.copyWith((message) => updates(message as GattCharacteristicWriteArguments)) as GattCharacteristicWriteArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicWriteArguments create() => GattCharacteristicWriteArguments._();
  GattCharacteristicWriteArguments createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicWriteArguments> createRepeated() => $pb.PbList<GattCharacteristicWriteArguments>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicWriteArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicWriteArguments>(create);
  static GattCharacteristicWriteArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get withoutResponse => $_getBF(4);
  @$pb.TagNumber(5)
  set withoutResponse($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWithoutResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearWithoutResponse() => clearField(5);
}

class GattCharacteristicNotifyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicNotifyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false
  ;

  GattCharacteristicNotifyArguments._() : super();
  factory GattCharacteristicNotifyArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedUuid,
    $core.bool? state,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory GattCharacteristicNotifyArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicNotifyArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicNotifyArguments clone() => GattCharacteristicNotifyArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicNotifyArguments copyWith(void Function(GattCharacteristicNotifyArguments) updates) => super.copyWith((message) => updates(message as GattCharacteristicNotifyArguments)) as GattCharacteristicNotifyArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicNotifyArguments create() => GattCharacteristicNotifyArguments._();
  GattCharacteristicNotifyArguments createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicNotifyArguments> createRepeated() => $pb.PbList<GattCharacteristicNotifyArguments>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicNotifyArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicNotifyArguments>(create);
  static GattCharacteristicNotifyArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get state => $_getBF(3);
  @$pb.TagNumber(4)
  set state($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => clearField(4);
}

class GattDescriptorReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedCharacteristicUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..hasRequiredFields = false
  ;

  GattDescriptorReadArguments._() : super();
  factory GattDescriptorReadArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedCharacteristicUuid,
    $core.String? indexedUuid,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedCharacteristicUuid != null) {
      _result.indexedCharacteristicUuid = indexedCharacteristicUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    return _result;
  }
  factory GattDescriptorReadArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDescriptorReadArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDescriptorReadArguments clone() => GattDescriptorReadArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDescriptorReadArguments copyWith(void Function(GattDescriptorReadArguments) updates) => super.copyWith((message) => updates(message as GattDescriptorReadArguments)) as GattDescriptorReadArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDescriptorReadArguments create() => GattDescriptorReadArguments._();
  GattDescriptorReadArguments createEmptyInstance() => create();
  static $pb.PbList<GattDescriptorReadArguments> createRepeated() => $pb.PbList<GattDescriptorReadArguments>();
  @$core.pragma('dart2js:noInline')
  static GattDescriptorReadArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDescriptorReadArguments>(create);
  static GattDescriptorReadArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedCharacteristicUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedCharacteristicUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedCharacteristicUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get indexedUuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set indexedUuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIndexedUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndexedUuid() => clearField(4);
}

class GattDescriptorWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedCharacteristicUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattDescriptorWriteArguments._() : super();
  factory GattDescriptorWriteArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedCharacteristicUuid,
    $core.String? indexedUuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedCharacteristicUuid != null) {
      _result.indexedCharacteristicUuid = indexedCharacteristicUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GattDescriptorWriteArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDescriptorWriteArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDescriptorWriteArguments clone() => GattDescriptorWriteArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDescriptorWriteArguments copyWith(void Function(GattDescriptorWriteArguments) updates) => super.copyWith((message) => updates(message as GattDescriptorWriteArguments)) as GattDescriptorWriteArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDescriptorWriteArguments create() => GattDescriptorWriteArguments._();
  GattDescriptorWriteArguments createEmptyInstance() => create();
  static $pb.PbList<GattDescriptorWriteArguments> createRepeated() => $pb.PbList<GattDescriptorWriteArguments>();
  @$core.pragma('dart2js:noInline')
  static GattDescriptorWriteArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDescriptorWriteArguments>(create);
  static GattDescriptorWriteArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedCharacteristicUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedCharacteristicUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedCharacteristicUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get indexedUuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set indexedUuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIndexedUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndexedUuid() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);
}

enum Event_Arguments {
  bluetoothStateChangedArguments, 
  centralDiscoveredArguments, 
  gattConnectionLostArguments, 
  characteristicValueChangedArguments, 
  notSet
}

class Event extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Event_Arguments> _Event_ArgumentsByTag = {
    2 : Event_Arguments.bluetoothStateChangedArguments,
    3 : Event_Arguments.centralDiscoveredArguments,
    4 : Event_Arguments.gattConnectionLostArguments,
    5 : Event_Arguments.characteristicValueChangedArguments,
    0 : Event_Arguments.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Event', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..e<EventCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED, valueOf: EventCategory.valueOf, enumValues: EventCategory.values)
    ..aOM<BluetoothStateChangedArguments>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bluetoothStateChangedArguments', subBuilder: BluetoothStateChangedArguments.create)
    ..aOM<CentralDiscoveredArguments>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralDiscoveredArguments', subBuilder: CentralDiscoveredArguments.create)
    ..aOM<GattConnectionLostArguments>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattConnectionLostArguments', subBuilder: GattConnectionLostArguments.create)
    ..aOM<GattCharacteristicValueChangedArguments>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicValueChangedArguments', subBuilder: GattCharacteristicValueChangedArguments.create)
    ..hasRequiredFields = false
  ;

  Event._() : super();
  factory Event({
    EventCategory? category,
    BluetoothStateChangedArguments? bluetoothStateChangedArguments,
    CentralDiscoveredArguments? centralDiscoveredArguments,
    GattConnectionLostArguments? gattConnectionLostArguments,
    GattCharacteristicValueChangedArguments? characteristicValueChangedArguments,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (bluetoothStateChangedArguments != null) {
      _result.bluetoothStateChangedArguments = bluetoothStateChangedArguments;
    }
    if (centralDiscoveredArguments != null) {
      _result.centralDiscoveredArguments = centralDiscoveredArguments;
    }
    if (gattConnectionLostArguments != null) {
      _result.gattConnectionLostArguments = gattConnectionLostArguments;
    }
    if (characteristicValueChangedArguments != null) {
      _result.characteristicValueChangedArguments = characteristicValueChangedArguments;
    }
    return _result;
  }
  factory Event.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Event.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Event clone() => Event()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Event copyWith(void Function(Event) updates) => super.copyWith((message) => updates(message as Event)) as Event; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => $pb.PbList<Event>();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  Event_Arguments whichArguments() => _Event_ArgumentsByTag[$_whichOneof(0)]!;
  void clearArguments() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EventCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(EventCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  BluetoothStateChangedArguments get bluetoothStateChangedArguments => $_getN(1);
  @$pb.TagNumber(2)
  set bluetoothStateChangedArguments(BluetoothStateChangedArguments v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBluetoothStateChangedArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearBluetoothStateChangedArguments() => clearField(2);
  @$pb.TagNumber(2)
  BluetoothStateChangedArguments ensureBluetoothStateChangedArguments() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralDiscoveredArguments get centralDiscoveredArguments => $_getN(2);
  @$pb.TagNumber(3)
  set centralDiscoveredArguments(CentralDiscoveredArguments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralDiscoveredArguments() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralDiscoveredArguments() => clearField(3);
  @$pb.TagNumber(3)
  CentralDiscoveredArguments ensureCentralDiscoveredArguments() => $_ensure(2);

  @$pb.TagNumber(4)
  GattConnectionLostArguments get gattConnectionLostArguments => $_getN(3);
  @$pb.TagNumber(4)
  set gattConnectionLostArguments(GattConnectionLostArguments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattConnectionLostArguments() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattConnectionLostArguments() => clearField(4);
  @$pb.TagNumber(4)
  GattConnectionLostArguments ensureGattConnectionLostArguments() => $_ensure(3);

  @$pb.TagNumber(5)
  GattCharacteristicValueChangedArguments get characteristicValueChangedArguments => $_getN(4);
  @$pb.TagNumber(5)
  set characteristicValueChangedArguments(GattCharacteristicValueChangedArguments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCharacteristicValueChangedArguments() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacteristicValueChangedArguments() => clearField(5);
  @$pb.TagNumber(5)
  GattCharacteristicValueChangedArguments ensureCharacteristicValueChangedArguments() => $_ensure(4);
}

class BluetoothStateChangedArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothStateChangedArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..e<BluetoothState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.BLUETOOTH_STATE_UNSUPPORTED, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..hasRequiredFields = false
  ;

  BluetoothStateChangedArguments._() : super();
  factory BluetoothStateChangedArguments({
    BluetoothState? state,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory BluetoothStateChangedArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothStateChangedArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedArguments clone() => BluetoothStateChangedArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedArguments copyWith(void Function(BluetoothStateChangedArguments) updates) => super.copyWith((message) => updates(message as BluetoothStateChangedArguments)) as BluetoothStateChangedArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedArguments create() => BluetoothStateChangedArguments._();
  BluetoothStateChangedArguments createEmptyInstance() => create();
  static $pb.PbList<BluetoothStateChangedArguments> createRepeated() => $pb.PbList<BluetoothStateChangedArguments>();
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothStateChangedArguments>(create);
  static BluetoothStateChangedArguments? _defaultInstance;

  @$pb.TagNumber(1)
  BluetoothState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(BluetoothState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);
}

class CentralDiscoveredArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralDiscoveredArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOM<PeripheralDiscovery>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'discovery', subBuilder: PeripheralDiscovery.create)
    ..hasRequiredFields = false
  ;

  CentralDiscoveredArguments._() : super();
  factory CentralDiscoveredArguments({
    PeripheralDiscovery? discovery,
  }) {
    final _result = create();
    if (discovery != null) {
      _result.discovery = discovery;
    }
    return _result;
  }
  factory CentralDiscoveredArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralDiscoveredArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralDiscoveredArguments clone() => CentralDiscoveredArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralDiscoveredArguments copyWith(void Function(CentralDiscoveredArguments) updates) => super.copyWith((message) => updates(message as CentralDiscoveredArguments)) as CentralDiscoveredArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredArguments create() => CentralDiscoveredArguments._();
  CentralDiscoveredArguments createEmptyInstance() => create();
  static $pb.PbList<CentralDiscoveredArguments> createRepeated() => $pb.PbList<CentralDiscoveredArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralDiscoveredArguments>(create);
  static CentralDiscoveredArguments? _defaultInstance;

  @$pb.TagNumber(1)
  PeripheralDiscovery get discovery => $_getN(0);
  @$pb.TagNumber(1)
  set discovery(PeripheralDiscovery v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDiscovery() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiscovery() => clearField(1);
  @$pb.TagNumber(1)
  PeripheralDiscovery ensureDiscovery() => $_ensure(0);
}

class GattConnectionLostArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattConnectionLostArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
    ..hasRequiredFields = false
  ;

  GattConnectionLostArguments._() : super();
  factory GattConnectionLostArguments({
    $core.String? indexedUuid,
    $core.String? error,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory GattConnectionLostArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattConnectionLostArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattConnectionLostArguments clone() => GattConnectionLostArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattConnectionLostArguments copyWith(void Function(GattConnectionLostArguments) updates) => super.copyWith((message) => updates(message as GattConnectionLostArguments)) as GattConnectionLostArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostArguments create() => GattConnectionLostArguments._();
  GattConnectionLostArguments createEmptyInstance() => create();
  static $pb.PbList<GattConnectionLostArguments> createRepeated() => $pb.PbList<GattConnectionLostArguments>();
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattConnectionLostArguments>(create);
  static GattConnectionLostArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
}

class GattCharacteristicValueChangedArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicValueChangedArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedGattUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedServiceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattCharacteristicValueChangedArguments._() : super();
  factory GattCharacteristicValueChangedArguments({
    $core.String? indexedGattUuid,
    $core.String? indexedServiceUuid,
    $core.String? indexedUuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (indexedGattUuid != null) {
      _result.indexedGattUuid = indexedGattUuid;
    }
    if (indexedServiceUuid != null) {
      _result.indexedServiceUuid = indexedServiceUuid;
    }
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GattCharacteristicValueChangedArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicValueChangedArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicValueChangedArguments clone() => GattCharacteristicValueChangedArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicValueChangedArguments copyWith(void Function(GattCharacteristicValueChangedArguments) updates) => super.copyWith((message) => updates(message as GattCharacteristicValueChangedArguments)) as GattCharacteristicValueChangedArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValueChangedArguments create() => GattCharacteristicValueChangedArguments._();
  GattCharacteristicValueChangedArguments createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicValueChangedArguments> createRepeated() => $pb.PbList<GattCharacteristicValueChangedArguments>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValueChangedArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicValueChangedArguments>(create);
  static GattCharacteristicValueChangedArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedGattUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedGattUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedGattUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedGattUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexedServiceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexedServiceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexedServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexedServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get indexedUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set indexedUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndexedUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndexedUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);
}

class GATT extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GATT', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maximumWriteLength', $pb.PbFieldType.O3)
    ..pc<GattService>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: GattService.create)
    ..hasRequiredFields = false
  ;

  GATT._() : super();
  factory GATT({
    $core.String? indexedUuid,
    $core.int? maximumWriteLength,
    $core.Iterable<GattService>? services,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (maximumWriteLength != null) {
      _result.maximumWriteLength = maximumWriteLength;
    }
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory GATT.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GATT.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GATT clone() => GATT()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GATT copyWith(void Function(GATT) updates) => super.copyWith((message) => updates(message as GATT)) as GATT; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GATT create() => GATT._();
  GATT createEmptyInstance() => create();
  static $pb.PbList<GATT> createRepeated() => $pb.PbList<GATT>();
  @$core.pragma('dart2js:noInline')
  static GATT getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GATT>(create);
  static GATT? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maximumWriteLength => $_getIZ(1);
  @$pb.TagNumber(2)
  set maximumWriteLength($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaximumWriteLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaximumWriteLength() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<GattService> get services => $_getList(2);
}

class GattService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattService', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattCharacteristic>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: GattCharacteristic.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $core.String? indexedUuid,
    $core.String? uuid,
    $core.Iterable<GattCharacteristic>? characteristics,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (characteristics != null) {
      _result.characteristics.addAll(characteristics);
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
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set uuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<GattCharacteristic> get characteristics => $_getList(2);
}

class GattCharacteristic extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canRead')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWrite')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWriteWithoutResponse')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canNotify')
    ..pc<GattDescriptor>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptors', $pb.PbFieldType.PM, subBuilder: GattDescriptor.create)
    ..hasRequiredFields = false
  ;

  GattCharacteristic._() : super();
  factory GattCharacteristic({
    $core.String? indexedUuid,
    $core.String? uuid,
    $core.bool? canRead,
    $core.bool? canWrite,
    $core.bool? canWriteWithoutResponse,
    $core.bool? canNotify,
    $core.Iterable<GattDescriptor>? descriptors,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
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
    if (descriptors != null) {
      _result.descriptors.addAll(descriptors);
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
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set uuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);

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

  @$pb.TagNumber(7)
  $core.List<GattDescriptor> get descriptors => $_getList(6);
}

class GattDescriptor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptor', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'indexedUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $core.String? indexedUuid,
    $core.String? uuid,
  }) {
    final _result = create();
    if (indexedUuid != null) {
      _result.indexedUuid = indexedUuid;
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
  $core.String get indexedUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set indexedUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndexedUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set uuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);
}

class PeripheralDiscovery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PeripheralDiscovery', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rssi', $pb.PbFieldType.OS3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'advertisements', $pb.PbFieldType.OY)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectable')
    ..hasRequiredFields = false
  ;

  PeripheralDiscovery._() : super();
  factory PeripheralDiscovery({
    $core.String? uuid,
    $core.int? rssi,
    $core.List<$core.int>? advertisements,
    $core.bool? connectable,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (rssi != null) {
      _result.rssi = rssi;
    }
    if (advertisements != null) {
      _result.advertisements = advertisements;
    }
    if (connectable != null) {
      _result.connectable = connectable;
    }
    return _result;
  }
  factory PeripheralDiscovery.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PeripheralDiscovery.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PeripheralDiscovery clone() => PeripheralDiscovery()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PeripheralDiscovery copyWith(void Function(PeripheralDiscovery) updates) => super.copyWith((message) => updates(message as PeripheralDiscovery)) as PeripheralDiscovery; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PeripheralDiscovery create() => PeripheralDiscovery._();
  PeripheralDiscovery createEmptyInstance() => create();
  static $pb.PbList<PeripheralDiscovery> createRepeated() => $pb.PbList<PeripheralDiscovery>();
  @$core.pragma('dart2js:noInline')
  static PeripheralDiscovery getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeripheralDiscovery>(create);
  static PeripheralDiscovery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rssi => $_getIZ(1);
  @$pb.TagNumber(2)
  set rssi($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRssi() => $_has(1);
  @$pb.TagNumber(2)
  void clearRssi() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get advertisements => $_getN(2);
  @$pb.TagNumber(3)
  set advertisements($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAdvertisements() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdvertisements() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get connectable => $_getBF(3);
  @$pb.TagNumber(4)
  set connectable($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasConnectable() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectable() => clearField(4);
}

