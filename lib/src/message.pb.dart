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
  connectionLost, 
  characteristicValue, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Message_Value> _Message_ValueByTag = {
    2 : Message_Value.state,
    3 : Message_Value.discovery,
    4 : Message_Value.scanning,
    5 : Message_Value.connectionLost,
    6 : Message_Value.characteristicValue,
    0 : Message_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Message', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6])
    ..e<MessageCategory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: MessageCategory.BLUETOOTH_STATE, valueOf: MessageCategory.valueOf, enumValues: MessageCategory.values)
    ..e<BluetoothState>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: BluetoothState.UNKNOWN, valueOf: BluetoothState.valueOf, enumValues: BluetoothState.values)
    ..aOM<Discovery>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'discovery', subBuilder: Discovery.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scanning')
    ..aOM<ConnectionLost>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionLost', protoName: 'connectionLost', subBuilder: ConnectionLost.create)
    ..aOM<GattCharacteristicValue>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicValue', protoName: 'characteristicValue', subBuilder: GattCharacteristicValue.create)
    ..hasRequiredFields = false
  ;

  Message._() : super();
  factory Message({
    MessageCategory? category,
    BluetoothState? state,
    Discovery? discovery,
    $core.bool? scanning,
    ConnectionLost? connectionLost,
    GattCharacteristicValue? characteristicValue,
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
    if (connectionLost != null) {
      _result.connectionLost = connectionLost;
    }
    if (characteristicValue != null) {
      _result.characteristicValue = characteristicValue;
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
  ConnectionLost get connectionLost => $_getN(4);
  @$pb.TagNumber(5)
  set connectionLost(ConnectionLost v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasConnectionLost() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectionLost() => clearField(5);
  @$pb.TagNumber(5)
  ConnectionLost ensureConnectionLost() => $_ensure(4);

  @$pb.TagNumber(6)
  GattCharacteristicValue get characteristicValue => $_getN(5);
  @$pb.TagNumber(6)
  set characteristicValue(GattCharacteristicValue v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCharacteristicValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacteristicValue() => clearField(6);
  @$pb.TagNumber(6)
  GattCharacteristicValue ensureCharacteristicValue() => $_ensure(5);
}

class StartDiscoveryArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StartDiscoveryArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services')
    ..hasRequiredFields = false
  ;

  StartDiscoveryArguments._() : super();
  factory StartDiscoveryArguments({
    $core.Iterable<$core.String>? services,
  }) {
    final _result = create();
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory StartDiscoveryArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartDiscoveryArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartDiscoveryArguments clone() => StartDiscoveryArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartDiscoveryArguments copyWith(void Function(StartDiscoveryArguments) updates) => super.copyWith((message) => updates(message as StartDiscoveryArguments)) as StartDiscoveryArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StartDiscoveryArguments create() => StartDiscoveryArguments._();
  StartDiscoveryArguments createEmptyInstance() => create();
  static $pb.PbList<StartDiscoveryArguments> createRepeated() => $pb.PbList<StartDiscoveryArguments>();
  @$core.pragma('dart2js:noInline')
  static StartDiscoveryArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartDiscoveryArguments>(create);
  static StartDiscoveryArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get services => $_getList(0);
}

class Discovery extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Discovery', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rssi', $pb.PbFieldType.OS3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'advertisements', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  Discovery._() : super();
  factory Discovery({
    $core.String? address,
    $core.int? rssi,
    $core.List<$core.int>? advertisements,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (rssi != null) {
      _result.rssi = rssi;
    }
    if (advertisements != null) {
      _result.advertisements = advertisements;
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
  $core.List<$core.int> get advertisements => $_getN(2);
  @$pb.TagNumber(3)
  set advertisements($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAdvertisements() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdvertisements() => clearField(3);
}

class ConnectArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  ConnectArguments._() : super();
  factory ConnectArguments({
    $core.String? address,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory ConnectArguments.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectArguments.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectArguments clone() => ConnectArguments()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectArguments copyWith(void Function(ConnectArguments) updates) => super.copyWith((message) => updates(message as ConnectArguments)) as ConnectArguments; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectArguments create() => ConnectArguments._();
  ConnectArguments createEmptyInstance() => create();
  static $pb.PbList<ConnectArguments> createRepeated() => $pb.PbList<ConnectArguments>();
  @$core.pragma('dart2js:noInline')
  static ConnectArguments getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectArguments>(create);
  static ConnectArguments? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class GATT extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GATT', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mtu', $pb.PbFieldType.O3)
    ..pc<GattService>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: GattService.create)
    ..hasRequiredFields = false
  ;

  GATT._() : super();
  factory GATT({
    $core.int? id,
    $core.int? mtu,
    $core.Iterable<GattService>? services,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (mtu != null) {
      _result.mtu = mtu;
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
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtu => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtu($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMtu() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtu() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<GattService> get services => $_getList(2);
}

class GattDisconnectArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDisconnectArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GattDisconnectArguments._() : super();
  factory GattDisconnectArguments({
    $core.String? address,
    $core.int? id,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (id != null) {
      _result.id = id;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class GattService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattService', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattCharacteristic>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: GattCharacteristic.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $core.int? id,
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
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattDescriptor>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptors', $pb.PbFieldType.PM, subBuilder: GattDescriptor.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canRead', protoName: 'canRead')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWrite', protoName: 'canWrite')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWriteWithoutResponse', protoName: 'canWriteWithoutResponse')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canNotify', protoName: 'canNotify')
    ..hasRequiredFields = false
  ;

  GattCharacteristic._() : super();
  factory GattCharacteristic({
    $core.int? id,
    $core.String? uuid,
    $core.Iterable<GattDescriptor>? descriptors,
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
    if (descriptors != null) {
      _result.descriptors.addAll(descriptors);
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
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
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
  $core.List<GattDescriptor> get descriptors => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get canRead => $_getBF(3);
  @$pb.TagNumber(4)
  set canRead($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCanRead() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanRead() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get canWrite => $_getBF(4);
  @$pb.TagNumber(5)
  set canWrite($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCanWrite() => $_has(4);
  @$pb.TagNumber(5)
  void clearCanWrite() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get canWriteWithoutResponse => $_getBF(5);
  @$pb.TagNumber(6)
  set canWriteWithoutResponse($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCanWriteWithoutResponse() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanWriteWithoutResponse() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get canNotify => $_getBF(6);
  @$pb.TagNumber(7)
  set canNotify($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCanNotify() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanNotify() => clearField(7);
}

class GattDescriptor extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptor', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $core.int? id,
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
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
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

class ConnectionLost extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionLost', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorCode', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ConnectionLost._() : super();
  factory ConnectionLost({
    $core.int? id,
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
  factory ConnectionLost.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionLost.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionLost clone() => ConnectionLost()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionLost copyWith(void Function(ConnectionLost) updates) => super.copyWith((message) => updates(message as ConnectionLost)) as ConnectionLost; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectionLost create() => ConnectionLost._();
  ConnectionLost createEmptyInstance() => create();
  static $pb.PbList<ConnectionLost> createRepeated() => $pb.PbList<ConnectionLost>();
  @$core.pragma('dart2js:noInline')
  static ConnectionLost getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionLost>(create);
  static ConnectionLost? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
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

class GattCharacteristicReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GattCharacteristicReadArguments._() : super();
  factory GattCharacteristicReadArguments({
    $core.String? address,
    $core.String? serviceUuid,
    $core.String? uuid,
    $core.int? id,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (id != null) {
      _result.id = id;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get id => $_getIZ(3);
  @$pb.TagNumber(4)
  set id($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);
}

class GattCharacteristicWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withoutResponse', protoName: 'withoutResponse')
    ..hasRequiredFields = false
  ;

  GattCharacteristicWriteArguments._() : super();
  factory GattCharacteristicWriteArguments({
    $core.String? address,
    $core.String? serviceUuid,
    $core.String? uuid,
    $core.int? id,
    $core.List<$core.int>? value,
    $core.bool? withoutResponse,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get id => $_getIZ(3);
  @$pb.TagNumber(4)
  set id($core.int v) { $_setSignedInt32(3, v); }
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

  @$pb.TagNumber(6)
  $core.bool get withoutResponse => $_getBF(5);
  @$pb.TagNumber(6)
  set withoutResponse($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWithoutResponse() => $_has(5);
  @$pb.TagNumber(6)
  void clearWithoutResponse() => clearField(6);
}

class GattCharacteristicNotifyArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicNotifyArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false
  ;

  GattCharacteristicNotifyArguments._() : super();
  factory GattCharacteristicNotifyArguments({
    $core.String? address,
    $core.String? serviceUuid,
    $core.String? uuid,
    $core.int? id,
    $core.bool? state,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (id != null) {
      _result.id = id;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get id => $_getIZ(3);
  @$pb.TagNumber(4)
  set id($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get state => $_getBF(4);
  @$pb.TagNumber(5)
  set state($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => clearField(5);
}

class GattCharacteristicValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicValue', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattCharacteristicValue._() : super();
  factory GattCharacteristicValue({
    $core.int? id,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GattCharacteristicValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GattCharacteristicValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GattCharacteristicValue clone() => GattCharacteristicValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GattCharacteristicValue copyWith(void Function(GattCharacteristicValue) updates) => super.copyWith((message) => updates(message as GattCharacteristicValue)) as GattCharacteristicValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValue create() => GattCharacteristicValue._();
  GattCharacteristicValue createEmptyInstance() => create();
  static $pb.PbList<GattCharacteristicValue> createRepeated() => $pb.PbList<GattCharacteristicValue>();
  @$core.pragma('dart2js:noInline')
  static GattCharacteristicValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GattCharacteristicValue>(create);
  static GattCharacteristicValue? _defaultInstance;

  @$pb.TagNumber(3)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(3)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(4)
  set value($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);
}

class GattDescriptorReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  GattDescriptorReadArguments._() : super();
  factory GattDescriptorReadArguments({
    $core.String? address,
    $core.String? serviceUuid,
    $core.String? characteristicUuid,
    $core.String? uuid,
    $core.int? id,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (characteristicUuid != null) {
      _result.characteristicUuid = characteristicUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (id != null) {
      _result.id = id;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristicUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristicUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get uuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUuid() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get id => $_getIZ(4);
  @$pb.TagNumber(5)
  set id($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => clearField(5);
}

class GattDescriptorWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattDescriptorWriteArguments._() : super();
  factory GattDescriptorWriteArguments({
    $core.String? address,
    $core.String? serviceUuid,
    $core.String? characteristicUuid,
    $core.String? uuid,
    $core.int? id,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (characteristicUuid != null) {
      _result.characteristicUuid = characteristicUuid;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (id != null) {
      _result.id = id;
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
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristicUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristicUuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get uuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUuid() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get id => $_getIZ(4);
  @$pb.TagNumber(5)
  set id($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get value => $_getN(5);
  @$pb.TagNumber(6)
  set value($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => clearField(6);
}

