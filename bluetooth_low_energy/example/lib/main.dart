import 'dart:developer';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:intl/intl.dart';

void main() {
  runZonedGuarded(onStartUp, onCrashed);
}

void onStartUp() async {
  runApp(const MyApp());
}

void onCrashed(Object error, StackTrace stackTrace) {
  log(
    '$error',
    error: error,
    stackTrace: stackTrace,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: const HomeView(),
      routes: {
        'peripheral': (context) {
          final route = ModalRoute.of(context);
          final eventArgs =
              route!.settings.arguments as CentralDiscoveredEventArgs;
          return PeripheralView(
            eventArgs: eventArgs,
          );
        },
      },
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CentralController get centralController => CentralController.instance;
  late final ValueNotifier<CentralState> state;
  late final ValueNotifier<bool> discovering;
  late final ValueNotifier<List<CentralDiscoveredEventArgs>>
      discoveredEventArgs;
  late final StreamSubscription stateChangedSubscription;
  late final StreamSubscription discoveredSubscription;

  @override
  void initState() {
    super.initState();
    state = ValueNotifier(centralController.state);
    discovering = ValueNotifier(false);
    discoveredEventArgs = ValueNotifier([]);
    stateChangedSubscription = centralController.stateChanged.listen(
      (eventArgs) {
        state.value = eventArgs.state;
      },
    );
    discoveredSubscription = centralController.discovered.listen(
      (eventArgs) {
        final items = discoveredEventArgs.value;
        final i = items.indexWhere(
          (item) => item.peripheral == eventArgs.peripheral,
        );
        if (i < 0) {
          discoveredEventArgs.value = [...items, eventArgs];
        } else {
          items[i] = eventArgs;
          discoveredEventArgs.value = [...items];
        }
      },
    );
    setUp();
  }

  void setUp() async {
    await centralController.setUp();
    state.value = centralController.state;
  }

  Future<void> startDiscovery() async {
    await centralController.startDiscovery();
    discovering.value = true;
  }

  Future<void> stopDiscovery() async {
    await centralController.stopDiscovery();
    discovering.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth LowEnergy'),
        actions: [
          ValueListenableBuilder(
            valueListenable: state,
            builder: (context, state, child) {
              return ValueListenableBuilder(
                valueListenable: discovering,
                builder: (context, discovering, child) {
                  return TextButton(
                    onPressed: state == CentralState.poweredOn
                        ? () async {
                            if (discovering) {
                              await stopDiscovery();
                            } else {
                              await startDiscovery();
                            }
                          }
                        : null,
                    child: Text(
                      discovering ? 'END' : 'BEGIN',
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: discoveredEventArgs,
      builder: (context, discoveredEventArgs, child) {
        final items = discoveredEventArgs
            .where((eventArgs) => eventArgs.advertisement.name != null)
            .toList();
        return ListView.separated(
          itemBuilder: (context, i) {
            final theme = Theme.of(context);
            final item = items[i];
            final uuid = item.peripheral.uuid;
            final rssi = item.rssi;
            final advertisement = item.advertisement;
            final name = advertisement.name;
            // final manufacturerSpecificData =
            //     advertisement.manufacturerSpecificData;
            return ListTile(
              onTap: () async {
                final discovering = this.discovering.value;
                if (discovering) {
                  await stopDiscovery();
                }
                if (!mounted) {
                  throw UnimplementedError();
                }
                await Navigator.of(context).pushNamed(
                  'peripheral',
                  arguments: item,
                );
                if (discovering) {
                  await startDiscovery();
                }
              },
              onLongPress: () {},
              title: Text(name ?? '<EMPTY NAME>'),
              subtitle: Text(
                '$uuid',
                style: theme.textTheme.bodySmall,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text('$rssi'),
            );
          },
          separatorBuilder: (context, i) {
            return const Divider(
              height: 0.0,
            );
          },
          itemCount: items.length,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    centralController.tearDown().ignore();
    stateChangedSubscription.cancel();
    discoveredSubscription.cancel();
    state.dispose();
    discovering.dispose();
    discoveredEventArgs.dispose();
  }
}

class PeripheralView extends StatefulWidget {
  final CentralDiscoveredEventArgs eventArgs;

  const PeripheralView({
    super.key,
    required this.eventArgs,
  });

  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView> {
  CentralController get centralController => CentralController.instance;
  late final ValueNotifier<bool> state;
  late final CentralDiscoveredEventArgs eventArgs;
  late final ValueNotifier<List<GattService>> services;
  late final ValueNotifier<List<GattCharacteristic>> characteristics;
  late final ValueNotifier<GattService?> service;
  late final ValueNotifier<GattCharacteristic?> characteristic;
  late final ValueNotifier<List<Log>> logs;
  late final StreamSubscription stateChangedSubscription;
  late final StreamSubscription valueChangedSubscription;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.eventArgs;
    state = ValueNotifier(false);
    services = ValueNotifier([]);
    characteristics = ValueNotifier([]);
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    logs = ValueNotifier([]);
    stateChangedSubscription = centralController.peripheralStateChanged.listen(
      (eventArgs) {
        if (eventArgs.peripheral != this.eventArgs.peripheral) {
          return;
        }
        final state = eventArgs.state;
        this.state.value = state;
        if (!state) {
          services.value = [];
          characteristics.value = [];
          service.value = null;
          characteristic.value = null;
          logs.value = [];
        }
      },
    );
    valueChangedSubscription =
        centralController.characteristicValueChanged.listen(
      (eventArgs) {
        final characteristic = this.characteristic.value;
        if (eventArgs.characteristic != characteristic) {
          return;
        }
        const type = LogType.notify;
        final value = hex.encode(eventArgs.value);
        final log = Log(type, value);
        logs.value = [
          ...logs.value,
          log,
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = eventArgs.advertisement.name ?? '<EMPTY NAME>';
    return WillPopScope(
      onWillPop: () async {
        if (state.value) {
          final peripheral = eventArgs.peripheral;
          await centralController.disconnect(peripheral);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            ValueListenableBuilder(
              valueListenable: state,
              builder: (context, state, child) {
                return TextButton(
                  onPressed: () async {
                    final peripheral = eventArgs.peripheral;
                    if (state) {
                      await centralController.disconnect(peripheral);
                    } else {
                      await centralController.connect(peripheral);
                      await centralController.discoverGATT(peripheral);
                      services.value =
                          await centralController.getServices(peripheral);
                    }
                  },
                  child: Text(state ? 'DISCONNECT' : 'CONNECT'),
                );
              },
            ),
          ],
        ),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder(
            valueListenable: services,
            builder: (context, services, child) {
              final items = services.map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(
                    '${service.uuid}',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList();
              return ValueListenableBuilder(
                valueListenable: service,
                builder: (context, service, child) {
                  return DropdownButton(
                    isExpanded: true,
                    items: items,
                    hint: const Text('CHOOSE A SERVICE'),
                    value: service,
                    onChanged: (service) async {
                      this.service.value = service;
                      characteristic.value = null;
                      if (service == null) {
                        return;
                      }
                      characteristics.value =
                          await centralController.getCharacteristics(service);
                    },
                  );
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: characteristics,
            builder: (context, characteristics, child) {
              final items = characteristics.map((characteristic) {
                return DropdownMenuItem(
                  value: characteristic,
                  child: Text(
                    '${characteristic.uuid}',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList();
              return ValueListenableBuilder(
                valueListenable: characteristic,
                builder: (context, characteristic, child) {
                  return DropdownButton(
                    isExpanded: true,
                    items: items,
                    hint: const Text('CHOOSE A CHARACTERISTIC'),
                    value: characteristic,
                    onChanged: (characteristic) {
                      this.characteristic.value = characteristic;
                    },
                  );
                },
              );
            },
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: logs,
              builder: (context, logs, child) {
                return ListView.builder(
                  itemBuilder: (context, i) {
                    final log = logs[i];
                    final type = log.type.name.toUpperCase().characters.first;
                    final Color typeColor;
                    switch (log.type) {
                      case LogType.read:
                        typeColor = Colors.blue;
                        break;
                      case LogType.write:
                        typeColor = Colors.amber;
                        break;
                      case LogType.notify:
                        typeColor = Colors.red;
                        break;
                      default:
                        typeColor = Colors.black;
                    }
                    final time = DateFormat.Hms().format(log.time);
                    final value = log.value;
                    return Text.rich(
                      TextSpan(
                        text: '[$type]',
                        children: [
                          TextSpan(
                            text: ' $time: ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: value,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: typeColor,
                        ),
                      ),
                    );
                  },
                  itemCount: logs.length,
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 160.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: characteristic,
                  builder: (context, characteristic, child) {
                    final bool canNotify, canRead, canWrite;
                    if (characteristic == null) {
                      canNotify = canRead = canWrite = false;
                    } else {
                      final properties = characteristic.properties;
                      canNotify = properties.contains(
                        GattCharacteristicProperty.notify,
                      );
                      canRead = properties.contains(
                        GattCharacteristicProperty.read,
                      );
                      canWrite = properties.contains(
                        GattCharacteristicProperty.write,
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: canNotify ? () {} : null,
                          child: Text('NOTIFY'),
                        ),
                        TextButton(
                          onPressed: characteristic != null && canRead
                              ? () async {
                                  final value = await centralController
                                      .readCharacteristic(characteristic);
                                  const type = LogType.read;
                                  final text = hex.encode(value);
                                  final log = Log(type, text);
                                  logs.value = [...logs.value, log];
                                }
                              : null,
                          child: Text('READ'),
                        ),
                        TextButton(
                          onPressed: canWrite ? () {} : null,
                          child: Text('WRITE'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    stateChangedSubscription.cancel();
    valueChangedSubscription.cancel();
    state.dispose();
    services.dispose();
    characteristics.dispose();
    service.dispose();
    characteristic.dispose();
  }
}

class Log {
  final DateTime time;
  final LogType type;
  final String value;

  Log(this.type, this.value) : time = DateTime.now();

  @override
  String toString() {
    final type = this.type.toString().split('.').last;
    final formatter = DateFormat.Hms();
    final time = formatter.format(this.time);
    return '[$type]$time: $value';
  }
}

enum LogType {
  read,
  write,
  notify,
  error,
}
