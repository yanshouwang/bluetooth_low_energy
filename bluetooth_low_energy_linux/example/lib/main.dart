import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runZonedGuarded(onStartUp, onCrashed);
}

void onStartUp() async {
  Logger.root.onRecord.listen(onLogRecord);
  WidgetsFlutterBinding.ensureInitialized();
  await CentralManager.instance.setUp();
  runApp(const MyApp());
}

void onCrashed(Object error, StackTrace stackTrace) {
  Logger.root.shout('App crached.', error, stackTrace);
}

void onLogRecord(LogRecord record) {
  log(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level.value,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
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
          final eventArgs = route!.settings.arguments as DiscoveredEventArgs;
          return PeripheralView(
            eventArgs: eventArgs,
          );
        },
      },
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return const ScannerView();
  }
}

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final ValueNotifier<BluetoothLowEnergyState> state;
  late final ValueNotifier<bool> discovering;
  late final ValueNotifier<List<DiscoveredEventArgs>> discoveredEventArgs;
  late final StreamSubscription stateChangedSubscription;
  late final StreamSubscription discoveredSubscription;

  @override
  void initState() {
    super.initState();
    state = ValueNotifier(BluetoothLowEnergyState.unknown);
    discovering = ValueNotifier(false);
    discoveredEventArgs = ValueNotifier([]);
    stateChangedSubscription = CentralManager.instance.stateChanged.listen(
      (eventArgs) {
        state.value = eventArgs.state;
      },
    );
    discoveredSubscription = CentralManager.instance.discovered.listen(
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
    _initialize();
  }

  void _initialize() async {
    state.value = await CentralManager.instance.getState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Scanner'),
      actions: [
        ValueListenableBuilder(
          valueListenable: state,
          builder: (context, state, child) {
            return ValueListenableBuilder(
              valueListenable: discovering,
              builder: (context, discovering, child) {
                return TextButton(
                  onPressed: state == BluetoothLowEnergyState.poweredOn
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
    );
  }

  Future<void> startDiscovery() async {
    discoveredEventArgs.value = [];
    await CentralManager.instance.startDiscovery();
    discovering.value = true;
  }

  Future<void> stopDiscovery() async {
    await CentralManager.instance.stopDiscovery();
    discovering.value = false;
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: discoveredEventArgs,
      builder: (context, discoveredEventArgs, child) {
        // final items = discoveredEventArgs;
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
              onLongPress: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheet(
                      onClosing: () {},
                      clipBehavior: Clip.antiAlias,
                      builder: (context) {
                        final manufacturerSpecificData =
                            advertisement.manufacturerSpecificData;
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 40.0,
                          ),
                          itemBuilder: (context, i) {
                            const idWidth = 80.0;
                            if (i == 0) {
                              return const Row(
                                children: [
                                  SizedBox(
                                    width: idWidth,
                                    child: Text('ID'),
                                  ),
                                  Expanded(
                                    child: Text('DATA'),
                                  ),
                                ],
                              );
                            } else {
                              final id =
                                  '0x${manufacturerSpecificData!.id.toRadixString(16).padLeft(4, '0')}';
                              final value =
                                  hex.encode(manufacturerSpecificData.data);
                              return Row(
                                children: [
                                  SizedBox(
                                    width: idWidth,
                                    child: Text(id),
                                  ),
                                  Expanded(
                                    child: Text(value),
                                  ),
                                ],
                              );
                            }
                          },
                          separatorBuilder: (context, i) {
                            return const Divider();
                          },
                          itemCount: manufacturerSpecificData == null ? 1 : 2,
                        );
                      },
                    );
                  },
                );
              },
              title: Text(name ?? 'N/A'),
              subtitle: Text(
                '$uuid',
                style: theme.textTheme.bodySmall,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: RssiWidget(rssi),
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
    stateChangedSubscription.cancel();
    discoveredSubscription.cancel();
    state.dispose();
    discovering.dispose();
    discoveredEventArgs.dispose();
  }
}

class PeripheralView extends StatefulWidget {
  final DiscoveredEventArgs eventArgs;

  const PeripheralView({
    super.key,
    required this.eventArgs,
  });

  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView> {
  late final ValueNotifier<bool> connectionState;
  late final DiscoveredEventArgs eventArgs;
  late final ValueNotifier<List<GattService>> services;
  late final ValueNotifier<List<GattCharacteristic>> characteristics;
  late final ValueNotifier<GattService?> service;
  late final ValueNotifier<GattCharacteristic?> characteristic;
  late final ValueNotifier<GattCharacteristicWriteType> writeType;
  late final ValueNotifier<int> rssi;
  late final ValueNotifier<List<Log>> logs;
  late final TextEditingController writeController;
  late final StreamSubscription connectionStateChangedSubscription;
  late final StreamSubscription characteristicNotifiedSubscription;
  late final StreamSubscription rssiChangedSubscription;
  late final Timer rssiTimer;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.eventArgs;
    connectionState = ValueNotifier(false);
    services = ValueNotifier([]);
    characteristics = ValueNotifier([]);
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    writeType = ValueNotifier(GattCharacteristicWriteType.withResponse);
    rssi = ValueNotifier(-100);
    logs = ValueNotifier([]);
    writeController = TextEditingController();
    connectionStateChangedSubscription =
        CentralManager.instance.connectionStateChanged.listen(
      (eventArgs) {
        if (eventArgs.peripheral != this.eventArgs.peripheral) {
          return;
        }
        final connectionState = eventArgs.connectionState;
        this.connectionState.value = connectionState;
        if (!connectionState) {
          services.value = [];
          characteristics.value = [];
          service.value = null;
          characteristic.value = null;
          logs.value = [];
        }
      },
    );
    characteristicNotifiedSubscription =
        CentralManager.instance.characteristicNotified.listen(
      (eventArgs) {
        final characteristic = this.characteristic.value;
        if (eventArgs.characteristic != characteristic) {
          return;
        }
        const type = LogType.notify;
        final log = Log(type, eventArgs.value);
        logs.value = [
          ...logs.value,
          log,
        ];
      },
    );
    rssiTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        final connectionState = this.connectionState.value;
        if (connectionState) {
          rssi.value =
              await CentralManager.instance.readRSSI(eventArgs.peripheral);
        } else {
          rssi.value = -100;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (connectionState.value) {
          final peripheral = eventArgs.peripheral;
          await CentralManager.instance.disconnect(peripheral);
        }
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final title = eventArgs.advertisement.name ?? '';
    return AppBar(
      title: Text(title),
      actions: [
        ValueListenableBuilder(
          valueListenable: connectionState,
          builder: (context, connectionState, child) {
            return TextButton(
              onPressed: () async {
                final peripheral = eventArgs.peripheral;
                if (connectionState) {
                  await CentralManager.instance.disconnect(peripheral);
                  rssi.value = 0;
                } else {
                  await CentralManager.instance.connect(peripheral);
                  services.value =
                      await CentralManager.instance.discoverGATT(peripheral);
                  rssi.value =
                      await CentralManager.instance.readRSSI(peripheral);
                }
              },
              child: Text(connectionState ? 'DISCONNECT' : 'CONNECT'),
            );
          },
        ),
      ],
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
                      characteristics.value = service.characteristics;
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
                    final message = hex.encode(value);
                    return Text.rich(
                      TextSpan(
                        text: '[$type:${value.length}]',
                        children: [
                          TextSpan(
                            text: ' $time: ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: message,
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
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: writeType,
                builder: (context, writeType, child) {
                  return ToggleButtons(
                    onPressed: (i) async {
                      final type = GattCharacteristicWriteType.values[i];
                      this.writeType.value = type;
                    },
                    constraints: const BoxConstraints(
                      minWidth: 0.0,
                      minHeight: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    isSelected: GattCharacteristicWriteType.values
                        .map((type) => type == writeType)
                        .toList(),
                    children: GattCharacteristicWriteType.values.map((type) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Text(type.name),
                      );
                    }).toList(),
                  );
                  // final segments =
                  //     GattCharacteristicWriteType.values.map((type) {
                  //   return ButtonSegment(
                  //     value: type,
                  //     label: Text(type.name),
                  //   );
                  // }).toList();
                  // return SegmentedButton(
                  //   segments: segments,
                  //   selected: {writeType},
                  //   showSelectedIcon: false,
                  //   style: OutlinedButton.styleFrom(
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //     padding: EdgeInsets.zero,
                  //     visualDensity: VisualDensity.compact,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //   ),
                  // );
                },
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: rssi,
                builder: (context, rssi, child) {
                  return RssiWidget(rssi);
                },
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            height: 160.0,
            child: ValueListenableBuilder(
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
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: writeController,
                        enabled: canWrite,
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: characteristic != null && canNotify
                              ? () async {
                                  await CentralManager.instance
                                      .setCharacteristicNotifyState(
                                    characteristic,
                                    state: true,
                                  );
                                }
                              : null,
                          child: const Text('NOTIFY'),
                        ),
                        TextButton(
                          onPressed: characteristic != null && canRead
                              ? () async {
                                  final value = await CentralManager.instance
                                      .readCharacteristic(characteristic);
                                  const type = LogType.read;
                                  final log = Log(type, value);
                                  logs.value = [...logs.value, log];
                                }
                              : null,
                          child: const Text('READ'),
                        ),
                        TextButton(
                          onPressed: characteristic != null && canWrite
                              ? () async {
                                  final text = writeController.text;
                                  final elements = utf8.encode(text);
                                  final value = Uint8List.fromList(elements);
                                  final type = writeType.value;
                                  // Fragments the value by 512 bytes.
                                  var start = 0;
                                  while (start < value.length) {
                                    final end = start + 512;
                                    final trimmedValue = end < value.length
                                        ? value.sublist(start, end)
                                        : value.sublist(start);
                                    await CentralManager.instance
                                        .writeCharacteristic(
                                      characteristic,
                                      value: trimmedValue,
                                      type: type,
                                    );
                                    final log =
                                        Log(LogType.write, trimmedValue);
                                    logs.value = [...logs.value, log];
                                    start = end;
                                  }
                                }
                              : null,
                          child: const Text('WRITE'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rssiTimer.cancel();
    connectionStateChangedSubscription.cancel();
    characteristicNotifiedSubscription.cancel();
    connectionState.dispose();
    services.dispose();
    characteristics.dispose();
    service.dispose();
    characteristic.dispose();
    writeType.dispose();
    rssi.dispose();
    logs.dispose();
    writeController.dispose();
  }
}

class Log {
  final DateTime time;
  final LogType type;
  final Uint8List value;
  final String? detail;

  Log(
    this.type,
    this.value, [
    this.detail,
  ]) : time = DateTime.now();

  @override
  String toString() {
    final type = this.type.toString().split('.').last;
    final formatter = DateFormat.Hms();
    final time = formatter.format(this.time);
    final message = hex.encode(value);
    if (detail == null) {
      return '[$type]$time: $message';
    } else {
      return '[$type]$time: $message /* $detail */';
    }
  }
}

enum LogType {
  read,
  write,
  notify,
  error,
}

class RssiWidget extends StatelessWidget {
  final int rssi;

  const RssiWidget(
    this.rssi, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    if (rssi > -70) {
      icon = Icons.wifi_rounded;
    } else if (rssi > -100) {
      icon = Icons.wifi_2_bar_rounded;
    } else {
      icon = Icons.wifi_1_bar_rounded;
    }
    return Icon(icon);
  }
}
