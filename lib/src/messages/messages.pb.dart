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

enum Command_Command {
  centralStartDiscoveryArguments, 
  centralConnectArguments, 
  gattDisconnectArguments, 
  characteristicReadArguments, 
  characteristicWriteArguments, 
  characteristicNotifyArguments, 
  characteristicCancelNotifyArguments, 
  descriptorReadArguments, 
  descriptorWriteArguments, 
  notSet
}

class Command extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Command_Command> _Command_CommandByTag = {
    2 : Command_Command.centralStartDiscoveryArguments,
    3 : Command_Command.centralConnectArguments,
    4 : Command_Command.gattDisconnectArguments,
    5 : Command_Command.characteristicReadArguments,
    6 : Command_Command.characteristicWriteArguments,
    7 : Command_Command.characteristicNotifyArguments,
    8 : Command_Command.characteristicCancelNotifyArguments,
    9 : Command_Command.descriptorReadArguments,
    10 : Command_Command.descriptorWriteArguments,
    0 : Command_Command.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Command', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..e<CommandCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: CommandCategory.COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE, valueOf: CommandCategory.valueOf, enumValues: CommandCategory.values)
    ..aOM<CentralStartDiscoveryCommandArguments>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralStartDiscoveryArguments', subBuilder: CentralStartDiscoveryCommandArguments.create)
    ..aOM<CentralConnectCommandArguments>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralConnectArguments', subBuilder: CentralConnectCommandArguments.create)
    ..aOM<GattDisconnectCommandArguments>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattDisconnectArguments', subBuilder: GattDisconnectCommandArguments.create)
    ..aOM<CharacteristicReadCommandArguments>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicReadArguments', subBuilder: CharacteristicReadCommandArguments.create)
    ..aOM<CharacteristicWriteCommandArguments>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicWriteArguments', subBuilder: CharacteristicWriteCommandArguments.create)
    ..aOM<CharacteristicNotifyCommandArguments>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicNotifyArguments', subBuilder: CharacteristicNotifyCommandArguments.create)
    ..aOM<CharacteristicCancelNotifyCommandArguments>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicCancelNotifyArguments', subBuilder: CharacteristicCancelNotifyCommandArguments.create)
    ..aOM<DescriptorReadCommandArguments>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptorReadArguments', subBuilder: DescriptorReadCommandArguments.create)
    ..aOM<DescriptorWriteCommandArguments>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptorWriteArguments', subBuilder: DescriptorWriteCommandArguments.create)
    ..hasRequiredFields = false
  ;

  Command._() : super();
  factory Command({
    CommandCategory? category,
    CentralStartDiscoveryCommandArguments? centralStartDiscoveryArguments,
    CentralConnectCommandArguments? centralConnectArguments,
    GattDisconnectCommandArguments? gattDisconnectArguments,
    CharacteristicReadCommandArguments? characteristicReadArguments,
    CharacteristicWriteCommandArguments? characteristicWriteArguments,
    CharacteristicNotifyCommandArguments? characteristicNotifyArguments,
    CharacteristicCancelNotifyCommandArguments? characteristicCancelNotifyArguments,
    DescriptorReadCommandArguments? descriptorReadArguments,
    DescriptorWriteCommandArguments? descriptorWriteArguments,
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
    if (characteristicCancelNotifyArguments != null) {
      _result.characteristicCancelNotifyArguments = characteristicCancelNotifyArguments;
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

  Command_Command whichCommand() => _Command_CommandByTag[$_whichOneof(0)]!;
  void clearCommand() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CommandCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(CommandCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  CentralStartDiscoveryCommandArguments get centralStartDiscoveryArguments => $_getN(1);
  @$pb.TagNumber(2)
  set centralStartDiscoveryArguments(CentralStartDiscoveryCommandArguments v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCentralStartDiscoveryArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearCentralStartDiscoveryArguments() => clearField(2);
  @$pb.TagNumber(2)
  CentralStartDiscoveryCommandArguments ensureCentralStartDiscoveryArguments() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralConnectCommandArguments get centralConnectArguments => $_getN(2);
  @$pb.TagNumber(3)
  set centralConnectArguments(CentralConnectCommandArguments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralConnectArguments() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralConnectArguments() => clearField(3);
  @$pb.TagNumber(3)
  CentralConnectCommandArguments ensureCentralConnectArguments() => $_ensure(2);

  @$pb.TagNumber(4)
  GattDisconnectCommandArguments get gattDisconnectArguments => $_getN(3);
  @$pb.TagNumber(4)
  set gattDisconnectArguments(GattDisconnectCommandArguments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattDisconnectArguments() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattDisconnectArguments() => clearField(4);
  @$pb.TagNumber(4)
  GattDisconnectCommandArguments ensureGattDisconnectArguments() => $_ensure(3);

  @$pb.TagNumber(5)
  CharacteristicReadCommandArguments get characteristicReadArguments => $_getN(4);
  @$pb.TagNumber(5)
  set characteristicReadArguments(CharacteristicReadCommandArguments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCharacteristicReadArguments() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacteristicReadArguments() => clearField(5);
  @$pb.TagNumber(5)
  CharacteristicReadCommandArguments ensureCharacteristicReadArguments() => $_ensure(4);

  @$pb.TagNumber(6)
  CharacteristicWriteCommandArguments get characteristicWriteArguments => $_getN(5);
  @$pb.TagNumber(6)
  set characteristicWriteArguments(CharacteristicWriteCommandArguments v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCharacteristicWriteArguments() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacteristicWriteArguments() => clearField(6);
  @$pb.TagNumber(6)
  CharacteristicWriteCommandArguments ensureCharacteristicWriteArguments() => $_ensure(5);

  @$pb.TagNumber(7)
  CharacteristicNotifyCommandArguments get characteristicNotifyArguments => $_getN(6);
  @$pb.TagNumber(7)
  set characteristicNotifyArguments(CharacteristicNotifyCommandArguments v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCharacteristicNotifyArguments() => $_has(6);
  @$pb.TagNumber(7)
  void clearCharacteristicNotifyArguments() => clearField(7);
  @$pb.TagNumber(7)
  CharacteristicNotifyCommandArguments ensureCharacteristicNotifyArguments() => $_ensure(6);

  @$pb.TagNumber(8)
  CharacteristicCancelNotifyCommandArguments get characteristicCancelNotifyArguments => $_getN(7);
  @$pb.TagNumber(8)
  set characteristicCancelNotifyArguments(CharacteristicCancelNotifyCommandArguments v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCharacteristicCancelNotifyArguments() => $_has(7);
  @$pb.TagNumber(8)
  void clearCharacteristicCancelNotifyArguments() => clearField(8);
  @$pb.TagNumber(8)
  CharacteristicCancelNotifyCommandArguments ensureCharacteristicCancelNotifyArguments() => $_ensure(7);

  @$pb.TagNumber(9)
  DescriptorReadCommandArguments get descriptorReadArguments => $_getN(8);
  @$pb.TagNumber(9)
  set descriptorReadArguments(DescriptorReadCommandArguments v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescriptorReadArguments() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescriptorReadArguments() => clearField(9);
  @$pb.TagNumber(9)
  DescriptorReadCommandArguments ensureDescriptorReadArguments() => $_ensure(8);

  @$pb.TagNumber(10)
  DescriptorWriteCommandArguments get descriptorWriteArguments => $_getN(9);
  @$pb.TagNumber(10)
  set descriptorWriteArguments(DescriptorWriteCommandArguments v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasDescriptorWriteArguments() => $_has(9);
  @$pb.TagNumber(10)
  void clearDescriptorWriteArguments() => clearField(10);
  @$pb.TagNumber(10)
  DescriptorWriteCommandArguments ensureDescriptorWriteArguments() => $_ensure(9);
}

class CentralStartDiscoveryCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralStartDiscoveryCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuids')
    ..hasRequiredFields = false
  ;

  CentralStartDiscoveryCommandArguments._() : super();
  factory CentralStartDiscoveryCommandArguments({
    $core.Iterable<$core.String>? uuids,
  }) {
    final _result = create();
    if (uuids != null) {
      _result.uuids.addAll(uuids);
    }
    return _result;
  }
  factory CentralStartDiscoveryCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralStartDiscoveryCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryCommandArguments clone() => CentralStartDiscoveryCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryCommandArguments copyWith(void Function(CentralStartDiscoveryCommandArguments) updates) => super.copyWith((message) => updates(message as CentralStartDiscoveryCommandArguments)) as CentralStartDiscoveryCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryCommandArguments create() => CentralStartDiscoveryCommandArguments._();
  CentralStartDiscoveryCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CentralStartDiscoveryCommandArguments> createRepeated() => $pb.PbList<CentralStartDiscoveryCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralStartDiscoveryCommandArguments>(create);
  static CentralStartDiscoveryCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get uuids => $_getList(0);
}

class CentralConnectCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralConnectCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  CentralConnectCommandArguments._() : super();
  factory CentralConnectCommandArguments({
    $core.String? uuid,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    return _result;
  }
  factory CentralConnectCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralConnectCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralConnectCommandArguments clone() => CentralConnectCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralConnectCommandArguments copyWith(void Function(CentralConnectCommandArguments) updates) => super.copyWith((message) => updates(message as CentralConnectCommandArguments)) as CentralConnectCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralConnectCommandArguments create() => CentralConnectCommandArguments._();
  CentralConnectCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CentralConnectCommandArguments> createRepeated() => $pb.PbList<CentralConnectCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralConnectCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralConnectCommandArguments>(create);
  static CentralConnectCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
}

class GattDisconnectCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDisconnectCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  GattDisconnectCommandArguments._() : super();
  factory GattDisconnectCommandArguments({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory GattDisconnectCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDisconnectCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDisconnectCommandArguments clone() => GattDisconnectCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDisconnectCommandArguments copyWith(void Function(GattDisconnectCommandArguments) updates) => super.copyWith((message) => updates(message as GattDisconnectCommandArguments)) as GattDisconnectCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDisconnectCommandArguments create() => GattDisconnectCommandArguments._();
  GattDisconnectCommandArguments createEmptyInstance() => create();
  static $pb.PbList<GattDisconnectCommandArguments> createRepeated() => $pb.PbList<GattDisconnectCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static GattDisconnectCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDisconnectCommandArguments>(create);
  static GattDisconnectCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class CharacteristicReadCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicReadCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  CharacteristicReadCommandArguments._() : super();
  factory CharacteristicReadCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? id,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory CharacteristicReadCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicReadCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicReadCommandArguments clone() => CharacteristicReadCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicReadCommandArguments copyWith(void Function(CharacteristicReadCommandArguments) updates) => super.copyWith((message) => updates(message as CharacteristicReadCommandArguments)) as CharacteristicReadCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicReadCommandArguments create() => CharacteristicReadCommandArguments._();
  CharacteristicReadCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicReadCommandArguments> createRepeated() => $pb.PbList<CharacteristicReadCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicReadCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicReadCommandArguments>(create);
  static CharacteristicReadCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);
}

class CharacteristicWriteCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicWriteCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withoutResponse')
    ..hasRequiredFields = false
  ;

  CharacteristicWriteCommandArguments._() : super();
  factory CharacteristicWriteCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? id,
    $core.List<$core.int>? value,
    $core.bool? withoutResponse,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (value != null) {
      _result.value = value;
    }
    if (withoutResponse != null) {
      _result.withoutResponse = withoutResponse;
    }
    return _result;
  }
  factory CharacteristicWriteCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicWriteCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicWriteCommandArguments clone() => CharacteristicWriteCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicWriteCommandArguments copyWith(void Function(CharacteristicWriteCommandArguments) updates) => super.copyWith((message) => updates(message as CharacteristicWriteCommandArguments)) as CharacteristicWriteCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicWriteCommandArguments create() => CharacteristicWriteCommandArguments._();
  CharacteristicWriteCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicWriteCommandArguments> createRepeated() => $pb.PbList<CharacteristicWriteCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicWriteCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicWriteCommandArguments>(create);
  static CharacteristicWriteCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

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

class CharacteristicNotifyCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicNotifyCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  CharacteristicNotifyCommandArguments._() : super();
  factory CharacteristicNotifyCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? id,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory CharacteristicNotifyCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicNotifyCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicNotifyCommandArguments clone() => CharacteristicNotifyCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicNotifyCommandArguments copyWith(void Function(CharacteristicNotifyCommandArguments) updates) => super.copyWith((message) => updates(message as CharacteristicNotifyCommandArguments)) as CharacteristicNotifyCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicNotifyCommandArguments create() => CharacteristicNotifyCommandArguments._();
  CharacteristicNotifyCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicNotifyCommandArguments> createRepeated() => $pb.PbList<CharacteristicNotifyCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicNotifyCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicNotifyCommandArguments>(create);
  static CharacteristicNotifyCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);
}

class CharacteristicCancelNotifyCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicCancelNotifyCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  CharacteristicCancelNotifyCommandArguments._() : super();
  factory CharacteristicCancelNotifyCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? id,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory CharacteristicCancelNotifyCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicCancelNotifyCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicCancelNotifyCommandArguments clone() => CharacteristicCancelNotifyCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicCancelNotifyCommandArguments copyWith(void Function(CharacteristicCancelNotifyCommandArguments) updates) => super.copyWith((message) => updates(message as CharacteristicCancelNotifyCommandArguments)) as CharacteristicCancelNotifyCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicCancelNotifyCommandArguments create() => CharacteristicCancelNotifyCommandArguments._();
  CharacteristicCancelNotifyCommandArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicCancelNotifyCommandArguments> createRepeated() => $pb.PbList<CharacteristicCancelNotifyCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicCancelNotifyCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicCancelNotifyCommandArguments>(create);
  static CharacteristicCancelNotifyCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);
}

class DescriptorReadCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DescriptorReadCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DescriptorReadCommandArguments._() : super();
  factory DescriptorReadCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? characteristicId,
    $core.String? id,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (characteristicId != null) {
      _result.characteristicId = characteristicId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DescriptorReadCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DescriptorReadCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DescriptorReadCommandArguments clone() => DescriptorReadCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DescriptorReadCommandArguments copyWith(void Function(DescriptorReadCommandArguments) updates) => super.copyWith((message) => updates(message as DescriptorReadCommandArguments)) as DescriptorReadCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DescriptorReadCommandArguments create() => DescriptorReadCommandArguments._();
  DescriptorReadCommandArguments createEmptyInstance() => create();
  static $pb.PbList<DescriptorReadCommandArguments> createRepeated() => $pb.PbList<DescriptorReadCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static DescriptorReadCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DescriptorReadCommandArguments>(create);
  static DescriptorReadCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristicId => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristicId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get id => $_getSZ(3);
  @$pb.TagNumber(4)
  set id($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);
}

class DescriptorWriteCommandArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DescriptorWriteCommandArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  DescriptorWriteCommandArguments._() : super();
  factory DescriptorWriteCommandArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? characteristicId,
    $core.String? id,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (characteristicId != null) {
      _result.characteristicId = characteristicId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory DescriptorWriteCommandArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DescriptorWriteCommandArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DescriptorWriteCommandArguments clone() => DescriptorWriteCommandArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DescriptorWriteCommandArguments copyWith(void Function(DescriptorWriteCommandArguments) updates) => super.copyWith((message) => updates(message as DescriptorWriteCommandArguments)) as DescriptorWriteCommandArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DescriptorWriteCommandArguments create() => DescriptorWriteCommandArguments._();
  DescriptorWriteCommandArguments createEmptyInstance() => create();
  static $pb.PbList<DescriptorWriteCommandArguments> createRepeated() => $pb.PbList<DescriptorWriteCommandArguments>();
  @$core.pragma('dart2js:noInline')
  static DescriptorWriteCommandArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DescriptorWriteCommandArguments>(create);
  static DescriptorWriteCommandArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristicId => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristicId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get id => $_getSZ(3);
  @$pb.TagNumber(4)
  set id($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);
}

enum Reply_Arguments {
  bluetoothGetStateArguments, 
  centralConnectArguments, 
  characteristicReadArguments, 
  descriptorReadArguments, 
  notSet
}

class Reply extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Reply_Arguments> _Reply_ArgumentsByTag = {
    1 : Reply_Arguments.bluetoothGetStateArguments,
    2 : Reply_Arguments.centralConnectArguments,
    3 : Reply_Arguments.characteristicReadArguments,
    4 : Reply_Arguments.descriptorReadArguments,
    0 : Reply_Arguments.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Reply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<BluetoothGetStateReplyArguments>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bluetoothGetStateArguments', subBuilder: BluetoothGetStateReplyArguments.create)
    ..aOM<CentralConnectReplyArguments>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralConnectArguments', subBuilder: CentralConnectReplyArguments.create)
    ..aOM<CharacteristicReadReplyArguments>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicReadArguments', subBuilder: CharacteristicReadReplyArguments.create)
    ..aOM<DescriptorReadReplyArguments>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptorReadArguments', subBuilder: DescriptorReadReplyArguments.create)
    ..hasRequiredFields = false
  ;

  Reply._() : super();
  factory Reply({
    BluetoothGetStateReplyArguments? bluetoothGetStateArguments,
    CentralConnectReplyArguments? centralConnectArguments,
    CharacteristicReadReplyArguments? characteristicReadArguments,
    DescriptorReadReplyArguments? descriptorReadArguments,
  }) {
    final _result = create();
    if (bluetoothGetStateArguments != null) {
      _result.bluetoothGetStateArguments = bluetoothGetStateArguments;
    }
    if (centralConnectArguments != null) {
      _result.centralConnectArguments = centralConnectArguments;
    }
    if (characteristicReadArguments != null) {
      _result.characteristicReadArguments = characteristicReadArguments;
    }
    if (descriptorReadArguments != null) {
      _result.descriptorReadArguments = descriptorReadArguments;
    }
    return _result;
  }
  factory Reply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Reply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Reply clone() => Reply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Reply copyWith(void Function(Reply) updates) => super.copyWith((message) => updates(message as Reply)) as Reply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Reply create() => Reply._();
  Reply createEmptyInstance() => create();
  static $pb.PbList<Reply> createRepeated() => $pb.PbList<Reply>();
  @$core.pragma('dart2js:noInline')
  static Reply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reply>(create);
  static Reply? _defaultInstance;

  Reply_Arguments whichArguments() => _Reply_ArgumentsByTag[$_whichOneof(0)]!;
  void clearArguments() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BluetoothGetStateReplyArguments get bluetoothGetStateArguments => $_getN(0);
  @$pb.TagNumber(1)
  set bluetoothGetStateArguments(BluetoothGetStateReplyArguments v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBluetoothGetStateArguments() => $_has(0);
  @$pb.TagNumber(1)
  void clearBluetoothGetStateArguments() => clearField(1);
  @$pb.TagNumber(1)
  BluetoothGetStateReplyArguments ensureBluetoothGetStateArguments() => $_ensure(0);

  @$pb.TagNumber(2)
  CentralConnectReplyArguments get centralConnectArguments => $_getN(1);
  @$pb.TagNumber(2)
  set centralConnectArguments(CentralConnectReplyArguments v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCentralConnectArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearCentralConnectArguments() => clearField(2);
  @$pb.TagNumber(2)
  CentralConnectReplyArguments ensureCentralConnectArguments() => $_ensure(1);

  @$pb.TagNumber(3)
  CharacteristicReadReplyArguments get characteristicReadArguments => $_getN(2);
  @$pb.TagNumber(3)
  set characteristicReadArguments(CharacteristicReadReplyArguments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicReadArguments() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicReadArguments() => clearField(3);
  @$pb.TagNumber(3)
  CharacteristicReadReplyArguments ensureCharacteristicReadArguments() => $_ensure(2);

  @$pb.TagNumber(4)
  DescriptorReadReplyArguments get descriptorReadArguments => $_getN(3);
  @$pb.TagNumber(4)
  set descriptorReadArguments(DescriptorReadReplyArguments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescriptorReadArguments() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescriptorReadArguments() => clearField(4);
  @$pb.TagNumber(4)
  DescriptorReadReplyArguments ensureDescriptorReadArguments() => $_ensure(3);
}

class BluetoothGetStateReplyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothGetStateReplyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..e<BluetoothState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.BLUETOOTH_STATE_UNSUPPORTED, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..hasRequiredFields = false
  ;

  BluetoothGetStateReplyArguments._() : super();
  factory BluetoothGetStateReplyArguments({
    BluetoothState? state,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory BluetoothGetStateReplyArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothGetStateReplyArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothGetStateReplyArguments clone() => BluetoothGetStateReplyArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothGetStateReplyArguments copyWith(void Function(BluetoothGetStateReplyArguments) updates) => super.copyWith((message) => updates(message as BluetoothGetStateReplyArguments)) as BluetoothGetStateReplyArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothGetStateReplyArguments create() => BluetoothGetStateReplyArguments._();
  BluetoothGetStateReplyArguments createEmptyInstance() => create();
  static $pb.PbList<BluetoothGetStateReplyArguments> createRepeated() => $pb.PbList<BluetoothGetStateReplyArguments>();
  @$core.pragma('dart2js:noInline')
  static BluetoothGetStateReplyArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothGetStateReplyArguments>(create);
  static BluetoothGetStateReplyArguments? _defaultInstance;

  @$pb.TagNumber(1)
  BluetoothState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(BluetoothState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);
}

class CentralConnectReplyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralConnectReplyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOM<GATT>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gatt', subBuilder: GATT.create)
    ..hasRequiredFields = false
  ;

  CentralConnectReplyArguments._() : super();
  factory CentralConnectReplyArguments({
    GATT? gatt,
  }) {
    final _result = create();
    if (gatt != null) {
      _result.gatt = gatt;
    }
    return _result;
  }
  factory CentralConnectReplyArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralConnectReplyArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralConnectReplyArguments clone() => CentralConnectReplyArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralConnectReplyArguments copyWith(void Function(CentralConnectReplyArguments) updates) => super.copyWith((message) => updates(message as CentralConnectReplyArguments)) as CentralConnectReplyArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralConnectReplyArguments create() => CentralConnectReplyArguments._();
  CentralConnectReplyArguments createEmptyInstance() => create();
  static $pb.PbList<CentralConnectReplyArguments> createRepeated() => $pb.PbList<CentralConnectReplyArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralConnectReplyArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralConnectReplyArguments>(create);
  static CentralConnectReplyArguments? _defaultInstance;

  @$pb.TagNumber(1)
  GATT get gatt => $_getN(0);
  @$pb.TagNumber(1)
  set gatt(GATT v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasGatt() => $_has(0);
  @$pb.TagNumber(1)
  void clearGatt() => clearField(1);
  @$pb.TagNumber(1)
  GATT ensureGatt() => $_ensure(0);
}

class CharacteristicReadReplyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicReadReplyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CharacteristicReadReplyArguments._() : super();
  factory CharacteristicReadReplyArguments({
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory CharacteristicReadReplyArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicReadReplyArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicReadReplyArguments clone() => CharacteristicReadReplyArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicReadReplyArguments copyWith(void Function(CharacteristicReadReplyArguments) updates) => super.copyWith((message) => updates(message as CharacteristicReadReplyArguments)) as CharacteristicReadReplyArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicReadReplyArguments create() => CharacteristicReadReplyArguments._();
  CharacteristicReadReplyArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicReadReplyArguments> createRepeated() => $pb.PbList<CharacteristicReadReplyArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicReadReplyArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicReadReplyArguments>(create);
  static CharacteristicReadReplyArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class DescriptorReadReplyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DescriptorReadReplyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  DescriptorReadReplyArguments._() : super();
  factory DescriptorReadReplyArguments({
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory DescriptorReadReplyArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DescriptorReadReplyArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DescriptorReadReplyArguments clone() => DescriptorReadReplyArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DescriptorReadReplyArguments copyWith(void Function(DescriptorReadReplyArguments) updates) => super.copyWith((message) => updates(message as DescriptorReadReplyArguments)) as DescriptorReadReplyArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DescriptorReadReplyArguments create() => DescriptorReadReplyArguments._();
  DescriptorReadReplyArguments createEmptyInstance() => create();
  static $pb.PbList<DescriptorReadReplyArguments> createRepeated() => $pb.PbList<DescriptorReadReplyArguments>();
  @$core.pragma('dart2js:noInline')
  static DescriptorReadReplyArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DescriptorReadReplyArguments>(create);
  static DescriptorReadReplyArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

enum Event_Event {
  bluetoothStateChangedArguments, 
  centralDiscoveredArguments, 
  gattConnectionLostArguments, 
  characteristicNotifiedArguments, 
  notSet
}

class Event extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Event_Event> _Event_EventByTag = {
    2 : Event_Event.bluetoothStateChangedArguments,
    3 : Event_Event.centralDiscoveredArguments,
    4 : Event_Event.gattConnectionLostArguments,
    5 : Event_Event.characteristicNotifiedArguments,
    0 : Event_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Event', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..e<EventCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED, valueOf: EventCategory.valueOf, enumValues: EventCategory.values)
    ..aOM<BluetoothStateChangedEventArguments>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bluetoothStateChangedArguments', subBuilder: BluetoothStateChangedEventArguments.create)
    ..aOM<CentralDiscoveredEventArguments>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralDiscoveredArguments', subBuilder: CentralDiscoveredEventArguments.create)
    ..aOM<GattConnectionLostEventArguments>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattConnectionLostArguments', subBuilder: GattConnectionLostEventArguments.create)
    ..aOM<CharacteristicNotifiedEventArguments>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicNotifiedArguments', subBuilder: CharacteristicNotifiedEventArguments.create)
    ..hasRequiredFields = false
  ;

  Event._() : super();
  factory Event({
    EventCategory? category,
    BluetoothStateChangedEventArguments? bluetoothStateChangedArguments,
    CentralDiscoveredEventArguments? centralDiscoveredArguments,
    GattConnectionLostEventArguments? gattConnectionLostArguments,
    CharacteristicNotifiedEventArguments? characteristicNotifiedArguments,
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
    if (characteristicNotifiedArguments != null) {
      _result.characteristicNotifiedArguments = characteristicNotifiedArguments;
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

  Event_Event whichEvent() => _Event_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EventCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(EventCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  BluetoothStateChangedEventArguments get bluetoothStateChangedArguments => $_getN(1);
  @$pb.TagNumber(2)
  set bluetoothStateChangedArguments(BluetoothStateChangedEventArguments v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBluetoothStateChangedArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearBluetoothStateChangedArguments() => clearField(2);
  @$pb.TagNumber(2)
  BluetoothStateChangedEventArguments ensureBluetoothStateChangedArguments() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralDiscoveredEventArguments get centralDiscoveredArguments => $_getN(2);
  @$pb.TagNumber(3)
  set centralDiscoveredArguments(CentralDiscoveredEventArguments v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralDiscoveredArguments() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralDiscoveredArguments() => clearField(3);
  @$pb.TagNumber(3)
  CentralDiscoveredEventArguments ensureCentralDiscoveredArguments() => $_ensure(2);

  @$pb.TagNumber(4)
  GattConnectionLostEventArguments get gattConnectionLostArguments => $_getN(3);
  @$pb.TagNumber(4)
  set gattConnectionLostArguments(GattConnectionLostEventArguments v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattConnectionLostArguments() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattConnectionLostArguments() => clearField(4);
  @$pb.TagNumber(4)
  GattConnectionLostEventArguments ensureGattConnectionLostArguments() => $_ensure(3);

  @$pb.TagNumber(5)
  CharacteristicNotifiedEventArguments get characteristicNotifiedArguments => $_getN(4);
  @$pb.TagNumber(5)
  set characteristicNotifiedArguments(CharacteristicNotifiedEventArguments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCharacteristicNotifiedArguments() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacteristicNotifiedArguments() => clearField(5);
  @$pb.TagNumber(5)
  CharacteristicNotifiedEventArguments ensureCharacteristicNotifiedArguments() => $_ensure(4);
}

class BluetoothStateChangedEventArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothStateChangedEventArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..e<BluetoothState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.BLUETOOTH_STATE_UNSUPPORTED, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..hasRequiredFields = false
  ;

  BluetoothStateChangedEventArguments._() : super();
  factory BluetoothStateChangedEventArguments({
    BluetoothState? state,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory BluetoothStateChangedEventArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothStateChangedEventArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedEventArguments clone() => BluetoothStateChangedEventArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedEventArguments copyWith(void Function(BluetoothStateChangedEventArguments) updates) => super.copyWith((message) => updates(message as BluetoothStateChangedEventArguments)) as BluetoothStateChangedEventArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedEventArguments create() => BluetoothStateChangedEventArguments._();
  BluetoothStateChangedEventArguments createEmptyInstance() => create();
  static $pb.PbList<BluetoothStateChangedEventArguments> createRepeated() => $pb.PbList<BluetoothStateChangedEventArguments>();
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedEventArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothStateChangedEventArguments>(create);
  static BluetoothStateChangedEventArguments? _defaultInstance;

  @$pb.TagNumber(1)
  BluetoothState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(BluetoothState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);
}

class CentralDiscoveredEventArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralDiscoveredEventArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOM<Discovery>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'discovery', subBuilder: Discovery.create)
    ..hasRequiredFields = false
  ;

  CentralDiscoveredEventArguments._() : super();
  factory CentralDiscoveredEventArguments({
    Discovery? discovery,
  }) {
    final _result = create();
    if (discovery != null) {
      _result.discovery = discovery;
    }
    return _result;
  }
  factory CentralDiscoveredEventArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralDiscoveredEventArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralDiscoveredEventArguments clone() => CentralDiscoveredEventArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralDiscoveredEventArguments copyWith(void Function(CentralDiscoveredEventArguments) updates) => super.copyWith((message) => updates(message as CentralDiscoveredEventArguments)) as CentralDiscoveredEventArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredEventArguments create() => CentralDiscoveredEventArguments._();
  CentralDiscoveredEventArguments createEmptyInstance() => create();
  static $pb.PbList<CentralDiscoveredEventArguments> createRepeated() => $pb.PbList<CentralDiscoveredEventArguments>();
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredEventArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralDiscoveredEventArguments>(create);
  static CentralDiscoveredEventArguments? _defaultInstance;

  @$pb.TagNumber(1)
  Discovery get discovery => $_getN(0);
  @$pb.TagNumber(1)
  set discovery(Discovery v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDiscovery() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiscovery() => clearField(1);
  @$pb.TagNumber(1)
  Discovery ensureDiscovery() => $_ensure(0);
}

class GattConnectionLostEventArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattConnectionLostEventArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorCode', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GattConnectionLostEventArguments._() : super();
  factory GattConnectionLostEventArguments({
    $core.String? id,
    $core.int? errorCode,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (errorCode != null) {
      _result.errorCode = errorCode;
    }
    return _result;
  }
  factory GattConnectionLostEventArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattConnectionLostEventArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattConnectionLostEventArguments clone() => GattConnectionLostEventArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattConnectionLostEventArguments copyWith(void Function(GattConnectionLostEventArguments) updates) => super.copyWith((message) => updates(message as GattConnectionLostEventArguments)) as GattConnectionLostEventArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostEventArguments create() => GattConnectionLostEventArguments._();
  GattConnectionLostEventArguments createEmptyInstance() => create();
  static $pb.PbList<GattConnectionLostEventArguments> createRepeated() => $pb.PbList<GattConnectionLostEventArguments>();
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostEventArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattConnectionLostEventArguments>(create);
  static GattConnectionLostEventArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get errorCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set errorCode($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorCode() => clearField(2);
}

class CharacteristicNotifiedEventArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicNotifiedEventArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CharacteristicNotifiedEventArguments._() : super();
  factory CharacteristicNotifiedEventArguments({
    $core.String? gattId,
    $core.String? serviceId,
    $core.String? id,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (gattId != null) {
      _result.gattId = gattId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory CharacteristicNotifiedEventArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicNotifiedEventArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicNotifiedEventArguments clone() => CharacteristicNotifiedEventArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicNotifiedEventArguments copyWith(void Function(CharacteristicNotifiedEventArguments) updates) => super.copyWith((message) => updates(message as CharacteristicNotifiedEventArguments)) as CharacteristicNotifiedEventArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicNotifiedEventArguments create() => CharacteristicNotifiedEventArguments._();
  CharacteristicNotifiedEventArguments createEmptyInstance() => create();
  static $pb.PbList<CharacteristicNotifiedEventArguments> createRepeated() => $pb.PbList<CharacteristicNotifiedEventArguments>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicNotifiedEventArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicNotifiedEventArguments>(create);
  static CharacteristicNotifiedEventArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);
}

class Discovery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Discovery', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rssi', $pb.PbFieldType.OS3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'advertisements', $pb.PbFieldType.OY)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectable')
    ..hasRequiredFields = false
  ;

  Discovery._() : super();
  factory Discovery({
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
  factory Discovery.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Discovery.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Discovery clone() => Discovery()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Discovery copyWith(void Function(Discovery) updates) => super.copyWith((message) => updates(message as Discovery)) as Discovery; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Discovery create() => Discovery._();
  Discovery createEmptyInstance() => create();
  static $pb.PbList<Discovery> createRepeated() => $pb.PbList<Discovery>();
  @$core.pragma('dart2js:noInline')
  static Discovery getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Discovery>(create);
  static Discovery? _defaultInstance;

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

class GATT extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GATT', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maximumWriteLength', $pb.PbFieldType.O3)
    ..pc<GattService>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: GattService.create)
    ..hasRequiredFields = false
  ;

  GATT._() : super();
  factory GATT({
    $core.String? id,
    $core.int? maximumWriteLength,
    $core.Iterable<GattService>? services,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
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

  @$pb.TagNumber(3)
  $core.List<GattService> get services => $_getList(2);
}

class GattService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattService', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattCharacteristic>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: GattCharacteristic.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $core.String? id,
    $core.String? uuid,
    $core.Iterable<GattCharacteristic>? characteristics,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
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
    $core.String? id,
    $core.String? uuid,
    $core.bool? canRead,
    $core.bool? canWrite,
    $core.bool? canWriteWithoutResponse,
    $core.bool? canNotify,
    $core.Iterable<GattDescriptor>? descriptors,
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptor', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy.messages'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $core.String? id,
    $core.String? uuid,
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set uuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUuid() => clearField(2);
}

