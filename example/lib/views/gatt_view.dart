import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy_example/models.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart' hide ConnectionState;

import 'util.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  late final ValueNotifier<ConnectionState> stateNotifier;
  late final ValueNotifier<GattService?> serviceNotifier;
  late final ValueNotifier<GattCharacteristic?> characteristicNotifier;
  late final TextEditingController writeController;
  late final MapNotifier<GattCharacteristic, StreamSubscription<Uint8List>>
      notifySubscriptions;
  late final ListNotifier<Log> logsNotifier;
  late final ValueNotifier<Encoding> encodingNotifier;
  late final ValueNotifier<EndSymbol> endSymbolNotifier;

  late Discovery discovery;
  GATT? gatt;

  bool get canRead =>
      characteristicNotifier.value != null &&
      characteristicNotifier.value!.canRead;

  bool get canWrite =>
      characteristicNotifier.value != null &&
      (characteristicNotifier.value!.canWrite ||
          characteristicNotifier.value!.canWriteWithoutResponse);

  bool get canNotify =>
      characteristicNotifier.value != null &&
      characteristicNotifier.value!.canNotify;

  @override
  void initState() {
    super.initState();
    stateNotifier = ValueNotifier(ConnectionState.disconnected);
    serviceNotifier = ValueNotifier(null);
    characteristicNotifier = ValueNotifier(null);
    writeController = TextEditingController();
    notifySubscriptions = MapNotifier({});
    logsNotifier = ListNotifier([]);
    encodingNotifier = ValueNotifier(Encoding.hex);
    endSymbolNotifier = ValueNotifier(EndSymbol.none);
  }

  @override
  Widget build(BuildContext context) {
    discovery = context.arguments<Discovery>();
    return buildGattView(context);
  }

  @override
  void dispose() {
    super.dispose();
    if (stateNotifier.value != ConnectionState.disconnected) {
      stateNotifier.addListener(waitToDisposeGATT);
      if (stateNotifier.value == ConnectionState.connected) disconnect();
    } else {
      disposeGATT();
    }
  }

  void waitToDisposeGATT() {
    switch (stateNotifier.value) {
      case ConnectionState.connected:
        disconnect();
        break;
      case ConnectionState.disconnected:
        stateNotifier.removeListener(waitToDisposeGATT);
        disposeGATT();
        break;
      default:
        break;
    }
  }

  void disposeGATT() {
    writeController.dispose();
    stateNotifier.dispose();
    serviceNotifier.dispose();
    characteristicNotifier.dispose();
    notifySubscriptions.dispose();
    logsNotifier.dispose();
    encodingNotifier.dispose();
    endSymbolNotifier.dispose();
  }

  Future<void> connect() async {
    try {
      stateNotifier.value = ConnectionState.connecting;
      gatt = await central.connect(
        discovery.uuid,
        onConnectionLost: (errorCode) {
          clean();
          stateNotifier.value = ConnectionState.disconnected;
        },
      );
      stateNotifier.value = ConnectionState.connected;
    } catch (e) {
      stateNotifier.value = ConnectionState.disconnected;
    }
  }

  void changeService(GattService? serviceValue) {
    serviceNotifier.value = serviceValue;
    characteristicNotifier.value = null;
  }

  void changeCharacteristic(GattCharacteristic? characteristicValue) {
    characteristicNotifier.value = characteristicValue;
  }

  Future<void> read() async {
    final characteristic = characteristicNotifier.value!;
    final value = await characteristic.read();
    final log = Log.read(value);
    logsNotifier.value = [...logsNotifier.value, log];
  }

  Future<void> write() async {
    final characteristic = characteristicNotifier.value!;
    List<int> elements;
    switch (encodingNotifier.value) {
      case Encoding.utf8:
        elements = utf8.encode(writeController.text);
        break;
      case Encoding.hex:
        elements = hex.decode(writeController.text);
        break;
      default:
        throw ArgumentError.value(encodingNotifier.value);
    }
    switch (endSymbolNotifier.value) {
      case EndSymbol.none:
        break;
      case EndSymbol.nul:
        elements = [...elements, 0x00];
        break;
      case EndSymbol.cr:
        elements = [...elements, 0x0D];
        break;
      case EndSymbol.lf:
        elements = [...elements, 0x0A];
        break;
      case EndSymbol.crlf:
        elements = [...elements, 0x0D, 0x0A];
        break;
      default:
        throw ArgumentError.value(endSymbolNotifier.value);
    }
    final value = Uint8List.fromList(elements);
    final withoutResponse = !characteristic.canWrite;
    await characteristic.write(value, withoutResponse: withoutResponse);
    final log = Log.write(elements);
    logsNotifier.value = [...logsNotifier.value, log];
  }

  Future<void> notify() async {
    final characteristic = characteristicNotifier.value!;
    final subscription = notifySubscriptions.value.remove(characteristic);
    if (subscription != null) {
      await subscription.cancel();
    } else {
      notifySubscriptions.value[characteristic] =
          characteristic.notify.listen((value) {
        final log = Log.notify(value);
        logsNotifier.value = [...logsNotifier.value, log];
      });
    }
    notifySubscriptions.value = {...notifySubscriptions.value};
  }

  Future<void> disconnect() async {
    try {
      stateNotifier.value = ConnectionState.disconnecting;
      for (var subscription in notifySubscriptions.value.values) {
        await subscription.cancel();
      }
      await gatt!.disconnect();
      await clean();
      stateNotifier.value = ConnectionState.disconnected;
    } catch (e) {
      stateNotifier.value = ConnectionState.connected;
    }
  }

  Future<void> clean() async {
    serviceNotifier.value = null;
    characteristicNotifier.value = null;
    notifySubscriptions.value.clear();
    logsNotifier.value.clear();
  }
}

extension on _GattViewState {
  Widget buildGattView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(discovery.name ?? discovery.uuid.name),
        actions: [
          buildChangeStateView(context),
        ],
      ),
      body: buildBodyView(context),
    );
  }

  Widget buildChangeStateView(BuildContext context) => ValueListenableBuilder(
        valueListenable: stateNotifier,
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

  Widget buildBodyView(BuildContext context) {
    return ValueListenableBuilder<ConnectionState>(
      valueListenable: stateNotifier,
      builder: (context, state, child) {
        switch (state) {
          case ConnectionState.connecting:
            return buildConnectingView(context);
          case ConnectionState.connected:
            return buildConnectedView(context);
          case ConnectionState.disconnecting:
            return buildDisconnectingView(context);
          case ConnectionState.disconnected:
          default:
            return buildDisconnectedView(context);
        }
      },
    );
  }

  Widget buildDisconnectedView(BuildContext context) {
    return const Center(
      child: Text('未连接'),
    );
  }

  Widget buildConnectingView(BuildContext context) {
    return const Center(
      child: Text('正在建立连接'),
    );
  }

  Widget buildConnectedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildServiceView(context),
          buildLogsView(context),
        ],
      ),
    );
  }

  Widget buildServiceView(BuildContext context) {
    return ValueListenableBuilder<GattService?>(
      valueListenable: serviceNotifier,
      builder: (context, service, child) {
        final services = gatt?.services.values
            .map((e) => DropdownMenuItem<GattService>(
                  value: e,
                  child: Text(e.uuid.name, softWrap: false),
                ))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<GattService>(
              isExpanded: true,
              hint: const Text('选择服务'),
              value: service,
              items: services,
              onChanged: changeService,
            ),
            buildCharacteristicView(context),
          ],
        );
      },
    );
  }

  Widget buildCharacteristicView(BuildContext context) {
    const height = 32.0;
    return ValueListenableBuilder<GattCharacteristic?>(
      valueListenable: characteristicNotifier,
      builder: (context, characteristic, child) {
        final characteristics = serviceNotifier.value?.characteristics.values
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.uuid.name, softWrap: false),
                ))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<GattCharacteristic>(
              isExpanded: true,
              hint: const Text('选择特征值'),
              value: characteristic,
              items: characteristics,
              onChanged: changeCharacteristic,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: canRead ? () async => await read() : null,
                  icon: const Icon(Icons.archive),
                ),
                ValueListenableBuilder<
                        Map<GattCharacteristic, StreamSubscription<List<int>>>>(
                    valueListenable: notifySubscriptions,
                    builder: (context, notifies, child) {
                      return IconButton(
                        onPressed:
                            canNotify ? () async => await notify() : null,
                        icon: Icon(
                          Icons.notifications,
                          color: notifies.containsKey(characteristic)
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                labelText: 'MTU: ${gatt!.maximumWriteLength}',
                suffixIcon: IconButton(
                  onPressed: canWrite ? () async => await write() : null,
                  icon: const Icon(Icons.send),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              height: height,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<Encoding>(
                    valueListenable: encodingNotifier,
                    builder: (context, encoding, child) {
                      return ToggleButtons(
                        children:
                            Encoding.values.map((e) => Text(e.name)).toList(),
                        isSelected:
                            Encoding.values.map((e) => e == encoding).toList(),
                        onPressed: (i) =>
                            encodingNotifier.value = Encoding.values[i],
                        borderRadius: BorderRadius.circular(height / 2.0),
                      );
                    },
                  ),
                  ValueListenableBuilder<EndSymbol>(
                    valueListenable: endSymbolNotifier,
                    builder: (context, endSymbol, child) {
                      return ToggleButtons(
                        children: EndSymbol.values
                            .map((e) => Text(e.name.toUpperCase()))
                            .toList(),
                        isSelected: EndSymbol.values
                            .map((e) => e == endSymbol)
                            .toList(),
                        onPressed: (i) =>
                            endSymbolNotifier.value = EndSymbol.values[i],
                        borderRadius: BorderRadius.circular(height / 2.0),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildLogsView(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ValueListenableBuilder<Encoding>(
            valueListenable: encodingNotifier,
            builder: (context, encoding, child) {
              return ValueListenableBuilder<List<Log>>(
                valueListenable: logsNotifier,
                builder: (context, logs, child) {
                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, i) {
                      final log = logs[i];
                      return buildLogView(context, log, encoding);
                    },
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => logsNotifier.value = [],
              icon: const Icon(Icons.format_clear),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLogView(BuildContext context, Log log, Encoding encoding) {
    final String logValue;
    switch (encoding) {
      case Encoding.utf8:
        logValue = utf8.decode(log.value);
        break;
      case Encoding.hex:
        logValue = hex.encode(log.value);
        break;
      default:
        throw ArgumentError.value(encoding);
    }
    return Text('[${log.time.shortName}][${log.type.name}] $logValue');
  }

  Widget buildDisconnectingView(BuildContext context) {
    return const Center(
      child: Text('正在断开连接'),
    );
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
