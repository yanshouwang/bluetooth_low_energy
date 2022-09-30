import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

CentralManager get central => CentralManager.instance;

void main() {
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeView(),
      routes: {
        'device': (context) {
          final peripheral =
              ModalRoute.of(context)?.settings.arguments as Peripheral;
          return DeviceView(
            peripheral: peripheral,
          );
        },
      },
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ValueNotifier<bool> state;
  late ValueNotifier<bool> discovering;
  late ValueNotifier<List<Broadcast>> broadcasts;
  late StreamSubscription<BluetoothState> stateStreamSubscription;
  late StreamSubscription<Broadcast> broadcastStreamSubscription;

  @override
  void initState() {
    super.initState();

    state = ValueNotifier(false);
    discovering = ValueNotifier(false);
    broadcasts = ValueNotifier([]);

    state.addListener(onStateChanged);
    stateStreamSubscription = central.stateChanged.listen(
      (state) => this.state.value = state == BluetoothState.poweredOn,
    );
    broadcastStreamSubscription = central.scanned.listen(
      (broadcast) {
        final broadcasts = this.broadcasts.value;
        final i = broadcasts.indexWhere(
          (element) => element.peripheral.uuid == broadcast.peripheral.uuid,
        );
        if (i < 0) {
          this.broadcasts.value = [...broadcasts, broadcast];
        } else {
          broadcasts[i] = broadcast;
          this.broadcasts.value = [...broadcasts];
        }
      },
    );
    setup();
  }

  void setup() async {
    final authorized = await central.authorize();
    if (!authorized) {
      throw UnimplementedError();
    }
    final state = await central.state;
    this.state.value = state == BluetoothState.poweredOn;
  }

  void onStateChanged() {
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) {
      return;
    }
    if (state.value) {
      startScan();
    } else {
      discovering.value = false;
    }
  }

  @override
  void dispose() {
    stopScan();
    state.removeListener(onStateChanged);
    stateStreamSubscription.cancel();
    broadcastStreamSubscription.cancel();

    state.dispose();
    discovering.dispose();
    broadcasts.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: buildBody(context),
    );
  }

  void startScan() async {
    if (discovering.value || !state.value) {
      return;
    }
    await central.startScan();
    discovering.value = true;
  }

  void stopScan() async {
    if (!discovering.value || !state.value) {
      return;
    }
    await central.stopScan();
    broadcasts.value = [];
    discovering.value = false;
  }

  void showBroadcast(Broadcast advertisement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      builder: (context) => buildBroadcastView(advertisement),
    );
  }

  void showDeviceView(Peripheral peripheral) async {
    stopScan();
    await Navigator.of(context).pushNamed(
      'device',
      arguments: peripheral,
    );
    startScan();
  }
}

extension on _HomeViewState {
  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, bool state, child) {
        return state ? buildBroadcastsView(context) : buildClosedView(context);
      },
    );
  }

  Widget buildClosedView(BuildContext context) {
    return const Center(
      child: Text('蓝牙未开启'),
    );
  }

  Widget buildBroadcastsView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => broadcasts.value = [],
      child: ValueListenableBuilder(
        valueListenable: broadcasts,
        builder: (context, List<Broadcast> broadcasts, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(6.0),
            itemCount: broadcasts.length,
            itemBuilder: (context, i) {
              final broadcast = broadcasts.elementAt(i);
              final connectable = broadcast.connectable ?? true;
              return Card(
                color: connectable ? Colors.amber : Colors.grey,
                clipBehavior: Clip.antiAlias,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                margin: const EdgeInsets.all(6.0),
                key: Key(broadcast.peripheral.uuid.value),
                child: InkWell(
                  splashColor: Colors.purple,
                  onTap: connectable
                      ? () => showDeviceView(broadcast.peripheral)
                      : null,
                  onLongPress: () => showBroadcast(broadcast),
                  child: Container(
                    height: 100.0,
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(broadcast.localName ?? 'UNKNOWN'),
                              Text(
                                broadcast.peripheral.uuid.value,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            broadcast.rssi.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildBroadcastView(Broadcast advertisement) {
    final widgets = <Widget>[
      Row(
        children: const [
          Text('Type'),
          Expanded(
            child: Center(
              child: Text('Value'),
            ),
          ),
        ],
      ),
      const Divider(),
    ];
    // for (final entry in advertisement.data.entries) {
    //   final type = '0x${entry.key.toRadixString(16).padLeft(2, '0')}';
    //   final value = hex.encode(entry.value);
    //   final widget = Row(
    //     children: [
    //       Text(type),
    //       Container(width: 12.0),
    //       Expanded(
    //         child: Text(
    //           value,
    //           softWrap: true,
    //         ),
    //       ),
    //     ],
    //   );
    //   widgets.add(widget);
    //   if (entry.key != advertisement.data.entries.last.key) {
    //     const divider = Divider();
    //     widgets.add(divider);
    //   }
    // }
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 1.0,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class DeviceView extends StatefulWidget {
  final Peripheral peripheral;

  const DeviceView({
    Key? key,
    required this.peripheral,
  }) : super(key: key);

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late StreamSubscription<Exception> connectionLostStreamSubscription;
  late Map<GattService, List<GattCharacteristic>> services;
  late ValueNotifier<ConnectionState> state;
  late ValueNotifier<GattService?> service;
  late ValueNotifier<GattCharacteristic?> characteristic;
  late TextEditingController writeController;
  late ValueNotifier<Map<GattCharacteristic, StreamSubscription>> notifies;
  late ValueNotifier<List<String>> logs;

  @override
  void initState() {
    super.initState();

    connectionLostStreamSubscription = widget.peripheral.connectionLost.listen(
      (error) {
        for (var subscription in notifies.value.values) {
          subscription.cancel();
        }
        service.value = null;
        characteristic.value = null;
        notifies.value.clear();
        logs.value.clear();
        state.value = ConnectionState.disconnected;
      },
    );
    services = {};
    state = ValueNotifier(ConnectionState.disconnected);
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    writeController = TextEditingController();
    notifies = ValueNotifier({});
    logs = ValueNotifier([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peripheral.uuid.value),
        actions: [
          buildConnectionState(context),
        ],
      ),
      body: buildBody(context),
    );
  }

  void Function()? disposeListener;

  @override
  void dispose() {
    super.dispose();

    if (state.value != ConnectionState.disconnected) {
      disposeListener ??= () => disposeGATT();
      state.addListener(disposeListener!);
      if (state.value == ConnectionState.connected) {
        disconnect();
      }
    } else {
      connectionLostStreamSubscription.cancel();
      state.dispose();
      service.dispose();
      characteristic.dispose();
      notifies.dispose();
      logs.dispose();
    }
  }

  void disposeGATT() {
    switch (state.value) {
      case ConnectionState.connected:
        disconnect();
        break;
      case ConnectionState.disconnected:
        state.removeListener(disposeListener!);
        connectionLostStreamSubscription.cancel();
        state.dispose();
        service.dispose();
        characteristic.dispose();
        notifies.dispose();
        logs.dispose();
        break;
      default:
        break;
    }
  }

  void connect() async {
    try {
      state.value = ConnectionState.connecting;
      await widget.peripheral.connect();
      try {
        final items0 = <GattService, List<GattCharacteristic>>{};
        final services = await widget.peripheral.discoverServices();
        for (var service in services) {
          final items1 = <GattCharacteristic>[];
          final characteristics = await service.discoverCharacteristics();
          for (var characteristic in characteristics) {
            items1.add(characteristic);
          }
          items0[service] = items1;
        }
        this.services = items0;
      } catch (e) {
        widget.peripheral.disconnect();
        rethrow;
      }
      state.value = ConnectionState.connected;
    } catch (error) {
      state.value = ConnectionState.disconnected;
    }
  }

  void disconnect() async {
    try {
      state.value = ConnectionState.disconnecting;
      for (var subscription in notifies.value.values) {
        subscription.cancel();
      }
      await widget.peripheral.disconnect();
      services = {};
      service.value = null;
      characteristic.value = null;
      notifies.value.clear();
      logs.value.clear();
      state.value = ConnectionState.disconnected;
    } catch (e) {
      state.value = ConnectionState.connected;
    }
  }
}

extension on _DeviceViewState {
  Widget buildConnectionState(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, ConnectionState state, child) {
        void Function()? onPressed;
        String data;
        switch (state) {
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
            foregroundColor: Colors.white,
          ),
          child: Text(data),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, ConnectionState stateValue, child) {
        switch (stateValue) {
          case ConnectionState.disconnected:
            return buildDisconnectedView(context);
          case ConnectionState.connecting:
            return buildConnectingView(context);
          case ConnectionState.connected:
            return buildConnectedView(context);
          case ConnectionState.disconnecting:
            return buildDisconnectingView(context);
          default:
            throw UnimplementedError();
        }
      },
    );
  }

  Widget buildDisconnectedView(BuildContext context) {
    return const Center(
      child: Text('Disconnected'),
    );
  }

  Widget buildConnectingView(BuildContext context) {
    return const Center(
      child: Text('Connecting'),
    );
  }

  Widget buildConnectedView(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: service,
      builder: (context, GattService? service, child) {
        final services = this.services.keys.map((service) {
          return DropdownMenuItem<GattService>(
            value: service,
            child: Text(
              service.uuid.toString(),
              softWrap: false,
            ),
          );
        }).toList();
        final serviceView = DropdownButton<GattService>(
          isExpanded: true,
          hint: const Text('Choose a service'),
          value: service,
          items: services,
          onChanged: (service) {
            this.service.value = service;
            characteristic.value = null;
          },
        );
        final views = <Widget>[serviceView];
        if (service != null) {
          final characteristics = this.services[service]?.map((characteristic) {
            return DropdownMenuItem(
              value: characteristic,
              child: Text(
                characteristic.uuid.toString(),
                softWrap: false,
              ),
            );
          }).toList();
          final characteristicView = ValueListenableBuilder(
            valueListenable: characteristic,
            builder: (context, GattCharacteristic? characteristic, child) {
              final canWrite = characteristic != null &&
                  (characteristic.canWrite ||
                      characteristic.canWriteWithoutResponse);
              final canRead = characteristic != null && characteristic.canRead;
              final canNotify =
                  characteristic != null && characteristic.canNotify;
              final readAndNotifyView = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: canRead
                        ? () async {
                            final value = await characteristic.read();
                            final time = DateTime.now().display;
                            final log = '[$time][READ] ${hex.encode(value)}';
                            logs.value = [...logs.value, log];
                          }
                        : null,
                    icon: const Icon(Icons.archive),
                  ),
                  ValueListenableBuilder(
                      valueListenable: notifies,
                      builder: (context,
                          Map<GattCharacteristic, StreamSubscription>
                              notifiesValue,
                          child) {
                        final notifying =
                            notifiesValue.containsKey(characteristic);
                        return IconButton(
                          onPressed: canNotify
                              ? () async {
                                  if (notifying) {
                                    await notifiesValue
                                        .remove(characteristic)!
                                        .cancel();
                                    await characteristic.setNotify(false);
                                  } else {
                                    notifiesValue[characteristic] =
                                        characteristic.valueChanged
                                            .listen((value) {
                                      final time = DateTime.now().display;
                                      final log =
                                          '[$time][NOTIFY] ${hex.encode(value)}';
                                      logs.value = [...logs.value, log];
                                    });
                                    await characteristic.setNotify(true);
                                  }
                                  notifies.value = {...notifiesValue};
                                }
                              : null,
                          icon: Icon(
                            Icons.notifications,
                            color: notifying ? Colors.blue : null,
                          ),
                        );
                      }),
                ],
              );
              final controllerView = TextField(
                controller: writeController,
                decoration: InputDecoration(
                  // hintText: 'MTU: ${peripheral.maximumWriteLength}',
                  suffixIcon: IconButton(
                    onPressed: canWrite
                        ? () {
                            final elements = utf8.encode(writeController.text);
                            final value = Uint8List.fromList(elements);
                            characteristic.write(
                              value,
                              withoutResponse: !characteristic.canWrite,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.send),
                  ),
                ),
              );
              return Column(
                children: [
                  DropdownButton<GattCharacteristic>(
                    isExpanded: true,
                    hint: const Text('Choose a characteristic'),
                    value: characteristic,
                    items: characteristics,
                    onChanged: (characteristic) {
                      this.characteristic.value = characteristic;
                    },
                  ),
                  readAndNotifyView,
                  controllerView,
                ],
              );
            },
          );
          views.add(characteristicView);
        }
        final loggerView = Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ValueListenableBuilder(
                valueListenable: logs,
                builder: (context, List<String> logsValue, child) {
                  return ListView.builder(
                    itemCount: logsValue.length,
                    itemBuilder: (context, i) {
                      final log = logsValue[i];
                      return Text(log);
                    },
                  );
                }),
          ),
        );
        views.add(loggerView);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: views,
          ),
        );
      },
    );
  }

  Widget buildDisconnectingView(BuildContext context) {
    return const Center(
      child: Text('Disconnecting'),
    );
  }
}

extension on DateTime {
  String get display {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final ss = second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}
