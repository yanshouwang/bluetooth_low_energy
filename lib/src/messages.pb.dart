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

enum Command_Stub {
  centralStartDiscoveryCommand, 
  centralConnectCommand, 
  gattDisconnectCommand, 
  gattCharacteristicReadCommand, 
  gattCharacteristicWriteCommand, 
  gattCharacteristicNotifyCommand, 
  gattDescriptorReadCommand, 
  gattDescriptorWriteCommand, 
  notSet
}

class Command extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Command_Stub> _Command_StubByTag = {
    2 : Command_Stub.centralStartDiscoveryCommand,
    3 : Command_Stub.centralConnectCommand,
    4 : Command_Stub.gattDisconnectCommand,
    5 : Command_Stub.gattCharacteristicReadCommand,
    6 : Command_Stub.gattCharacteristicWriteCommand,
    7 : Command_Stub.gattCharacteristicNotifyCommand,
    8 : Command_Stub.gattDescriptorReadCommand,
    9 : Command_Stub.gattDescriptorWriteCommand,
    0 : Command_Stub.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Command', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9])
    ..e<CommandCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE, valueOf: CommandCategory.valueOf, enumValues: CommandCategory.values)
    ..aOM<CentralStartDiscoveryCommand>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralStartDiscoveryCommand', subBuilder: CentralStartDiscoveryCommand.create)
    ..aOM<CentralConnectCommand>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralConnectCommand', subBuilder: CentralConnectCommand.create)
    ..aOM<GattDisconnectCommand>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattDisconnectCommand', subBuilder: GattDisconnectCommand.create)
    ..aOM<GattCharacteristicReadCommand>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicReadCommand', subBuilder: GattCharacteristicReadCommand.create)
    ..aOM<GattCharacteristicWriteCommand>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicWriteCommand', subBuilder: GattCharacteristicWriteCommand.create)
    ..aOM<GattCharacteristicNotifyCommand>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicNotifyCommand', subBuilder: GattCharacteristicNotifyCommand.create)
    ..aOM<GattDescriptorReadCommand>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattDescriptorReadCommand', subBuilder: GattDescriptorReadCommand.create)
    ..aOM<GattDescriptorWriteCommand>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattDescriptorWriteCommand', subBuilder: GattDescriptorWriteCommand.create)
    ..hasRequiredFields = false
  ;

  Command._() : super();
  factory Command({
    CommandCategory? category,
    CentralStartDiscoveryCommand? centralStartDiscoveryCommand,
    CentralConnectCommand? centralConnectCommand,
    GattDisconnectCommand? gattDisconnectCommand,
    GattCharacteristicReadCommand? gattCharacteristicReadCommand,
    GattCharacteristicWriteCommand? gattCharacteristicWriteCommand,
    GattCharacteristicNotifyCommand? gattCharacteristicNotifyCommand,
    GattDescriptorReadCommand? gattDescriptorReadCommand,
    GattDescriptorWriteCommand? gattDescriptorWriteCommand,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (centralStartDiscoveryCommand != null) {
      _result.centralStartDiscoveryCommand = centralStartDiscoveryCommand;
    }
    if (centralConnectCommand != null) {
      _result.centralConnectCommand = centralConnectCommand;
    }
    if (gattDisconnectCommand != null) {
      _result.gattDisconnectCommand = gattDisconnectCommand;
    }
    if (gattCharacteristicReadCommand != null) {
      _result.gattCharacteristicReadCommand = gattCharacteristicReadCommand;
    }
    if (gattCharacteristicWriteCommand != null) {
      _result.gattCharacteristicWriteCommand = gattCharacteristicWriteCommand;
    }
    if (gattCharacteristicNotifyCommand != null) {
      _result.gattCharacteristicNotifyCommand = gattCharacteristicNotifyCommand;
    }
    if (gattDescriptorReadCommand != null) {
      _result.gattDescriptorReadCommand = gattDescriptorReadCommand;
    }
    if (gattDescriptorWriteCommand != null) {
      _result.gattDescriptorWriteCommand = gattDescriptorWriteCommand;
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

  Command_Stub whichStub() => _Command_StubByTag[$_whichOneof(0)]!;
  void clearStub() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CommandCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(CommandCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  CentralStartDiscoveryCommand get centralStartDiscoveryCommand => $_getN(1);
  @$pb.TagNumber(2)
  set centralStartDiscoveryCommand(CentralStartDiscoveryCommand v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCentralStartDiscoveryCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCentralStartDiscoveryCommand() => clearField(2);
  @$pb.TagNumber(2)
  CentralStartDiscoveryCommand ensureCentralStartDiscoveryCommand() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralConnectCommand get centralConnectCommand => $_getN(2);
  @$pb.TagNumber(3)
  set centralConnectCommand(CentralConnectCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralConnectCommand() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralConnectCommand() => clearField(3);
  @$pb.TagNumber(3)
  CentralConnectCommand ensureCentralConnectCommand() => $_ensure(2);

  @$pb.TagNumber(4)
  GattDisconnectCommand get gattDisconnectCommand => $_getN(3);
  @$pb.TagNumber(4)
  set gattDisconnectCommand(GattDisconnectCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattDisconnectCommand() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattDisconnectCommand() => clearField(4);
  @$pb.TagNumber(4)
  GattDisconnectCommand ensureGattDisconnectCommand() => $_ensure(3);

  @$pb.TagNumber(5)
  GattCharacteristicReadCommand get gattCharacteristicReadCommand => $_getN(4);
  @$pb.TagNumber(5)
  set gattCharacteristicReadCommand(GattCharacteristicReadCommand v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasGattCharacteristicReadCommand() => $_has(4);
  @$pb.TagNumber(5)
  void clearGattCharacteristicReadCommand() => clearField(5);
  @$pb.TagNumber(5)
  GattCharacteristicReadCommand ensureGattCharacteristicReadCommand() => $_ensure(4);

  @$pb.TagNumber(6)
  GattCharacteristicWriteCommand get gattCharacteristicWriteCommand => $_getN(5);
  @$pb.TagNumber(6)
  set gattCharacteristicWriteCommand(GattCharacteristicWriteCommand v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGattCharacteristicWriteCommand() => $_has(5);
  @$pb.TagNumber(6)
  void clearGattCharacteristicWriteCommand() => clearField(6);
  @$pb.TagNumber(6)
  GattCharacteristicWriteCommand ensureGattCharacteristicWriteCommand() => $_ensure(5);

  @$pb.TagNumber(7)
  GattCharacteristicNotifyCommand get gattCharacteristicNotifyCommand => $_getN(6);
  @$pb.TagNumber(7)
  set gattCharacteristicNotifyCommand(GattCharacteristicNotifyCommand v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasGattCharacteristicNotifyCommand() => $_has(6);
  @$pb.TagNumber(7)
  void clearGattCharacteristicNotifyCommand() => clearField(7);
  @$pb.TagNumber(7)
  GattCharacteristicNotifyCommand ensureGattCharacteristicNotifyCommand() => $_ensure(6);

  @$pb.TagNumber(8)
  GattDescriptorReadCommand get gattDescriptorReadCommand => $_getN(7);
  @$pb.TagNumber(8)
  set gattDescriptorReadCommand(GattDescriptorReadCommand v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasGattDescriptorReadCommand() => $_has(7);
  @$pb.TagNumber(8)
  void clearGattDescriptorReadCommand() => clearField(8);
  @$pb.TagNumber(8)
  GattDescriptorReadCommand ensureGattDescriptorReadCommand() => $_ensure(7);

  @$pb.TagNumber(9)
  GattDescriptorWriteCommand get gattDescriptorWriteCommand => $_getN(8);
  @$pb.TagNumber(9)
  set gattDescriptorWriteCommand(GattDescriptorWriteCommand v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasGattDescriptorWriteCommand() => $_has(8);
  @$pb.TagNumber(9)
  void clearGattDescriptorWriteCommand() => clearField(9);
  @$pb.TagNumber(9)
  GattDescriptorWriteCommand ensureGattDescriptorWriteCommand() => $_ensure(8);
}

class CentralStartDiscoveryCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralStartDiscoveryCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuids')
    ..hasRequiredFields = false
  ;

  CentralStartDiscoveryCommand._() : super();
  factory CentralStartDiscoveryCommand({
    $core.Iterable<$core.String>? uuids,
  }) {
    final _result = create();
    if (uuids != null) {
      _result.uuids.addAll(uuids);
    }
    return _result;
  }
  factory CentralStartDiscoveryCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralStartDiscoveryCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryCommand clone() => CentralStartDiscoveryCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralStartDiscoveryCommand copyWith(void Function(CentralStartDiscoveryCommand) updates) => super.copyWith((message) => updates(message as CentralStartDiscoveryCommand)) as CentralStartDiscoveryCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryCommand create() => CentralStartDiscoveryCommand._();
  CentralStartDiscoveryCommand createEmptyInstance() => create();
  static $pb.PbList<CentralStartDiscoveryCommand> createRepeated() => $pb.PbList<CentralStartDiscoveryCommand>();
  @$core.pragma('dart2js:noInline')
  static CentralStartDiscoveryCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralStartDiscoveryCommand>(create);
  static CentralStartDiscoveryCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get uuids => $_getList(0);
}

class CentralConnectCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralConnectCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  CentralConnectCommand._() : super();
  factory CentralConnectCommand({
    $core.String? uuid,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    return _result;
  }
  factory CentralConnectCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralConnectCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralConnectCommand clone() => CentralConnectCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralConnectCommand copyWith(void Function(CentralConnectCommand) updates) => super.copyWith((message) => updates(message as CentralConnectCommand)) as CentralConnectCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralConnectCommand create() => CentralConnectCommand._();
  CentralConnectCommand createEmptyInstance() => create();
  static $pb.PbList<CentralConnectCommand> createRepeated() => $pb.PbList<CentralConnectCommand>();
  @$core.pragma('dart2js:noInline')
  static CentralConnectCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralConnectCommand>(create);
  static CentralConnectCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
}

class GattDisconnectCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDisconnectCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..hasRequiredFields = false
  ;

  GattDisconnectCommand._() : super();
  factory GattDisconnectCommand({
    $core.String? hashUuid,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    return _result;
  }
  factory GattDisconnectCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDisconnectCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDisconnectCommand clone() => GattDisconnectCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDisconnectCommand copyWith(void Function(GattDisconnectCommand) updates) => super.copyWith((message) => updates(message as GattDisconnectCommand)) as GattDisconnectCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDisconnectCommand create() => GattDisconnectCommand._();
  GattDisconnectCommand createEmptyInstance() => create();
  static $pb.PbList<GattDisconnectCommand> createRepeated() => $pb.PbList<GattDisconnectCommand>();
  @$core.pragma('dart2js:noInline')
  static GattDisconnectCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDisconnectCommand>(create);
  static GattDisconnectCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);
}

class GattCharacteristicReadCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicReadCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..hasRequiredFields = false
  ;

  GattCharacteristicReadCommand._() : super();
  factory GattCharacteristicReadCommand({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? hashUuid,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    return _result;
  }
  factory GattCharacteristicReadCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicReadCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicReadCommand clone() => GattCharacteristicReadCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicReadCommand copyWith(void Function(GattCharacteristicReadCommand) updates) => super.copyWith((message) => updates(message as GattCharacteristicReadCommand)) as GattCharacteristicReadCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicReadCommand create() => GattCharacteristicReadCommand._();
  GattCharacteristicReadCommand createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicReadCommand> createRepeated() => $pb.PbList<GattCharacteristicReadCommand>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicReadCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicReadCommand>(create);
  static GattCharacteristicReadCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get hashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set hashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashUuid() => clearField(3);
}

class GattCharacteristicWriteCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicWriteCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withoutResponse')
    ..hasRequiredFields = false
  ;

  GattCharacteristicWriteCommand._() : super();
  factory GattCharacteristicWriteCommand({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? hashUuid,
    $core.List<$core.int>? value,
    $core.bool? withoutResponse,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    if (withoutResponse != null) {
      _result.withoutResponse = withoutResponse;
    }
    return _result;
  }
  factory GattCharacteristicWriteCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicWriteCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicWriteCommand clone() => GattCharacteristicWriteCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicWriteCommand copyWith(void Function(GattCharacteristicWriteCommand) updates) => super.copyWith((message) => updates(message as GattCharacteristicWriteCommand)) as GattCharacteristicWriteCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicWriteCommand create() => GattCharacteristicWriteCommand._();
  GattCharacteristicWriteCommand createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicWriteCommand> createRepeated() => $pb.PbList<GattCharacteristicWriteCommand>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicWriteCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicWriteCommand>(create);
  static GattCharacteristicWriteCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get hashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set hashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashUuid() => clearField(3);

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

class GattCharacteristicNotifyCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicNotifyCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false
  ;

  GattCharacteristicNotifyCommand._() : super();
  factory GattCharacteristicNotifyCommand({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? hashUuid,
    $core.bool? state,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory GattCharacteristicNotifyCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicNotifyCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicNotifyCommand clone() => GattCharacteristicNotifyCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicNotifyCommand copyWith(void Function(GattCharacteristicNotifyCommand) updates) => super.copyWith((message) => updates(message as GattCharacteristicNotifyCommand)) as GattCharacteristicNotifyCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicNotifyCommand create() => GattCharacteristicNotifyCommand._();
  GattCharacteristicNotifyCommand createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicNotifyCommand> createRepeated() => $pb.PbList<GattCharacteristicNotifyCommand>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicNotifyCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicNotifyCommand>(create);
  static GattCharacteristicNotifyCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get hashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set hashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get state => $_getBF(3);
  @$pb.TagNumber(4)
  set state($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => clearField(4);
}

class GattDescriptorReadCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorReadCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicHashUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..hasRequiredFields = false
  ;

  GattDescriptorReadCommand._() : super();
  factory GattDescriptorReadCommand({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? gattCharacteristicHashUuid,
    $core.String? hashUuid,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (gattCharacteristicHashUuid != null) {
      _result.gattCharacteristicHashUuid = gattCharacteristicHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    return _result;
  }
  factory GattDescriptorReadCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDescriptorReadCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDescriptorReadCommand clone() => GattDescriptorReadCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDescriptorReadCommand copyWith(void Function(GattDescriptorReadCommand) updates) => super.copyWith((message) => updates(message as GattDescriptorReadCommand)) as GattDescriptorReadCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDescriptorReadCommand create() => GattDescriptorReadCommand._();
  GattDescriptorReadCommand createEmptyInstance() => create();
  static $pb.PbList<GattDescriptorReadCommand> createRepeated() => $pb.PbList<GattDescriptorReadCommand>();
  @$core.pragma('dart2js:noInline')
  static GattDescriptorReadCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDescriptorReadCommand>(create);
  static GattDescriptorReadCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get gattCharacteristicHashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set gattCharacteristicHashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGattCharacteristicHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearGattCharacteristicHashUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get hashUuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set hashUuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHashUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearHashUuid() => clearField(4);
}

class GattDescriptorWriteCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorWriteCommand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicHashUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattDescriptorWriteCommand._() : super();
  factory GattDescriptorWriteCommand({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? gattCharacteristicHashUuid,
    $core.String? hashUuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (gattCharacteristicHashUuid != null) {
      _result.gattCharacteristicHashUuid = gattCharacteristicHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GattDescriptorWriteCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattDescriptorWriteCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattDescriptorWriteCommand clone() => GattDescriptorWriteCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattDescriptorWriteCommand copyWith(void Function(GattDescriptorWriteCommand) updates) => super.copyWith((message) => updates(message as GattDescriptorWriteCommand)) as GattDescriptorWriteCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattDescriptorWriteCommand create() => GattDescriptorWriteCommand._();
  GattDescriptorWriteCommand createEmptyInstance() => create();
  static $pb.PbList<GattDescriptorWriteCommand> createRepeated() => $pb.PbList<GattDescriptorWriteCommand>();
  @$core.pragma('dart2js:noInline')
  static GattDescriptorWriteCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattDescriptorWriteCommand>(create);
  static GattDescriptorWriteCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get gattCharacteristicHashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set gattCharacteristicHashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGattCharacteristicHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearGattCharacteristicHashUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get hashUuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set hashUuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHashUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearHashUuid() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);
}

class CentralConnectReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralConnectReply', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOM<GATT>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gatt', subBuilder: GATT.create)
    ..hasRequiredFields = false
  ;

  CentralConnectReply._() : super();
  factory CentralConnectReply({
    GATT? gatt,
  }) {
    final _result = create();
    if (gatt != null) {
      _result.gatt = gatt;
    }
    return _result;
  }
  factory CentralConnectReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralConnectReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralConnectReply clone() => CentralConnectReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralConnectReply copyWith(void Function(CentralConnectReply) updates) => super.copyWith((message) => updates(message as CentralConnectReply)) as CentralConnectReply; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralConnectReply create() => CentralConnectReply._();
  CentralConnectReply createEmptyInstance() => create();
  static $pb.PbList<CentralConnectReply> createRepeated() => $pb.PbList<CentralConnectReply>();
  @$core.pragma('dart2js:noInline')
  static CentralConnectReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralConnectReply>(create);
  static CentralConnectReply? _defaultInstance;

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

enum Event_Stub {
  bluetoothStateChangedEvent, 
  centralDiscoveredEvent, 
  gattConnectionLostEvent, 
  gattCharacteristicValueChangedEvent, 
  notSet
}

class Event extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Event_Stub> _Event_StubByTag = {
    2 : Event_Stub.bluetoothStateChangedEvent,
    3 : Event_Stub.centralDiscoveredEvent,
    4 : Event_Stub.gattConnectionLostEvent,
    5 : Event_Stub.gattCharacteristicValueChangedEvent,
    0 : Event_Stub.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Event', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..e<EventCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED, valueOf: EventCategory.valueOf, enumValues: EventCategory.values)
    ..aOM<BluetoothStateChangedEvent>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bluetoothStateChangedEvent', subBuilder: BluetoothStateChangedEvent.create)
    ..aOM<CentralDiscoveredEvent>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'centralDiscoveredEvent', subBuilder: CentralDiscoveredEvent.create)
    ..aOM<GattConnectionLostEvent>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattConnectionLostEvent', subBuilder: GattConnectionLostEvent.create)
    ..aOM<GattCharacteristicValueChangedEvent>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattCharacteristicValueChangedEvent', subBuilder: GattCharacteristicValueChangedEvent.create)
    ..hasRequiredFields = false
  ;

  Event._() : super();
  factory Event({
    EventCategory? category,
    BluetoothStateChangedEvent? bluetoothStateChangedEvent,
    CentralDiscoveredEvent? centralDiscoveredEvent,
    GattConnectionLostEvent? gattConnectionLostEvent,
    GattCharacteristicValueChangedEvent? gattCharacteristicValueChangedEvent,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (bluetoothStateChangedEvent != null) {
      _result.bluetoothStateChangedEvent = bluetoothStateChangedEvent;
    }
    if (centralDiscoveredEvent != null) {
      _result.centralDiscoveredEvent = centralDiscoveredEvent;
    }
    if (gattConnectionLostEvent != null) {
      _result.gattConnectionLostEvent = gattConnectionLostEvent;
    }
    if (gattCharacteristicValueChangedEvent != null) {
      _result.gattCharacteristicValueChangedEvent = gattCharacteristicValueChangedEvent;
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

  Event_Stub whichStub() => _Event_StubByTag[$_whichOneof(0)]!;
  void clearStub() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EventCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(EventCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  BluetoothStateChangedEvent get bluetoothStateChangedEvent => $_getN(1);
  @$pb.TagNumber(2)
  set bluetoothStateChangedEvent(BluetoothStateChangedEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBluetoothStateChangedEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearBluetoothStateChangedEvent() => clearField(2);
  @$pb.TagNumber(2)
  BluetoothStateChangedEvent ensureBluetoothStateChangedEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  CentralDiscoveredEvent get centralDiscoveredEvent => $_getN(2);
  @$pb.TagNumber(3)
  set centralDiscoveredEvent(CentralDiscoveredEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCentralDiscoveredEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearCentralDiscoveredEvent() => clearField(3);
  @$pb.TagNumber(3)
  CentralDiscoveredEvent ensureCentralDiscoveredEvent() => $_ensure(2);

  @$pb.TagNumber(4)
  GattConnectionLostEvent get gattConnectionLostEvent => $_getN(3);
  @$pb.TagNumber(4)
  set gattConnectionLostEvent(GattConnectionLostEvent v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGattConnectionLostEvent() => $_has(3);
  @$pb.TagNumber(4)
  void clearGattConnectionLostEvent() => clearField(4);
  @$pb.TagNumber(4)
  GattConnectionLostEvent ensureGattConnectionLostEvent() => $_ensure(3);

  @$pb.TagNumber(5)
  GattCharacteristicValueChangedEvent get gattCharacteristicValueChangedEvent => $_getN(4);
  @$pb.TagNumber(5)
  set gattCharacteristicValueChangedEvent(GattCharacteristicValueChangedEvent v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasGattCharacteristicValueChangedEvent() => $_has(4);
  @$pb.TagNumber(5)
  void clearGattCharacteristicValueChangedEvent() => clearField(5);
  @$pb.TagNumber(5)
  GattCharacteristicValueChangedEvent ensureGattCharacteristicValueChangedEvent() => $_ensure(4);
}

class BluetoothStateChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothStateChangedEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..e<BluetoothState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.BLUETOOTH_STATE_UNSUPPORTED, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..hasRequiredFields = false
  ;

  BluetoothStateChangedEvent._() : super();
  factory BluetoothStateChangedEvent({
    BluetoothState? state,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory BluetoothStateChangedEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothStateChangedEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedEvent clone() => BluetoothStateChangedEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothStateChangedEvent copyWith(void Function(BluetoothStateChangedEvent) updates) => super.copyWith((message) => updates(message as BluetoothStateChangedEvent)) as BluetoothStateChangedEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedEvent create() => BluetoothStateChangedEvent._();
  BluetoothStateChangedEvent createEmptyInstance() => create();
  static $pb.PbList<BluetoothStateChangedEvent> createRepeated() => $pb.PbList<BluetoothStateChangedEvent>();
  @$core.pragma('dart2js:noInline')
  static BluetoothStateChangedEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothStateChangedEvent>(create);
  static BluetoothStateChangedEvent? _defaultInstance;

  @$pb.TagNumber(1)
  BluetoothState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(BluetoothState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);
}

class CentralDiscoveredEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CentralDiscoveredEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOM<PeripheralDiscovery>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peripheralDiscovery', subBuilder: PeripheralDiscovery.create)
    ..hasRequiredFields = false
  ;

  CentralDiscoveredEvent._() : super();
  factory CentralDiscoveredEvent({
    PeripheralDiscovery? peripheralDiscovery,
  }) {
    final _result = create();
    if (peripheralDiscovery != null) {
      _result.peripheralDiscovery = peripheralDiscovery;
    }
    return _result;
  }
  factory CentralDiscoveredEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CentralDiscoveredEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CentralDiscoveredEvent clone() => CentralDiscoveredEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CentralDiscoveredEvent copyWith(void Function(CentralDiscoveredEvent) updates) => super.copyWith((message) => updates(message as CentralDiscoveredEvent)) as CentralDiscoveredEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredEvent create() => CentralDiscoveredEvent._();
  CentralDiscoveredEvent createEmptyInstance() => create();
  static $pb.PbList<CentralDiscoveredEvent> createRepeated() => $pb.PbList<CentralDiscoveredEvent>();
  @$core.pragma('dart2js:noInline')
  static CentralDiscoveredEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CentralDiscoveredEvent>(create);
  static CentralDiscoveredEvent? _defaultInstance;

  @$pb.TagNumber(1)
  PeripheralDiscovery get peripheralDiscovery => $_getN(0);
  @$pb.TagNumber(1)
  set peripheralDiscovery(PeripheralDiscovery v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeripheralDiscovery() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeripheralDiscovery() => clearField(1);
  @$pb.TagNumber(1)
  PeripheralDiscovery ensurePeripheralDiscovery() => $_ensure(0);
}

class GattConnectionLostEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattConnectionLostEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error')
    ..hasRequiredFields = false
  ;

  GattConnectionLostEvent._() : super();
  factory GattConnectionLostEvent({
    $core.String? hashUuid,
    $core.String? error,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    if (error != null) {
      _result.error = error;
    }
    return _result;
  }
  factory GattConnectionLostEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattConnectionLostEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattConnectionLostEvent clone() => GattConnectionLostEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattConnectionLostEvent copyWith(void Function(GattConnectionLostEvent) updates) => super.copyWith((message) => updates(message as GattConnectionLostEvent)) as GattConnectionLostEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostEvent create() => GattConnectionLostEvent._();
  GattConnectionLostEvent createEmptyInstance() => create();
  static $pb.PbList<GattConnectionLostEvent> createRepeated() => $pb.PbList<GattConnectionLostEvent>();
  @$core.pragma('dart2js:noInline')
  static GattConnectionLostEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattConnectionLostEvent>(create);
  static GattConnectionLostEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
}

class GattCharacteristicValueChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicValueChangedEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattHashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gattServiceHashUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattCharacteristicValueChangedEvent._() : super();
  factory GattCharacteristicValueChangedEvent({
    $core.String? gattHashUuid,
    $core.String? gattServiceHashUuid,
    $core.String? hashUuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (gattHashUuid != null) {
      _result.gattHashUuid = gattHashUuid;
    }
    if (gattServiceHashUuid != null) {
      _result.gattServiceHashUuid = gattServiceHashUuid;
    }
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GattCharacteristicValueChangedEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicValueChangedEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicValueChangedEvent clone() => GattCharacteristicValueChangedEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicValueChangedEvent copyWith(void Function(GattCharacteristicValueChangedEvent) updates) => super.copyWith((message) => updates(message as GattCharacteristicValueChangedEvent)) as GattCharacteristicValueChangedEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValueChangedEvent create() => GattCharacteristicValueChangedEvent._();
  GattCharacteristicValueChangedEvent createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicValueChangedEvent> createRepeated() => $pb.PbList<GattCharacteristicValueChangedEvent>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValueChangedEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicValueChangedEvent>(create);
  static GattCharacteristicValueChangedEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gattHashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gattHashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGattHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGattHashUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gattServiceHashUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gattServiceHashUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGattServiceHashUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGattServiceHashUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get hashUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set hashUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashUuid() => clearField(3);

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maximumWriteLength', $pb.PbFieldType.O3)
    ..pc<GattService>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: GattService.create)
    ..hasRequiredFields = false
  ;

  GATT._() : super();
  factory GATT({
    $core.String? hashUuid,
    $core.int? maximumWriteLength,
    $core.Iterable<GattService>? services,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
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
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattCharacteristic>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: GattCharacteristic.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $core.String? hashUuid,
    $core.String? uuid,
    $core.Iterable<GattCharacteristic>? characteristics,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
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
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
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
    $core.String? hashUuid,
    $core.String? uuid,
    $core.bool? canRead,
    $core.bool? canWrite,
    $core.bool? canWriteWithoutResponse,
    $core.bool? canNotify,
    $core.Iterable<GattDescriptor>? descriptors,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
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
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashUuid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $core.String? hashUuid,
    $core.String? uuid,
  }) {
    final _result = create();
    if (hashUuid != null) {
      _result.hashUuid = hashUuid;
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
  $core.String get hashUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set hashUuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHashUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHashUuid() => clearField(1);

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

