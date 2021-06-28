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

class GATT extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GATT', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mtu', $pb.PbFieldType.O3)
    ..pc<GattService>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: GattService.create)
    ..hasRequiredFields = false
  ;

  GATT._() : super();
  factory GATT({
    $core.int? mtu,
    $core.Iterable<GattService>? services,
  }) {
    final _result = create();
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
  $core.int get mtu => $_getIZ(0);
  @$pb.TagNumber(1)
  set mtu($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMtu() => $_has(0);
  @$pb.TagNumber(1)
  void clearMtu() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<GattService> get services => $_getList(1);
}

class GattService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattService', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattCharacteristic>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: GattCharacteristic.create)
    ..hasRequiredFields = false
  ;

  GattService._() : super();
  factory GattService({
    $core.String? uuid,
    $core.Iterable<GattCharacteristic>? characteristics,
  }) {
    final _result = create();
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
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<GattCharacteristic> get characteristics => $_getList(1);
}

class GattCharacteristic extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..pc<GattDescriptor>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'descriptors', $pb.PbFieldType.PM, subBuilder: GattDescriptor.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canRead', protoName: 'canRead')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWrite', protoName: 'canWrite')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canWriteWithoutResponse', protoName: 'canWriteWithoutResponse')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canNotify', protoName: 'canNotify')
    ..hasRequiredFields = false
  ;

  GattCharacteristic._() : super();
  factory GattCharacteristic({
    $core.String? uuid,
    $core.Iterable<GattDescriptor>? descriptors,
    $core.bool? canRead,
    $core.bool? canWrite,
    $core.bool? canWriteWithoutResponse,
    $core.bool? canNotify,
  }) {
    final _result = create();
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
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<GattDescriptor> get descriptors => $_getList(1);

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptor', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptor._() : super();
  factory GattDescriptor({
    $core.String? uuid,
  }) {
    final _result = create();
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
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);
}

class ConnectionLost extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectionLost', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorCode', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ConnectionLost._() : super();
  factory ConnectionLost({
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

class GattCharacteristicReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattCharacteristicReadArguments._() : super();
  factory GattCharacteristicReadArguments({
    $core.String? device,
    $core.String? service,
    $core.String? uuid,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);
}

class GattCharacteristicWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withoutResponse', protoName: 'withoutResponse')
    ..hasRequiredFields = false
  ;

  GattCharacteristicWriteArguments._() : super();
  factory GattCharacteristicWriteArguments({
    $core.String? device,
    $core.String? service,
    $core.String? uuid,
    $core.List<$core.int>? value,
    $core.bool? withoutResponse,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

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
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state')
    ..hasRequiredFields = false
  ;

  GattCharacteristicNotifyArguments._() : super();
  factory GattCharacteristicNotifyArguments({
    $core.String? device,
    $core.String? service,
    $core.String? uuid,
    $core.bool? state,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get state => $_getBF(3);
  @$pb.TagNumber(4)
  set state($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => clearField(4);
}

class GattCharacteristicValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattCharacteristicValue', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattCharacteristicValue._() : super();
  factory GattCharacteristicValue({
    $core.String? device,
    $core.String? service,
    $core.String? uuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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

  @$pb.TagNumber(1)
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);
}

class GattDescriptorReadArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorReadArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristic')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..hasRequiredFields = false
  ;

  GattDescriptorReadArguments._() : super();
  factory GattDescriptorReadArguments({
    $core.String? device,
    $core.String? service,
    $core.String? characteristic,
    $core.String? uuid,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristic => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristic($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristic() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristic() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get uuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUuid() => clearField(4);
}

class GattDescriptorWriteArguments extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GattDescriptorWriteArguments', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dev.yanshouwang.bluetooth_low_energy'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'device')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'service')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristic')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  GattDescriptorWriteArguments._() : super();
  factory GattDescriptorWriteArguments({
    $core.String? device,
    $core.String? service,
    $core.String? characteristic,
    $core.String? uuid,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (device != null) {
      _result.device = device;
    }
    if (service != null) {
      _result.service = service;
    }
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (uuid != null) {
      _result.uuid = uuid;
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
  $core.String get device => $_getSZ(0);
  @$pb.TagNumber(1)
  set device($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get characteristic => $_getSZ(2);
  @$pb.TagNumber(3)
  set characteristic($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristic() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristic() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get uuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uuid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUuid() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);
}

