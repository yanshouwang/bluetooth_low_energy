import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy_example/models.dart';
import 'package:bluetooth_low_energy_example/widgets.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter/services.dart';

import 'list_notifier.dart';
import 'map_notifier.dart';
import 'util.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  final ValueNotifier<ConnectionState> state;
  final ValueNotifier<GattService?> service;
  final ValueNotifier<GattCharacteristic?> characteristic;
  final TextEditingController writeController;
  final MapNotifier<GattCharacteristic, StreamSubscription<List<int>>> notifies;
  final ListNotifier<Log> logs;
  final ValueNotifier<Encoding> encoding;

  late Discovery discovery;

  GATT? gatt;
  StreamSubscription<Exception>? connectionLostSubscription;

  bool get canRead =>
      characteristic.value != null && characteristic.value!.canRead;
  bool get canWrite =>
      characteristic.value != null &&
      (characteristic.value!.canWrite ||
          characteristic.value!.canWriteWithoutResponse);
  bool get canNotify =>
      characteristic.value != null && characteristic.value!.canNotify;

  _GattViewState()
      : state = ValueNotifier(ConnectionState.disconnected),
        service = ValueNotifier(null),
        characteristic = ValueNotifier(null),
        writeController = TextEditingController(),
        notifies = MapNotifier({}),
        logs = ListNotifier([]),
        encoding = ValueNotifier(Encoding.hex);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    discovery = context.arguments<Discovery>();
    return view;
  }

  @override
  void dispose() {
    super.dispose();
    if (state.value != ConnectionState.disconnected) {
      state.addListener(waitToDisposeGATT);
      if (state.value == ConnectionState.connected) disconnect();
    } else {
      disposeGATT();
    }
  }

  void waitToDisposeGATT() {
    switch (state.value) {
      case ConnectionState.connected:
        disconnect();
        break;
      case ConnectionState.disconnected:
        state.removeListener(waitToDisposeGATT);
        disposeGATT();
        break;
      default:
        break;
    }
  }

  void disposeGATT() {
    state.dispose();
    service.dispose();
    characteristic.dispose();
    notifies.dispose();
    logs.dispose();
  }

  Future<void> connect() async {
    try {
      state.value = ConnectionState.connecting;
      gatt = await central.connect(discovery.uuid);
      state.value = ConnectionState.connected;
      connectionLostSubscription = gatt!.connectionLost.listen(
        (errorCode) async {
          await cleanConnection();
          state.value = ConnectionState.disconnected;
        },
      );
    } on PlatformException {
      state.value = ConnectionState.disconnected;
    }
  }

  void changeService(GattService? serviceValue) {
    service.value = serviceValue;
    characteristic.value = null;
  }

  void changeCharacterisitc(GattCharacteristic? characteristicValue) {
    characteristic.value = characteristicValue;
  }

  Future<void> read() async {
    final characteristic = this.characteristic.value!;
    final value = await characteristic.read();
    final log = Log.read(value);
    logs.value = [...logs.value, log];
  }

  Future<void> write() async {
    final characteristic = this.characteristic.value!;
    List<int> value;
    switch (encoding.value) {
      case Encoding.utf8:
        value = utf8.encode(writeController.text);
        break;
      case Encoding.hex:
        value = hex.decode(writeController.text);
        break;
      default:
        throw ArgumentError.value(encoding.value);
    }
    final withoutResponse = !characteristic.canWrite;
    await characteristic.write(value, withoutResponse: withoutResponse);
    final log = Log.write(value);
    logs.value = [...logs.value, log];
  }

  Future<void> notify() async {
    final characteristic = this.characteristic.value!;
    final notifying = notifies.value.containsKey(characteristic);
    if (notifying) {
      await characteristic.notify(false);
      await notifies.value.remove(characteristic)!.cancel();
    } else {
      notifies.value[characteristic] =
          characteristic.valueChanged.listen((value) {
        final log = Log.notify(value);
        logs.value = [...logs.value, log];
      });
      await characteristic.notify(true);
    }
    notifies.value = {...notifies.value};
  }

  Future<void> disconnect() async {
    try {
      state.value = ConnectionState.disconnecting;
      await gatt!.disconnect();
      await cleanConnection();
      state.value = ConnectionState.disconnected;
    } on PlatformException {
      state.value = ConnectionState.connected;
    }
  }

  Future<void> cleanConnection() async {
    for (var subscription in notifies.value.values) {
      await subscription.cancel();
    }
    await connectionLostSubscription!.cancel();
    gatt = null;
    connectionLostSubscription = null;
    service.value = null;
    characteristic.value = null;
    notifies.value.clear();
    logs.value.clear();
  }
}

extension on _GattViewState {
  Widget get view => Scaffold(
        appBar: AppBar(
          title: Text(discovery.name ?? discovery.uuid.name),
          actions: [
            changeStateView,
          ],
        ),
        body: bodyView,
      );

  Widget get changeStateView => ValueListenableBuilder(
        valueListenable: state,
        builder: (context, ConnectionState stateValue, child) {
          void Function()? onPressed;
          String data;
          switch (stateValue) {
            case ConnectionState.disconnected:
              onPressed = connect;
              data = '连接';
              break;
            case ConnectionState.connecting:
              data = '连接';
              break;
            case ConnectionState.connected:
              onPressed = disconnect;
              data = '断开';
              break;
            case ConnectionState.disconnecting:
              data = '断开';
              break;
            default:
              data = '';
              break;
          }
          return TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: Text(data),
          );
        },
      );

  Widget get bodyView => ValueListenableBuilder(
        valueListenable: state,
        builder: (context, ConnectionState stateValue, child) {
          switch (stateValue) {
            case ConnectionState.disconnected:
              return disconnectedView;
            case ConnectionState.connecting:
              return connectingView;
            case ConnectionState.connected:
              return connectedView;
            case ConnectionState.disconnecting:
              return disconnectingView;
            default:
              throw UnimplementedError();
          }
        },
      );

  Widget get disconnectedView => const Center(
        child: Text('未连接'),
      );

  Widget get connectingView => const Center(
        child: Text('正在建立连接'),
      );

  Widget get connectedView {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          serviceView,
          logsView,
        ],
      ),
    );
  }

  Widget get serviceView {
    return ValueListenableBuilder(
      valueListenable: service,
      builder: (context, GattService? serviceValue, child) {
        final services = gatt?.services.values
            .map((service) => DropdownMenuItem<GattService>(
                  value: service,
                  child: Text(service.uuid.name, softWrap: false),
                ))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<GattService>(
              isExpanded: true,
              hint: const Text('选择服务'),
              value: serviceValue,
              items: services,
              onChanged: changeService,
            ),
            characteristicView,
          ],
        );
      },
    );
  }

  Widget get characteristicView {
    return ValueListenableBuilder(
      valueListenable: characteristic,
      builder: (context, GattCharacteristic? characteristicValue, child) {
        final characteristics = service.value?.characteristics.values
            .map((characteristic) => DropdownMenuItem(
                  value: characteristic,
                  child: Text(characteristic.uuid.name, softWrap: false),
                ))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<GattCharacteristic>(
              isExpanded: true,
              hint: const Text('选择特征值'),
              value: characteristicValue,
              items: characteristics,
              onChanged: changeCharacterisitc,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: canRead ? () async => await read() : null,
                  icon: const Icon(Icons.archive),
                ),
                ValueListenableBuilder(
                    valueListenable: notifies,
                    builder: (context,
                        Map<GattCharacteristic, StreamSubscription<List<int>>>
                            notifiesValue,
                        child) {
                      return IconButton(
                        onPressed:
                            canNotify ? () async => await notify() : null,
                        icon: Icon(
                          Icons.notifications,
                          color: notifiesValue.containsKey(characteristicValue)
                              ? Colors.blue
                              : null,
                        ),
                      );
                    }),
              ],
            ),
            TextField(
              enabled: canWrite,
              controller: writeController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'MTU: ${gatt!.maximumWriteLength}',
                suffixIcon: IconButton(
                  onPressed: canWrite ? () async => await write() : null,
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ValueListenableBuilder(
                valueListenable: encoding,
                builder: (context, Encoding value, child) => TabSwitch(
                  values: Encoding.values,
                  value: value,
                  onChanged: (Encoding e) => encoding.value = e,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get logsView => Expanded(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: encoding,
              builder: (context, Encoding encodingValue, child) {
                return ValueListenableBuilder(
                  valueListenable: logs,
                  builder: (context, List<Log> logsValue, child) {
                    return ListView.builder(
                      itemCount: logsValue.length,
                      itemBuilder: (context, i) {
                        final log = logsValue[i];
                        return log.build(encodingValue);
                      },
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => logs.value = [],
                icon: const Icon(Icons.format_clear),
              ),
            )
          ],
        ),
      );

  Widget get disconnectingView => const Center(
        child: Text('正在断开连接'),
      );
}

extension on Log {
  Widget build(Encoding encoding) {
    String logValue;
    switch (encoding) {
      case Encoding.utf8:
        logValue = utf8.decode(value);
        break;
      case Encoding.hex:
        logValue = hex.encode(value);
        break;
      default:
        throw ArgumentError.value(encoding);
    }
    return Text('[${time.shortName}][${type.name}] $logValue');
  }
}

extension on LogType {
  String get name {
    switch (this) {
      case LogType.read:
        return '读取';
      case LogType.write:
        return '写入';
      case LogType.notify:
        return '通知';
      default:
        throw ArgumentError.value(this);
    }
  }
}
