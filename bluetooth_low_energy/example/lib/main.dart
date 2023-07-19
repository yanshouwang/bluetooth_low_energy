import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

CentralManager get cm => CentralManager.instance;

void main() {
  const myApp = MyApp();
  runApp(myApp);
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
  late final ValueNotifier<bool> isPoweredOn;
  late final ValueNotifier<bool> isDiscovering;
  late final ValueNotifier<List<Peripheral>> peripherals;
  late final StreamSubscription<CentralManagerState> stateChangedSubscription;
  late final StreamSubscription<Peripheral> discoveredSubscription;

  @override
  void initState() {
    super.initState();

    isPoweredOn = ValueNotifier(false);
    isDiscovering = ValueNotifier(false);
    peripherals = ValueNotifier([]);

    isPoweredOn.addListener(onStateChanged);
    stateChangedSubscription = cm.stateChanged.listen((state) {
      isPoweredOn.value = state == CentralManagerState.poweredOn;
    });
    discoveredSubscription = cm.discovered.listen(
      (peripheral) {
        final peripherals = this.peripherals.value;
        final i = peripherals.indexWhere((item) => item.id == peripheral.id);
        if (i < 0) {
          this.peripherals.value = [...peripherals, peripheral];
        } else {
          peripherals[i] = peripheral;
          this.peripherals.value = [...peripherals];
        }
      },
    );
    setup();
  }

  void setup() async {
    await Permission.locationWhenInUse.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    final state = await cm.getState();
    isPoweredOn.value = state == CentralManagerState.poweredOn;
  }

  void onStateChanged() {
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) {
      return;
    }
    if (isPoweredOn.value) {
      startDiscovery();
    } else {
      isDiscovering.value = false;
    }
  }

  @override
  void dispose() {
    stopDiscovery();
    isPoweredOn.removeListener(onStateChanged);
    stateChangedSubscription.cancel();
    discoveredSubscription.cancel();

    isPoweredOn.dispose();
    isDiscovering.dispose();
    peripherals.dispose();

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

  void startDiscovery() async {
    if (isDiscovering.value || !isPoweredOn.value) {
      return;
    }
    await cm.startDiscovery();
    isDiscovering.value = true;
  }

  void stopDiscovery() async {
    if (!isDiscovering.value || !isPoweredOn.value) {
      return;
    }
    await cm.stopDiscovery();
    peripherals.value = [];
    isDiscovering.value = false;
  }

  void showManufacturerSpecificData(Uint8List manufacturerSpecificData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return buildManufacturerSpecificDataView(manufacturerSpecificData);
      },
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  void showDeviceView(Peripheral peripheral) async {
    stopDiscovery();
    await Navigator.of(context).pushNamed(
      'device',
      arguments: peripheral,
    );
    startDiscovery();
  }
}

extension on _HomeViewState {
  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isPoweredOn,
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
      onRefresh: () async => peripherals.value = [],
      child: ValueListenableBuilder<List<Peripheral>>(
        valueListenable: peripherals,
        builder: (context, peripherals, child) {
          final items = peripherals.where((i) => i.name != null).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(6.0),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items.elementAt(i);
              // final connectable = broadcast.connectable ?? true;
              final manufacturerSpecificData = item.manufacturerSpecificData;
              return Card(
                // color: connectable ? Colors.amber : Colors.grey,
                color: Colors.amber,
                clipBehavior: Clip.antiAlias,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                margin: const EdgeInsets.all(6.0),
                key: ValueKey(item.id),
                child: InkWell(
                  splashColor: Colors.purple,
                  // onTap: connectable
                  //     ? () => showDeviceView(peripheral)
                  //     : null,
                  onTap: () => showDeviceView(item),
                  onLongPress: manufacturerSpecificData == null
                      ? null
                      : () => showManufacturerSpecificData(
                          manufacturerSpecificData),
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
                              Text(item.name ?? ''),
                              Text(
                                item.id,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.rssi.toString(),
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

  Widget buildManufacturerSpecificDataView(Uint8List manufacturerSpecificData) {
    final widgets = <Widget>[
      const Row(
        children: [
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
  late final ValueNotifier<PeripheralState> state;
  late final ValueNotifier<List<GattService>> services;
  late final ValueNotifier<GattService?> service;
  late final ValueNotifier<GattCharacteristic?> characteristic;
  late final TextEditingController writeController;
  late final ValueNotifier<List<String>> logs;
  late final StreamSubscription<(String, PeripheralState)> stateSubscription;
  late final StreamSubscription<(String, String, String, Uint8List)>
      valueChangedSubscription;

  @override
  void initState() {
    super.initState();
    state = ValueNotifier(PeripheralState.disconnected);
    services = ValueNotifier([]);
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    writeController = TextEditingController();
    logs = ValueNotifier([]);
    stateSubscription = cm.peripheralStateChanged.listen(
      (item) {
        final id = item.$1;
        final state = item.$2;
        if (id != widget.peripheral.id) {
          return;
        }
        if (state == PeripheralState.disconnected) {
          service.value = null;
          characteristic.value = null;
          logs.value.clear();
        }
        this.state.value = state;
      },
    );
    valueChangedSubscription = cm.characteristicValueChanged.listen((item) {
      final id = item.$1;
      final serviceId = item.$2;
      final characteristicId = item.$3;
      final value = item.$4;
      if (id != widget.peripheral.id ||
          serviceId != service.value?.id ||
          characteristicId != characteristic.value?.id) {
        return;
      }
      final time = DateTime.now().display;
      final log = '[$time][NOTIFY] ${hex.encode(value)}';
      logs.value = [...logs.value, log];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peripheral.id),
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
    if (state.value == PeripheralState.connected) {
      disconnect();
    }
    stateSubscription.cancel();
    valueChangedSubscription.cancel();
    state.dispose();
    service.dispose();
    characteristic.dispose();
    logs.dispose();
  }

  void connect() async {
    final id = widget.peripheral.id;
    await cm.connect(id);
    try {
      services.value = await cm.discoverServices(id);
    } catch (e) {
      cm.disconnect(id);
      rethrow;
    }
  }

  void disconnect() async {
    final id = widget.peripheral.id;
    cm.disconnect(id);
    service.value = null;
    characteristic.value = null;
    logs.value.clear();
  }
}

extension on _DeviceViewState {
  Widget buildConnectionState(BuildContext context) {
    return ValueListenableBuilder<PeripheralState>(
      valueListenable: state,
      builder: (context, state, child) {
        void Function()? onPressed;
        String data;
        switch (state) {
          case PeripheralState.disconnected:
            onPressed = connect;
            data = '连接';
            break;
          case PeripheralState.connecting:
            data = '连接';
            break;
          case PeripheralState.connected:
            onPressed = disconnect;
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
    return ValueListenableBuilder<PeripheralState>(
      valueListenable: state,
      builder: (context, state, child) {
        switch (state) {
          case PeripheralState.disconnected:
            return buildDisconnectedView(context);
          case PeripheralState.connecting:
            return buildConnectingView(context);
          case PeripheralState.connected:
            return buildConnectedView(context);
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
    return ValueListenableBuilder<List<GattService>>(
      valueListenable: services,
      builder: (context, services, child) {
        return ValueListenableBuilder<GattService?>(
          valueListenable: service,
          builder: (context, service, child) {
            final id = widget.peripheral.id;
            final serviceViews = services.map((service) {
              return DropdownMenuItem<GattService>(
                value: service,
                child: Text(
                  service.id,
                  softWrap: false,
                ),
              );
            }).toList();
            final serviceView = DropdownButton<GattService>(
              isExpanded: true,
              hint: const Text('Choose a service'),
              value: service,
              items: serviceViews,
              onChanged: (service) {
                this.service.value = service;
                characteristic.value = null;
              },
            );
            final views = <Widget>[
              serviceView,
            ];
            if (service != null) {
              final serviceId = service.id;
              final characteristicViews =
                  service.characteristics.map((characteristic) {
                return DropdownMenuItem(
                  value: characteristic,
                  child: Text(
                    characteristic.id,
                    softWrap: false,
                  ),
                );
              }).toList();
              final characteristicView =
                  ValueListenableBuilder<GattCharacteristic?>(
                valueListenable: characteristic,
                builder: (context, characteristic, child) {
                  final canWrite = characteristic != null &&
                      (characteristic.canWrite ||
                          characteristic.canWriteWithoutResponse);
                  final canRead =
                      characteristic != null && characteristic.canRead;
                  final canNotify =
                      characteristic != null && characteristic.canNotify;
                  final readAndNotifyView = Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: canRead
                            ? () async {
                                final value = await cm.readCharacteristic(
                                  id: id,
                                  serviceId: serviceId,
                                  characteristicId: characteristic.id,
                                );
                                final time = DateTime.now().display;
                                final log =
                                    '[$time][READ] ${hex.encode(value)}';
                                logs.value = [...logs.value, log];
                              }
                            : null,
                        icon: const Icon(Icons.archive),
                      ),
                      IconButton(
                        onPressed: canNotify
                            ? () async {
                                await cm.notifyCharacteristic(
                                  id: id,
                                  serviceId: serviceId,
                                  characteristicId: characteristic.id,
                                  value: true,
                                );
                              }
                            : null,
                        icon: const Icon(
                          Icons.notifications,
                          // color: notifying ? Colors.blue : null,
                        ),
                      ),
                    ],
                  );
                  final controllerView = TextField(
                    controller: writeController,
                    decoration: InputDecoration(
                      // hintText: 'MTU: ${peripheral.maximumWriteLength}',
                      suffixIcon: IconButton(
                        onPressed: canWrite
                            ? () async {
                                final elements =
                                    utf8.encode(writeController.text);
                                final value = Uint8List.fromList(elements);
                                final type = characteristic.canWrite
                                    ? GattCharacteristicWriteType.withResponse
                                    : GattCharacteristicWriteType
                                        .withoutResponse;
                                await cm.writeCharacteristic(
                                  id: id,
                                  serviceId: serviceId,
                                  characteristicId: characteristic.id,
                                  value: value,
                                  type: type,
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
                        items: characteristicViews,
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
      },
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
