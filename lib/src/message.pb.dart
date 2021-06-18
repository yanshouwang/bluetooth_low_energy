///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pbenum.dart';

export 'message.pbenum.dart';

enum Message_Value {
  state, 
  discovery, 
  scanning, 
  connectionLostArguments, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Message_Value> _Message_ValueByTag = {
    2 : Message_Value.state,
    3 : Message_Value.discovery,
    4 : Message_Value.scanning,
    5 : Message_Value.connectionLostArguments,
    0 : Message_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Message', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..e<MessageCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: MessageCategory.BLUETOOTH_STATE, valueOf: MessageCategory.valueOf, enumValues: MessageCategory.values)
    ..e<BluetoothState>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.UNKNOWN, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..aOM<Discovery>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'discovery', subBuilder: Discovery.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scanning')
    ..aOM<ConnectionLostArguments>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionLostArguments', protoName: 'connectionLostArguments', subBuilder: ConnectionLostArguments.create)
    ..hasRequiredFields = false
  ;

  Message._() : super();
  factory Message({
    MessageCategory? category,
    BluetoothState? state,
    Discovery? discovery,
    $core.bool? scanning,
    ConnectionLostArguments? connectionLostArguments,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (state != null) {
      _result.state = state;
    }
    if (discovery != null) {
      _result.discovery = discovery;
    }
    if (scanning != null) {
      _result.scanning = scanning;
    }
    if (connectionLostArguments != null) {
      _result.connectionLostArguments = connectionLostArguments;
    }
    return _result;
  }
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  Message_Value whichValue() => _Message_ValueByTag[$_whichOneof(0)]!;
  void clearValue() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  MessageCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(MessageCategory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  BluetoothState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(BluetoothState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => clearField(2);

  @$pb.TagNumber(3)
  Discovery get discovery => $_getN(2);
  @$pb.TagNumber(3)
  set discovery(Discovery v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDiscovery() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscovery() => clearField(3);
  @$pb.TagNumber(3)
  Discovery ensureDiscovery() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get scanning => $_getBF(3);
  @$pb.TagNumber(4)
  set scanning($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScanning() => $_has(3);
  @$pb.TagNumber(4)
  void clearScanning() => clearField(4);

  @$pb.TagNumber(5)
  ConnectionLostArguments get connectionLostArguments => $_getN(4);
  @$pb.TagNumber(5)
  set connectionLostArguments(ConnectionLostArguments v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasConnectionLostArguments() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectionLostArguments() => clearField(5);
  @$pb.TagNumber(5)
  ConnectionLostArguments ensureConnectionLostArguments() => $_ensure(4);
}

class DiscoverArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DiscoverArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services')
    ..hasRequiredFields = false
  ;

  DiscoverArguments._() : super();
  factory DiscoverArguments({
    $core.Iterable<$core.String>? services,
  }) {
    final _result = create();
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory DiscoverArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverArguments clone() => DiscoverArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverArguments copyWith(void Function(DiscoverArguments) updates) => super.copyWith((message) => updates(message as DiscoverArguments)) as DiscoverArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoverArguments create() => DiscoverArguments._();
  DiscoverArguments createEmptyInstance() => create();
  static $pb.PbList<DiscoverArguments> createRepeated() => $pb.PbList<DiscoverArguments>();
  @$core.pragma('dart2js:noInline')
  static DiscoverArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoverArguments>(create);
  static DiscoverArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get services => $_getList(0);
}

class Discovery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Discovery', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rssi', $pb.PbFieldType.OS3)
    ..m<$core.int, $core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'advertisements', entryClassName: 'Discovery.AdvertisementsEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OY, packageName: const $pb.PackageName('dev.yanshouwang.bluetooth_low_energy'))
    ..hasRequiredFields = false
  ;

  Discovery._() : super();
  factory Discovery({
    $core.String? address,
    $core.int? rssi,
    $core.Map<$core.int, $core.List<$core.int>>? advertisements,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (rssi != null) {
      _result.rssi = rssi;
    }
    if (advertisements != null) {
      _result.advertisements.addAll(advertisements);
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rssi => $_getIZ(1);
  @$pb.TagNumber(2)
  set rssi($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRssi() => $_has(1);
  @$pb.TagNumber(2)
  void clearRssi() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.int, $core.List<$core.int>> get advertisements => $_getMap(2);
}

class ConnectionLostArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionLostArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorCode', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ConnectionLostArguments._() : super();
  factory ConnectionLostArguments({
    $core.String? address,
    $core.int? errorCode,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (errorCode != null) {
      _result.errorCode = errorCode;
    }
    return _result;
  }
  factory ConnectionLostArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionLostArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionLostArguments clone() => ConnectionLostArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionLostArguments copyWith(void Function(ConnectionLostArguments) updates) => super.copyWith((message) => updates(message as ConnectionLostArguments)) as ConnectionLostArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectionLostArguments create() => ConnectionLostArguments._();
  ConnectionLostArguments createEmptyInstance() => create();
  static $pb.PbList<ConnectionLostArguments> createRepeated() => $pb.PbList<ConnectionLostArguments>();
  @$core.pragma('dart2js:noInline')
  static ConnectionLostArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionLostArguments>(create);
  static ConnectionLostArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get errorCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set errorCode($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorCode() => clearField(2);
}

